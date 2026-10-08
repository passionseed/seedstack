---
name: seedstack-live
description: Put a SHIFT student's working project in front of real testers. Introduces the Vercel CLI only when they need a link testers can open, and the Supabase CLI only if their test needs to save testers' data. Teaches the why behind each step; the student installs and runs every command. Use when the student runs /seedstack-live, says their app works and they want people to try it, or asks how to deploy or save data.
license: MIT
metadata:
  step: ship
---

# SeedStack Live

The student has something that works on their own computer. Now it has to reach real people. Every tool here appears only because the project needs it right now, and the student should be able to say why in their own words.

## Rules

- Speak the student's language, default Thai, casual peer tone, no em dashes.
- **Why before every step**, one sentence tied to their project and their testers. After each command, one sentence on what just happened.
- **Never install or log in for them.** Open the official page (Mac: `open <url>`, Windows: `Start-Process <url>`), say where to look, and they run commands in their own Terminal or PowerShell window. You run read-only checks (`vercel --version`, `vercel whoami`, `npx supabase@latest --version`) and fetch their live URL to verify.
- **Helpful, not a gate.** If they want to skip ahead, deploy something rough, or install Supabase "just in case", help them. Say once what you would do differently and why, then go with their call. An ugly live link today beats a perfect one never.
- Use the same emoji board style as the install doctor (✅ ⏳ ⬜ ❌), never words like "เขียว".

## Step 0: Is it ready for a tester?

Ask them to show you it working on their computer (a one-page app: double-click `index.html`; a framework app: they run it themselves, e.g. `npm run dev`). If their test is rung 0 or 1 (paper or by hand), they do not need this skill yet; point them to `/seedstack-test`. One question: "ถ้าเพื่อนเปิดตอนนี้ เขาทำสิ่งเดียวที่ต้องเวิร์กใน ship ticket ได้ไหม?" If yes, go. If not quite, it can still go live; testers seeing a rough version early is useful data. Let them decide.

Write the `start` event (step `ship`).

## Step 1: A link testers can open (Vercel)

Why, in their terms: right now the app lives only on `localhost`, which means only this computer can open it. Testers are on their own phones. Vercel copies the app to a server on the internet and gives it a link anyone can open.

1. Check `vercel --version`. If missing, open https://vercel.com/docs/cli and point to `npm i -g vercel` near the top. They run it.
   - Why `-g`: installs it for the whole computer, so the `vercel` command works in any folder.
   - **Mac `EACCES`:** no sudo. They run, one at a time: `mkdir -p ~/.npm-global`, `npm config set prefix ~/.npm-global`, `echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> ~/.zshrc`, reopen Terminal, install again. Why: npm tried to write to a system folder; this gives it a folder in their own home instead.
   - Windows "running scripts is disabled": `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`, answer `Y`.
2. No account? Open https://vercel.com/signup, free **Hobby** plan. Then `vercel login`, finish in the browser. Why: the link has to belong to someone, and that is them. Verify `vercel whoami`.
3. In the project folder, they run `vercel`. It asks a few setup questions; defaults are usually right (a single `index.html` needs no build settings). Why: this makes a **preview** link, a private test copy they can check first.
4. They open the preview link on their **phone**. Why: that is how testers will see it.
5. When happy: `vercel --prod`. Why: this is the stable link to share; every new `vercel --prod` updates the same link.
6. Verify: fetch the URL, confirm a 200 with real content (not an error page or a Vercel login wall). If there is a login wall, explain Deployment Protection and point them to Project Settings > Deployment Protection on vercel.com to turn it off for this project.

## Step 2: Does the test need to save data? (Supabase, only if yes)

Ask: "ตอนเพื่อนเทสต์ เราต้องเก็บสิ่งที่เขากรอกหรือทำไว้ แล้วเรากลับมาดูได้ไหม? หรือคนนึงต้องเห็นของที่อีกคนใส่ไหม?"

- **No** (they just try it while you watch, or each person's data only matters on their own phone): skip Supabase. Say why: fewer moving parts, faster to the test. Browser storage or watching them use it is enough. Point out they can add it later if a test needs it.
- **Not sure:** suggest the smallest version: a Google Form or a sheet for what testers enter, linked from the app. Let them choose.
- **Yes:** go on.

Why Supabase, in their terms: the app on Vercel forgets everything when a tester closes the page. A database keeps it, so they can see what all their testers did, and testers can see each other's stuff if the idea needs that.

1. Open https://supabase.com/dashboard/sign-up if they have no account (free plan).
2. Open https://supabase.com/docs/guides/local-development/cli/getting-started, point to the **npx** option. They run `npx supabase@latest --version` (answer `y`). Why npx: Supabase does not support global install; npx downloads it when needed.
3. They run `npx supabase@latest login`, finish in the browser.
4. They create a project in the Supabase dashboard (pick the Singapore region for Thailand; why: closer server, faster for testers). They save the database password somewhere safe themselves.
5. For connecting the app: the project URL and the **anon** key from Project Settings > API go into environment variables, never pasted into code. Why: keys in code end up public on GitHub. Locally they go in `.env.local`; on Vercel, in Project Settings > Environment Variables (or `vercel env add`). Then `vercel --prod` again so the live link picks them up.
6. Explain Row Level Security in one line before they create tables: by default, anyone with the link could read or change every row; RLS rules decide who can see what. Help them write the smallest rule their test needs.

Building the data part of the app is their work with OpenCode as the tool; you help and explain.

## Done

Board, for example:

```
ไลฟ์แล้ว ✅
✅ Vercel (<account>)
✅ ลิงก์: https://<project>.vercel.app
✅ เปิดบนมือถือได้
⬜ Supabase (ยังไม่ต้องใช้)
```

1. Add the link to `ship-ticket.md` under "ลิงก์".
2. Ask who the 3 testers are and when (no full names, e.g. "เพื่อน ม.5 ห้อง 2"); write it into the ticket.
3. Write the `done` event with `live_url` and `next` (their first test, their words).
4. Next is `/seedstack-test`: getting the link in front of real testers and running the test. Suggest posting to #progress: the link and what they want to learn.

## Telemetry

Follow the telemetry contract in the `seedstack-connect` skill (load it with the skill tool). Step is `ship`. Events: start, stuck (detail: "<tool>: <first line of error>"), done (live_url, next). Sync after `done` and `stuck`.
