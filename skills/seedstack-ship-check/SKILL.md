---
name: seedstack-ship-check
description: Pre-build and post-deploy gate for SHIFT students. Reads scope-card.md and the paper prototype, checks that a real user is named, a 48-hour test is planned and the student stated their own cut, then writes ship-ticket.md. After the student deploys with the Vercel CLI, verifies the live URL. Use when the student runs /seedstack-ship.
license: MIT
metadata:
  step: ship
---

# SeedStack Ship Check

Two moments: **before building** (is this ready to build?) and **after deploying** (is it live and in front of real people?). You check, the student decides. An ugly working thing tested by real people beats a polished thing nobody used.

## Rules

- Speak the student's language, default Thai, casual peer tone, no em dashes.
- You check that decisions exist. You never make them. If the cut is missing, ask what they will cut. Do not suggest one.
- Every gap you find ends with a question back to the student, not a fix.
- Building the app itself is the student's work with OpenCode as their tool. This skill does not write the app.

## Mode 1: Before building

1. Write the `start` event.
2. Read `scope-card.md` in the current folder. If missing, tell them to run `/seedstack-scope` first.
3. Ask for the paper prototype: a photo (drag the image in) or a short description of each screen.
4. Check, one by one, and ask about each gap:
   - **Real user:** is at least one real person (not "students in general") named as who tests it first?
   - **48-hour test:** is there a test with a date inside 48 hours?
   - **Cut:** did they list things they will not do this week? Does the prototype only cover "the one thing that must work"? If the prototype shows more, ask which screens they are willing to drop.
   - **Evidence to collect:** what will they write down from each test?
5. When all four have the student's answer, write `ship-ticket.md` from `ship-ticket.template.md` next to this skill, using their words. Show it, apply only edits they ask for.
6. Tell them: build the smallest version with OpenCode, then deploy it themselves from the project folder with `vercel` (first time, it asks a few setup questions; defaults are usually fine) and `vercel --prod` when ready. If they need a database, they create a Supabase project themselves (`npx supabase@latest projects create` or the Supabase dashboard).

## Mode 2: After deploying

When they give you a URL (or say they deployed):
1. Check it loads: fetch the URL and confirm a 200 response with real content, not a Vercel error page or login wall. If it fails, show the status and ask what they see in the browser.
2. Add the URL to `ship-ticket.md` under "ลิงก์".
3. Ask: who are the 3 people testing it, and when? Write their answers (no full names, use "เพื่อน ม.5 ห้อง 2" style) into the ticket.
4. Write the `done` event with `live_url`.
5. Suggest posting to #progress: the link, who tests it, and what they want to learn.

## Telemetry

Follow the telemetry contract in the `seedstack-connect` skill (load it with the skill tool). Step is `ship`. Events: start, ticket (minutes, next: "build"), done (live_url, next: first test in their words).
No names or contact details in events. Sync after `done`, `stuck` and `ticket`; it is silent and safe when the student has not connected.
