---
name: seedstack-auto-build
description: Fast lane for SHIFT students who are behind or want their idea live as fast as possible. Same tools as /seedstack-guidance-build (Next.js, git, Vercel, and Supabase only if needed), but you do almost all the work, including installing git and the Vercel tool, saving and deploying. The student only does what needs a person: their computer password, creating accounts, logging in, and pasting their own secret keys. One short why per step, no quizzes. Use when the student runs /seedstack auto-build or /seedstack-auto-build, or says they are out of time and want the AI to just build it.
license: MIT
metadata:
  step: ship
---

# SeedStack Auto-build

For a student who is behind, stuck, or just wants to see their idea alive today. Goal: a live link of their idea as fast as possible, built on the same tools as `/seedstack-guidance-build` (Next.js, git, Vercel, Supabase only if needed), so they can switch to building step by step any time.

**First, read `explain.md` in the `seedstack` skill folder** (`<skills dir>/seedstack/explain.md`, where `<skills dir>` is `~/.config/opencode/skills`, or `$HOME\.config\opencode\skills` on Windows, `~/.claude/skills` in Claude Code, `~/.agents/skills` in Codex). In auto-build, use only its first part: one short why per step, in everyday Thai. Skip the "ask before you tell" questions unless they ask why.

## Who does what

| You (the AI) | The student, only what needs a person |
|---|---|
| Folder, Next.js, all the code | Type their computer password or click Install in a popup (Node, git) |
| Install git and use the Vercel tool through `npx` | Create accounts (Vercel, and Supabase if needed) |
| Save with git, deploy, check the live link | Log in, in their own Terminal or PowerShell and the browser |
| Write the database setup and its rules | Paste secret keys into `.env.local`, run the database setup in the Supabase dashboard |

## Rules

- **Hand off, do not send away.** If what they need now is another SeedStack step, say so in one line with the why, and when they agree load that skill (skill tool, or read its SKILL.md if there is none) and continue.
- Speak the student's language, default Thai, casual peer tone, no em dashes.
- **Keep moving.** Do not stop for approval between build steps. Stop only when you need something only a person can do, and then say exactly what to click or type, and why, in one line each.
- **Still say why.** Every step gets one short line of why before or after it, so they can explain their own app at Demo Day. Never more than one line unless they ask.
- **Never `sudo`.** If an install needs a password, the student types it in the popup or their own window.
- **Secrets stay out of chat.** Never ask for a secret key, a service_role key or a database password in the chat, and never read them from files. The Supabase project URL and publishable key are public by design (they end up in every visitor's browser), so you may handle those.
- Use the emoji board (✅ ⏳ ⬜ ❌).

## 1. The idea

Write the `start` event with detail "auto-build". Check for SeedStack updates once (see `seedstack-connect`).

Their idea is usually in their message (`/seedstack auto-build เว็บจองคิวร้านตัดผม`). If not, ask one question: "อยากสร้างอะไร ให้ใครใช้?" Read `scope-card.md` and `ship-ticket.md` if they exist. Do not ask anything else; decide the rest yourself and say what you decided in one line.

Show the board and keep it updated:

```
Auto-build
⏳ ตั้งโปรเจกต์
⬜ สร้างแอป
⬜ save (git)
⬜ ขึ้นเน็ต (Vercel)
```

## 2. Set up (fast)

1. **Folder.** Same as part 2 of `seedstack-guidance-build`: use the current folder if it is for this project; otherwise create `~/shift/<name>` (Windows `$HOME\shift\<name>`) with a short lowercase name you pick from the idea.
2. **Node.** `node -v` (needs 20.9 or newer).
   - Windows: run `winget install -e --id OpenJS.NodeJS.LTS`; the student clicks Yes if a popup asks.
   - Mac: open https://nodejs.org/en/download (`open <url>`); the student downloads the LTS `.pkg` and clicks through (it asks for their password).
   - Why: "Next.js รันบน Node ถ้าไม่มี คอมเราเปิดแอปไม่ได้".
3. **git, started early.** `git --version`. If missing, start it now so it installs while you build:
   - Mac: `xcode-select --install`; the student clicks Install in the popup (a few minutes).
   - Windows: `winget install -e --id Git.Git`; the student clicks Yes if asked.
   - Why: "git คือปุ่ม save ของทั้งโปรเจกต์ พังเมื่อไหร่ย้อนได้".
4. **Next.js.** Use the same `npx create-next-app@latest ... --yes --use-npm --disable-git` commands as part 2 of `seedstack-guidance-build` (including the `app-tmp` route when the folder has files). Read the generated `AGENTS.md` before writing code. Why: "โครงเว็บสำเร็จรูป เราไม่ต้องเริ่มจากศูนย์".
5. **Windows tips.** If `npm` says "running scripts is disabled", the student runs `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` and answers `Y`. If winget stops to ask them to accept terms, the student runs that same command in their own PowerShell and answers. After a winget install, refresh PATH in your shell: `$env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")`.

## 3. Build the first version

Build the whole first version in two or three chunks, without stopping in between:
1. The main screen with fake data.
2. The one thing a user must be able to do, still with fake data.
3. Polish only what blocks using it on a phone (layout fits a small screen, buttons big enough).

After each chunk, check with `npx tsc --noEmit` and `npm run lint`, and fix what you broke. At the end run `npm run build`; it must pass before going live. No login and no database in the first version unless the idea cannot work without them.

Then save. If git is ready: set a name for this project if none is set (`git config user.name "<their name>"` and `git config user.email "<their email>"`, asking for them once), then `git init`, `git add -A`, `git commit -m "เวอร์ชันแรก: <idea>"`. Why: "save แรกแล้ว ถ้าแก้ต่อแล้วพัง กลับมาตรงนี้ได้". If git is still installing, carry on and save after going live.

## 4. Go live (Vercel)

Why: "ตอนนี้แอปอยู่แค่ในคอมเรา Vercel ทำให้เพื่อนเปิดบนมือถือได้".

1. **Account (student).** Open https://vercel.com/signup. The free Hobby plan is enough. "Continue with GitHub" or email both work; one line why if they ask about GitHub: "ให้ GitHub ยืนยันตัวตนแทน ไม่ต้องตั้งรหัสใหม่".
2. **Log in (student).** They run `npx vercel@latest login` in their own Terminal or PowerShell window and finish in the browser. Why `npx`: it uses the Vercel tool without installing it for the whole computer.
3. **Deploy (you).** `npx vercel@latest --prod --yes` in the project folder.
4. **Check (you).** Fetch the URL; it must return 200 with their app, not an error or a Vercel login page. If there is a login page, point them to the project's Settings > Deployment Protection on vercel.com to turn it off.
5. They open the link on their phone. Show the board with ✅ ขึ้นเน็ต and the link.

## 5. Data, only if the idea needs it

Only if the app must keep what users enter (a booking, a sign-up, a list others can see). Why: "หน้าเว็บลืมทุกอย่างเมื่อปิด Supabase คือสมุดจดของแอป".

1. **Student:** sign up at https://supabase.com/dashboard/sign-up, create a project (region Singapore; why: closer to Thailand, faster), and keep the database password somewhere safe themselves.
2. **Student:** open the project's **Connect** button (or Project Settings > API Keys) and paste the Project URL and the publishable key (older projects call it anon key) into `.env.local`, which you create with these two empty lines:
   ```
   NEXT_PUBLIC_SUPABASE_URL=
   NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=
   ```
3. **You:** `npm install @supabase/supabase-js`, write the code, and write `supabase/setup.sql` with the tables and Row Level Security rules that allow only what the app needs. Why RLS: "ลิงก์แอปเป็นสาธารณะ ถ้าไม่มีกฎ คนแปลกหน้าแก้ข้อมูลได้".
4. **Student:** open SQL Editor in the Supabase dashboard, paste `supabase/setup.sql`, press Run.
5. **You:** add both public values to Vercel (`npx vercel@latest env add NEXT_PUBLIC_SUPABASE_URL production`, then the key, giving each value on stdin from `.env.local`), redeploy with `npx vercel@latest --prod --yes`, and check the live app saves something.

If the app needs a secret key (for example, calling an AI): the student creates it and pastes it into `.env.local` and runs `npx vercel@latest env add <NAME> production` themselves; you use it only in server code.

## 6. Done

Save (`git add -A`, `git commit -m "..."`), then show:

```
Auto-build ✅
✅ แอป Next.js
✅ save แล้ว (git)
✅ ลิงก์: https://<project>.vercel.app
```

Then a short "แอปเรามีอะไรบ้าง", one line per part with why, so they can explain it to testers and at Demo Day:

```
💻 Next.js: โครงของเว็บ หน้าต่าง ๆ อยู่ในโฟลเดอร์ app
💾 git: save ทุกเวอร์ชัน พังเมื่อไหร่ย้อนได้
🌐 Vercel: ทำให้คนอื่นเปิดบนมือถือได้
📒 Supabase: จำสิ่งที่ผู้ใช้กรอกไว้ (ถ้ามี)
```

Write `build-plan.md` from the `seedstack-guidance-build` template: what was built as ✅ steps, the link, this list, and ideas for later. Why: if they switch to `/seedstack-guidance-build`, it picks up from here.

Write the `done` event (detail "auto-build", `live_url`, `next`: their first test). Then hand off to `seedstack-test`: the link is ready, now real people should try it. Mention once that `/seedstack-guidance-build` is there when they want to change things step by step and set up the tools themselves.

## Telemetry

Follow the telemetry contract in the `seedstack-connect` skill (load it with the skill tool, or read its SKILL.md). Step is `ship`, with detail "auto-build" on every event. Events: start, stuck (detail: "auto-build: <tool>: <first line of error>"), done (live_url, next). Sync after `done` and `stuck`.
