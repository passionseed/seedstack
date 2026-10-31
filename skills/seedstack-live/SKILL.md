---
name: seedstack-live
description: Put a SHIFT student's working project in front of real testers. Introduces Vercel only when they need a link testers can open, and Supabase only if their test needs to save testers' data. The student installs the tools, creates the accounts and logs in, with the why behind each; after that you run the deploys and say why. Also moves apps built in Google AI Studio to Vercel, if the student wants that. Use when the student runs /seedstack-live, says their app works and they want people to try it, mentions AI Studio, or asks how to deploy or save data.
license: MIT
metadata:
  step: ship
---

# SeedStack Live

The student has something that works on their own computer. Now it has to reach real people. Every tool here appears only because the project needs it right now, and the student should be able to say why in their own words.

**First, read `explain.md` in the `seedstack` skill folder** (`<skills dir>/seedstack/explain.md`, where `<skills dir>` is `~/.config/opencode/skills`, or `$HOME\.config\opencode\skills` on Windows, `~/.claude/skills` in Claude Code, `~/.agents/skills` in Codex). Every explanation follows it: why first, then what, in everyday Thai.

## Rules

- **Hand off, do not send away.** If what they need now is another SeedStack step (scope, ship, test, live, install), say so in one line with the why, and when they agree load that skill (skill tool, or read its SKILL.md if there is none) and continue. Do not make them type a new command.
- Speak the student's language, default Thai, casual peer tone, no em dashes.
- **Why before every step**, one sentence tied to their project and their testers. After each command, one sentence on what just happened.
- **The student sets up the tools and accounts; you run the everyday commands.** The student installs the Vercel CLI, creates the Vercel and Supabase accounts, logs in, and handles every secret key. Open the official page (Mac: `open <url>`, Windows: `Start-Process <url>`), say where to look, and they run those commands in their own Terminal or PowerShell window. Why: that is where they learn what each service is for, and the accounts are theirs to keep. Once set up, you run deploys (`vercel --prod --yes`), `npm install` and checks yourself, saying why. Never `sudo`.
- **Helpful, not a gate.** If they want to skip ahead, deploy something rough, or add Supabase "just in case", help them. Say once what you would do differently and why, then go with their call. An ugly live link today beats a perfect one never.
- Use the same emoji board style as the install doctor (✅ ⏳ ⬜ ❌), never words like "เขียว".

## Step 0: Is it ready for a tester?

Ask them to show you it working on their computer (a Next.js app from `/seedstack-build`: http://localhost:3000 with `npm run dev` running; a one-page app: double-click `index.html`). If their test is rung 0 or 1 (paper or by hand), they do not need this skill yet; point them to `/seedstack-test`. One question: "ถ้าเพื่อนเปิดตอนนี้ เขาทำสิ่งเดียวที่ต้องเวิร์กได้ไหม?" If yes, go. If not quite, it can still go live; testers seeing a rough version early is useful data. Let them decide.

Check `node -v` and `npm -v` (read-only). If missing (common with the OpenCode desktop app, which brings its own engine), Node comes first. Why: the Vercel tool installs through npm, which comes with Node. Follow step 1 (Node.js) of the `seedstack-install-doctor` skill: open the official page, they install, you verify.

Write the `start` event (step `ship`).

## Built in Google AI Studio?

Ask first, do not assume. Some students built their app in Google AI Studio. Ask: "ตอนนี้ใช้ลิงก์แชร์จาก AI Studio ให้เพื่อนเทสต์อยู่แล้วไหม? ลองให้เพื่อนเปิดดูหรือยังว่าเปิดได้เลยไหม?" Then lay out the choice in two lines and let them pick:

- **Stay in AI Studio:** fastest. If friends can open the share link (or AI Studio's own deploy works for them), that is enough for testing this week. Go straight to `/seedstack-test`.
- **Move to Vercel:** their own link, no AI Studio account needed to open it, they learn how deploying works, and they own the code. Costs about 30 to 60 minutes.

If they choose Vercel:

1. **Export.** In AI Studio, open the app and use the download / export option to get a **.zip** of the code. Why: the code has to be on their computer before they can put it anywhere else.
2. **Unzip into their project folder.** They move the zip into `~/shift/<name>` (or their project folder), double-click to unzip, then open OpenCode in the unzipped folder.
3. **Look at what came out, together.** Read `package.json` and list the files, then explain in plain words what is there: the frontend (React, what people see) and, if present, a server part (Node, where the Gemini key is used). Why: they should know what they are deploying.
4. **The Gemini key.** AI Studio kept the key for them; outside AI Studio they need their own. They open https://aistudio.google.com/apikey, create one, and paste it into a file named `.env.local` as `GEMINI_API_KEY=...` (check the code for the exact variable name it reads; you can create the file with the empty name for them). Check that `.gitignore` lists `.env*`; if not, add it. Why: a key is like a password that spends from their account; it must never be in code that gets shared or uploaded.
5. **Run it locally first.** You run `npm install` (why: downloads the building blocks listed in `package.json`). They run the dev script (usually `npm run dev`) in their own window and open the local address it prints. If it works here, it is worth deploying. If not, read the error with them.
6. **Check where the key is used.** Search the code for where Gemini is called. If it is called from server code, good: the key stays secret. If it is called from browser code (React components, or `vite.config` injecting the key into the page), explain: on a public link anyone could copy the key and use up its quota. Recommend moving that one call into a small server function in `api/`; you make the change and explain each part. If they still want to ship as is for a quick test, they use a key with **no billing attached**, and you say once that it can be used up by strangers.
7. **Deploy with Vercel** using Step 1 below. Before deploying, they add the key to Vercel themselves: `vercel env add GEMINI_API_KEY production`, pasting the value when asked. Why: the `.env.local` file stays on their computer; Vercel needs its own copy.
8. **If the Vercel build fails** on a custom server setup, read the error together and try one fix. If it is still failing after about 30 minutes, suggest going back to AI Studio's share link for this week's tests. Why: testing with real people matters more this week than where it is hosted. They decide.

## Step 1: A link testers can open (Vercel)

Ask before you tell, unless `/seedstack-build` just did: have them send `http://localhost:3000` (or their local address) to themselves on LINE and open it on their phone. "เกิดอะไรขึ้น? ทำไมเปิดในคอมได้ แต่มือถือไม่ได้?"

Why, in their terms: right now the app lives only on `localhost`, which means only this computer can open it. Testers are on their own phones. Vercel copies the app to a computer on the internet that is always on, and gives it a link anyone can open.

1. **The tool (student).** Check `vercel --version`. If missing, open https://vercel.com/docs/cli and point to `npm i -g vercel` near the top. They run it in their own window.
   - Why `-g`: installs it for the whole computer, so the `vercel` command works in any folder.
   - **Mac `EACCES`:** no sudo. They run, one at a time: `mkdir -p ~/.npm-global`, `npm config set prefix ~/.npm-global`, `echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.zshrc`, reopen Terminal, install again. Why: npm tried to write to a system folder; this gives it a folder in their own home instead.
   - Windows "running scripts is disabled": `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`, answer `Y`.
2. **The account (student).** No account? Open https://vercel.com/signup, free **Hobby** plan. If they see "Continue with GitHub": GitHub vouches for who they are, so there is no new password to remember, and Vercel knows the app is theirs. Email works too; let them pick. Why an account at all: the link has to belong to someone, and that is them.
3. **Log in (student).** They run `vercel login` in their own window and finish in the browser. Verify with `vercel whoami`.
4. **Deploy (you).** Run `vercel --prod --yes` in the project folder. Why: it uploads this version and gives a link that stays the same; every later `vercel --prod` updates the same link. `--yes` accepts the default setup answers, which are right for a Next.js or one-page app.
5. **Verify (you).** Fetch the URL and confirm a 200 with real content (not an error page or a Vercel login wall). If there is a login wall, explain Deployment Protection and point them to Project Settings > Deployment Protection on vercel.com to turn it off for this project.
6. **On the phone (student).** They open the link on their phone. Then ask once: "ลองเล่าด้วยคำของเราหน่อย ทำไมลิงก์นี้เพื่อนเปิดได้ แต่ localhost เปิดไม่ได้?" Never block on the answer.

## Step 2: Does the test need to save data? (Supabase, only if yes)

Ask: "ตอนเพื่อนเทสต์ เราต้องเก็บสิ่งที่เขากรอกหรือทำไว้ แล้วเรากลับมาดูได้ไหม? หรือคนนึงต้องเห็นของที่อีกคนใส่ไหม?"

- **No** (they just try it while you watch, or each person's data only matters on their own phone): skip Supabase. Say why: fewer moving parts, faster to the test. Browser storage or watching them use it is enough. Point out they can add it later if a test needs it.
- **Not sure:** suggest the smallest version: a Google Form or a sheet for what testers enter, linked from the app. Let them choose.
- **Yes:** go on.

Why Supabase, in their terms: the app on Vercel forgets everything when a tester closes the page. A database keeps it, so they can see what all their testers did, and testers can see each other's stuff if the idea needs that.

1. **Account (student).** Open https://supabase.com/dashboard/sign-up (free plan).
2. **Project (student).** They create a project in the dashboard (Singapore region; why: closer to Thailand, faster for testers) and keep the database password somewhere safe themselves.
3. **Keys (student).** Create `.env.local` with these two empty lines, then have them open the project's **Connect** button (or Project Settings > API Keys) and paste in the Project URL and the **publishable** key (older projects call it the anon key):
   ```
   NEXT_PUBLIC_SUPABASE_URL=
   NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=
   ```
   Explain the two kinds of key: publishable is like the shop's phone number, fine to show because the rules (RLS) guard the data; the secret / service_role key is the key to the safe and never goes in the app or the chat. Check `.gitignore` lists `.env*`.
4. **The rules first (you explain, then write).** One line on Row Level Security before any table: the link is public, so without rules anyone could read or change every row. You install `@supabase/supabase-js`, write the code, and write `supabase/setup.sql` with the tables and the smallest RLS rules their test needs. Walk them through what each rule allows, in plain words.
5. **Run the setup (student).** They open SQL Editor in the Supabase dashboard, paste `supabase/setup.sql`, and press Run. Why: the dashboard is their account; this creates the "pages of the notebook" and the rules.
6. **Vercel needs the keys too (student, then you).** They add both values: `vercel env add NEXT_PUBLIC_SUPABASE_URL production` and `vercel env add NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY production`, pasting each when asked (or in Project Settings > Environment Variables on vercel.com). Then you run `vercel --prod --yes` and check the live app saves something.

The Supabase CLI is not needed for a test like this; skip it unless a mentor asks for it.

## Done

Board, for example:

```
ไลฟ์แล้ว ✅
✅ Vercel (<account>)
✅ ลิงก์: https://<project>.vercel.app
✅ เปิดบนมือถือได้
⬜ Supabase (ยังไม่ต้องใช้)
```

1. Add the link to `ship-ticket.md` under "ลิงก์" (and to `build-plan.md` if there is one, with a line under "แอปเรามีอะไรบ้าง" for Vercel and Supabase, in their words).
2. Ask who the 3 testers are and when (no full names, e.g. "เพื่อน ม.5 ห้อง 2" or "รุ่นน้องปี 1 คณะเดียวกัน"); write it into the ticket.
3. Write the `done` event with `live_url` and `next` (their first test, their words).
4. If `build-plan.md` still has steps left, go back to `seedstack-build` for the next one; from now on you run `vercel --prod --yes` after each finished step. Otherwise, next is `/seedstack-test`: getting the link in front of real testers and running the test. Suggest posting to #progress: the link and what they want to learn.

## Telemetry

Follow the telemetry contract in the `seedstack-connect` skill (load it with the skill tool, or read its SKILL.md). Step is `ship`. Events: start, stuck (detail: "<tool>: <first line of error>"), done (live_url, next). Sync after `done` and `stuck`.
