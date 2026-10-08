#!/usr/bin/env node
// SeedStack telemetry sync. No dependencies, Node 18+.
//
//   node sync.mjs link        start linking: prints a URL + code to approve in the browser
//   node sync.mjs link-wait   wait up to ~90s for approval, then store the token (re-run if pending)
//   node sync.mjs forget      delete the stored token
//   node sync.mjs check-update   say whether a newer SeedStack exists
//   node sync.mjs update         download the latest SeedStack into every place it is installed
//   node sync.mjs status                   connected or local-only
//   node sync.mjs [sync]                   send unsent events, then exit
//
// Events stay in ~/.seedstack/events.jsonl. Nothing leaves this computer until the
// student links this device after signing in with Discord,
// and the server refuses events unless the student agreed on /shift/seedstack.

import { chmodSync, cpSync, existsSync, mkdirSync, mkdtempSync, readdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { homedir, tmpdir } from "node:os";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const API = process.env.SEEDSTACK_API_URL ?? "https://www.passionseed.org";
const HOME_DIR = join(homedir(), ".seedstack");
const TOKEN_FILE = join(HOME_DIR, "token");
const SENT_FILE = join(HOME_DIR, "sent.json");
const PENDING_FILE = join(HOME_DIR, "link.json");
const WAIT_MS = 90_000;
// Home folder only: a project folder could come from someone else's repo.
const EVENT_FILE = join(HOME_DIR, "events.jsonl");
const BATCH = 100;
const VERSION_URL = "https://raw.githubusercontent.com/passionseed/seedstack/main/skills/seedstack-connect/VERSION";
const LOCAL_VERSION_FILE = join(dirname(fileURLToPath(import.meta.url)), "VERSION");
const REPO = "passionseed/seedstack";
const RAW = `https://raw.githubusercontent.com/${REPO}/main`;
// Every place an installer may have put SeedStack: [skills dir, commands dir or null].
const OPENCODE_DIR = join(process.env.XDG_CONFIG_HOME ?? join(homedir(), ".config"), "opencode");
const INSTALL_TARGETS = [
  [join(OPENCODE_DIR, "skills"), join(OPENCODE_DIR, "commands")],
  [join(homedir(), ".claude", "skills"), join(homedir(), ".claude", "commands")],
  [join(homedir(), ".agents", "skills"), null],
];
// Only these keys ever leave the computer, whatever else ends up in the file.
const FIELDS = ["id", "ts", "step", "event", "minutes", "next", "detail", "live_url"];

function parseJson(text, fallback) {
  try {
    return JSON.parse(text);
  } catch {
    return fallback;
  }
}

function readJson(file, fallback) {
  return existsSync(file) ? parseJson(readFileSync(file, "utf8"), fallback) : fallback;
}

function pick(event) {
  return Object.fromEntries(FIELDS.filter((key) => key in event).map((key) => [key, event[key]]));
}

function readToken() {
  return existsSync(TOKEN_FILE) ? readFileSync(TOKEN_FILE, "utf8").trim() : null;
}

function readEvents() {
  const byId = new Map();
  if (!existsSync(EVENT_FILE)) return [];
  for (const line of readFileSync(EVENT_FILE, "utf8").split(/\r?\n/)) {
    const event = parseJson(line, null);
    if (event && typeof event.id === "string") byId.set(event.id, pick(event));
  }
  return [...byId.values()];
}


async function postJson(path, body, token) {
  const headers = { "content-type": "application/json" };
  if (token) headers.authorization = `Bearer ${token}`;
  const res = await fetch(`${API}${path}`, { method: "POST", headers, body: JSON.stringify(body ?? {}) });
  return { status: res.status, body: await res.json().catch(() => ({})) };
}

async function sync() {
  const token = readToken();
  if (!token) return console.log("SeedStack: local only (not connected). Events stay on this computer.");

  const sent = new Set(readJson(SENT_FILE, []));
  const pending = readEvents().filter((e) => !sent.has(e.id));
  if (pending.length === 0) return console.log("SeedStack: up to date.");

  for (let i = 0; i < pending.length; i += BATCH) {
    const chunk = pending.slice(i, i + BATCH);
    let result;
    try {
      result = await postJson("/api/seedstack/events", { events: chunk }, token);
    } catch {
      return console.log("SeedStack: offline, will retry next time. Events are safe locally.");
    }
    if (result.status === 403) {
      return console.log("SeedStack: not agreed yet at /shift/seedstack (or withdrawn). Kept locally.");
    }
    if (result.status === 401) {
      return console.log("SeedStack: connect code expired or withdrawn. Get a new one at /shift/seedstack.");
    }
    if (result.status !== 200) {
      return console.log(`SeedStack: server said ${result.status}, will retry next time.`);
    }
    chunk.forEach((e) => sent.add(e.id));
    mkdirSync(HOME_DIR, { recursive: true });
    writeFileSync(SENT_FILE, JSON.stringify([...sent]));
  }
  console.log(`SeedStack: sent ${pending.length} event(s) to your mentors.`);
}

function writePrivate(file, text) {
  mkdirSync(HOME_DIR, { recursive: true, mode: 0o700 });
  // Create owner-only from the start; chmod covers a file left by an older version.
  writeFileSync(file, text, { mode: 0o600 });
  try {
    chmodSync(file, 0o600);
  } catch {
    // Windows: file ACLs already limit it to the user profile.
  }
}


async function link() {
  let result;
  try {
    result = await postJson("/api/seedstack/link/start");
  } catch {
    return console.log("SeedStack: cannot reach passionseed.org. Check the internet and try again.");
  }
  if (result.status !== 200) return console.log(`SeedStack: server said ${result.status}, try again in a minute.`);

  const { device_code, user_code, url } = result.body;
  writePrivate(PENDING_FILE, JSON.stringify({ device_code, user_code }));
  console.log(`SeedStack: open this link, sign in with Discord, and type this code there.`);
  console.log(`  ${url}`);
  console.log(`  code: ${user_code}`);
}

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function linkWait() {
  const pending = readJson(PENDING_FILE, null);
  if (!pending?.device_code) return console.log("SeedStack: no link in progress. Run: node sync.mjs link");

  const deadline = Date.now() + WAIT_MS;
  while (Date.now() < deadline) {
    let result;
    try {
      result = await postJson("/api/seedstack/link/poll", { device_code: pending.device_code });
    } catch {
      await sleep(3000);
      continue;
    }
    if (result.status === 410) {
      rmSync(PENDING_FILE, { force: true });
      return console.log("SeedStack: link expired. Run: node sync.mjs link");
    }
    if (result.body.status === "approved" && result.body.token) {
      writePrivate(TOKEN_FILE, result.body.token);
      rmSync(PENDING_FILE, { force: true });
      console.log("SeedStack: linked. Syncing...");
      return sync();
    }
    await sleep(3000);
  }
  console.log(`SeedStack: still waiting for approval of code ${pending.user_code}. Run link-wait again after approving.`);
}

async function checkUpdate() {
  const local = existsSync(LOCAL_VERSION_FILE) ? readFileSync(LOCAL_VERSION_FILE, "utf8").trim() : "unknown";
  let latest;
  try {
    const res = await fetch(VERSION_URL, { signal: AbortSignal.timeout(5000) });
    latest = res.ok ? (await res.text()).trim() : null;
  } catch {
    latest = null;
  }
  if (!latest) return console.log(`SeedStack ${local}: could not check for updates (offline?).`);
  if (latest === local) return console.log(`SeedStack ${local}: up to date.`);
  console.log(`SeedStack update available: ${local} -> ${latest}. Type /seedstack-update (Codex: say "update SeedStack").`);
}

/** Lists repo files under skills/ and commands/ via one GitHub API call. */
async function listRepoFiles() {
  const res = await fetch(`https://api.github.com/repos/${REPO}/git/trees/main?recursive=1`, {
    signal: AbortSignal.timeout(10000),
  });
  if (!res.ok) throw new Error(`GitHub said ${res.status}`);
  const { tree } = await res.json();
  return tree
    .filter((item) => item.type === "blob" && /^(skills\/seedstack[^/]*\/|commands\/seedstack[^/]*\.md$)/.test(item.path))
    .map((item) => item.path);
}

/** Downloads everything to a temp folder first, so a failed download changes nothing. */
async function downloadRelease() {
  const dir = mkdtempSync(join(tmpdir(), "seedstack-"));
  for (const path of await listRepoFiles()) {
    const res = await fetch(`${RAW}/${path}`, { signal: AbortSignal.timeout(10000) });
    if (!res.ok) throw new Error(`download failed for ${path} (${res.status})`);
    mkdirSync(dirname(join(dir, path)), { recursive: true });
    writeFileSync(join(dir, path), Buffer.from(await res.arrayBuffer()));
  }
  return dir;
}

function replaceSeedstack(fromDir, toDir, isSkills) {
  mkdirSync(toDir, { recursive: true });
  for (const name of readdirSync(toDir)) {
    if (name.startsWith("seedstack")) rmSync(join(toDir, name), { recursive: true, force: true });
  }
  for (const name of readdirSync(fromDir)) {
    if (name.startsWith("seedstack")) cpSync(join(fromDir, name), join(toDir, name), { recursive: isSkills });
  }
}

async function update() {
  const targets = INSTALL_TARGETS.filter(([skills]) => existsSync(join(skills, "seedstack-connect")));
  if (targets.length === 0) return console.log("SeedStack: no install found. Use the install line instead.");

  let release;
  try {
    release = await downloadRelease();
  } catch (error) {
    return console.log(`SeedStack: update failed (${error.message}). Nothing changed. Try again, or use the install line.`);
  }
  for (const [skills, commands] of targets) {
    replaceSeedstack(join(release, "skills"), skills, true);
    if (commands) replaceSeedstack(join(release, "commands"), commands, false);
  }
  rmSync(release, { recursive: true, force: true });
  const version = readFileSync(join(targets[0][0], "seedstack-connect", "VERSION"), "utf8").trim();
  console.log(`SeedStack updated to ${version} (${targets.length} place${targets.length > 1 ? "s" : ""}). Quit OpenCode fully and open it again to use it.`);
}

const [command = "sync"] = process.argv.slice(2);
const commands = {
  link,
  "link-wait": linkWait,
  forget: () => {
    rmSync(TOKEN_FILE, { force: true });
    console.log("SeedStack: disconnected. Nothing more will be sent.");
  },
  status: () => console.log(readToken() ? "SeedStack: connected." : "SeedStack: local only."),
  "check-update": checkUpdate,
  update,
  sync,
};

await (commands[command] ?? sync)();
