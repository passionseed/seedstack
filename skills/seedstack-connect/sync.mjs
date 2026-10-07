#!/usr/bin/env node
// SeedStack telemetry sync. No dependencies, Node 18+.
//
//   node sync.mjs save-token <psss_...>   store the connect code from /shift/seedstack
//   node sync.mjs forget                   delete the stored code
//   node sync.mjs status                   connected or local-only
//   node sync.mjs [sync]                   send unsent events, then exit
//
// Events stay in ~/.seedstack/events.jsonl. Nothing leaves this computer without a code,
// and the server refuses events unless the student and a parent consented.

import { chmodSync, existsSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

const API = process.env.SEEDSTACK_API_URL ?? "https://www.passionseed.org";
const HOME_DIR = join(homedir(), ".seedstack");
const TOKEN_FILE = join(HOME_DIR, "token");
const SENT_FILE = join(HOME_DIR, "sent.json");
// Home folder only: a project folder could come from someone else's repo.
const EVENT_FILE = join(HOME_DIR, "events.jsonl");
const BATCH = 100;
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

async function post(token, events) {
  const res = await fetch(`${API}/api/seedstack/events`, {
    method: "POST",
    headers: { "content-type": "application/json", authorization: `Bearer ${token}` },
    body: JSON.stringify({ events }),
  });
  const body = await res.json().catch(() => ({}));
  return { status: res.status, body };
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
      result = await post(token, chunk);
    } catch {
      return console.log("SeedStack: offline, will retry next time. Events are safe locally.");
    }
    if (result.status === 403) {
      return console.log("SeedStack: waiting for consent (student + parent) at /shift/seedstack. Kept locally.");
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

function saveToken(token) {
  if (!/^psss_[A-Za-z0-9_-]{20,}$/.test(token ?? "")) {
    console.log("SeedStack: that does not look like a connect code (starts with psss_).");
    process.exitCode = 1;
    return;
  }
  mkdirSync(HOME_DIR, { recursive: true, mode: 0o700 });
  // Create owner-only from the start; chmod covers a file left by an older version.
  writeFileSync(TOKEN_FILE, token, { mode: 0o600 });
  try {
    chmodSync(TOKEN_FILE, 0o600);
  } catch {
    // Windows: file ACLs already limit it to the user profile.
  }
  console.log("SeedStack: connected. Syncing...");
  return sync();
}

const [command = "sync", arg] = process.argv.slice(2);
const commands = {
  "save-token": () => saveToken(arg),
  forget: () => {
    rmSync(TOKEN_FILE, { force: true });
    console.log("SeedStack: disconnected. Nothing more will be sent.");
  },
  status: () => console.log(readToken() ? "SeedStack: connected." : "SeedStack: local only."),
  sync,
};

await (commands[command] ?? sync)();
