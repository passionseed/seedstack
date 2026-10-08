---
name: seedstack-live
description: Put a SHIFT student's working project in front of real testers. Introduces the Vercel CLI only when they need a link testers can open, and the Supabase CLI only if their test needs to save testers' data. Teaches the why behind each step; the student installs and runs every command. Also moves apps built in Google AI Studio to Vercel, if the student wants that. Use when the student runs /seedstack-live, says their app works and they want people to try it, mentions AI Studio, or asks how to deploy or save data.
license: MIT
metadata:
  step: ship
---

# SeedStack Live

The student has something that works on their own computer. Now it has to reach real people. Every tool here appears only because the project needs it right now, and the student should be able to say why in their own words.

## Rules

- **Hand off, do not send away.** If what they need now is another SeedStack step (scope, ship, test, live, install), say so in one line with the why, and when they agree load that skill (skill tool, or read its SKILL.md if there is none) and continue. Do not make them type a new command.
- Speak the student's language, default Thai, casual peer tone, no em dashes.
- **Why before every step**, one sentence tied to their project and their testers. After each command, one sentence on what just happened.
- **Never install or log in for them.** Open the official page (Mac: `open <url>`, Windows: `Start-Process <url>`), say where to look, and they run commands in their own Terminal or PowerShell window. You run read-only checks (`vercel --version`, `vercel whoami`, `npx supabase@latest --version`) and fetch their live URL to verify.
- **Helpful, not a gate.** If they want to skip ahead, deploy something rough, or install Supabase "just in case", help them. Say once what you would do differently and why, then go with their call. An ugly live link today beats a perfect one never.
- Use the same emoji board style as the install doctor (✅ ⏳ ⬜ ❌), never words like "เขียว".

## Step 0: Is it ready for a tester?

Ask them to show you it working on their computer (a one-page app: double-click `index.html`; a framework app: they run it themselves, e.g. `npm run dev`). If their test is rung 0 or 1 (paper or by hand), they do not need this skill yet; point them to `/seedstack-test`. One question: "ถ้าเพื่อนเปิดตอนนี้ เขาทำสิ่งเดียวที่ต้องเวิร์กใน ship ticket ได้ไหม?" If yes, go. If not quite, it can still go live; testers seeing a rough version early is useful data. Let them decide.

Check `node -v` and `npm -v` (read-only). If missing (common with the OpenCode desktop app, which brings its own engine), Node comes first. Why: the Vercel tool installs through npm, which comes with Node, and an AI Studio export runs on it too. Follow step 1 (Node.js) of the `seedstack-install-doctor` skill: open the official page, they install, you verify. Git and the folder step are optional here.

Write the `start` event (step `ship`).

## Built in Google AI Studio?

Ask first, do not assume. Some students built their app in Google AI Studio. Ask: "ตอนนี้ใช้ลิงก์แชร์จาก AI Studio ให้เพื่อนเทสต์อยู่แล้วไหม? ลองให้เพื่อนเปิดดูหรือยังว่าเปิดได้เลยไหม?" Then lay out the choice in two lines and let them pick:

- **Stay in AI Studio:** fastest. If friends can open the share link (or AI Studio's own deploy works for them), that is enough for testing this week. Go straight to `/seedstack-test`.
- **Move to Vercel:** their own link, no AI Studio account needed to open it, they learn how deploying works, and they own the code. Costs about 30 to 60 minutes.

If they choose Vercel:

1. **Export.** In AI Studio, open the app and use the download / export option to get a **.zip** of the code. Why: the code has to be on their computer before they can put it anywhere else.
2. **Unzip into their project folder.** They move the zip into `~/shift/<name>` (or their project folder), double-click to unzip, then in their terminal `cd` into the unzipped folder and open OpenCode there.
3. **Look at what came out, together.** You read `package.json` and list the files (read-only) and explain in plain words what is there: the frontend (React, what people see) and, if present, a server part (Node, where the Gemini key is used). Why: they should know what they are deploying.
4. **The Gemini key.** AI Studio kept the key for them; outside AI Studio they need their own. They open https://aistudio.google.com/apikey and create one. They put it in a file named `.env.local` as `GEMINI_API_KEY=...` (check the code for the exact variable name it reads). Check that `.gitignore` lists `.env*`; if not, they add it. Why: a key is like a password that spends from their account; it must never be in code that gets shared or uploaded.
5. **Run it locally first.** They run `npm install` (why: downloads the building blocks listed in `package.json`), then the dev script in `package.json` (usually `npm run dev`), and open the local address it prints. If it works here, it is worth deploying. If not, read the error with them.
6. **Check where the key is used.** Search the code (read-only) for where Gemini is called. If it is called from server code, good: the key stays secret. If it is called from browser code (React components, or `vite.config` injecting the key into the page), explain: on a public link anyone could copy the key and use up its quota. Recommend moving that one call into a small server function in `api/` (they do it with OpenCode as their tool; you explain each part). If they still want to ship as is for a quick test, they use a key with **no billing attached**, and you say once that it can be used up by strangers.
7. **Deploy with Vercel** using Step 1 below. Before `vercel --prod`, they add the key to Vercel: `vercel env add GEMINI_API_KEY` (choose Production and Preview). Why: the `.env.local` file stays on their computer; Vercel needs its own copy.
8. **If the Vercel build fails** on a custom server setup, read the error together and try one fix. If it is still failing after about 30 minutes, suggest going back to AI Studio's share link for this week's tests. Why: testing with real people matters more this week than where it is hosted. They decide.

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

Follow the telemetry contract in the `seedstack-connect` skill (load it with the skill tool, or read its SKILL.md). Step is `ship`. Events: start, stuck (detail: "<tool>: <first line of error>"), done (live_url, next). Sync after `done` and `stuck`.
