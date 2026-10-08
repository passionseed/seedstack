---
name: seedstack-ship-check
description: Pre-build check for SHIFT students. Reads scope-card.md and the paper prototype, checks that a real user is named, a 48-hour test is planned and the student stated their own cut, then writes ship-ticket.md. Going live (Vercel, Supabase) is handled by /seedstack-live. Use when the student runs /seedstack-ship.
license: MIT
metadata:
  step: ship
---

# SeedStack Ship Check

One moment: **before building**, is this ready to build? You check, the student decides. An ugly working thing tested by real people beats a polished thing nobody used.

## Rules

- Speak the student's language, default Thai, casual peer tone, no em dashes.
- For every check, say in one sentence why it matters for their test (not a rule to obey).
- You check that decisions exist. You never make them. If the cut is missing, ask what they will cut. Do not suggest one.
- Every gap you find ends with a question back to the student, not a fix.
- Building the app itself is the student's work with OpenCode as their tool. This skill does not write the app.

## Before building

1. Write the `start` event.
2. Read `scope-card.md` in the current folder. If missing, tell them to run `/seedstack-scope` first.
3. Ask for the paper prototype: a photo (drag the image in) or a short description of each screen.
4. Check, one by one, and ask about each gap:
   - **Real user:** is at least one real person (not "students in general") named as who tests it first?
   - **48-hour test:** is there a test with a date inside 48 hours?
   - **Cut:** did they list things they will not do this week? Does the prototype only cover "the one thing that must work"? If the prototype shows more, ask which screens they are willing to drop.
   - **Evidence to collect:** what will they write down from each test?
5. When all four have the student's answer, write `ship-ticket.md` from `ship-ticket.template.md` next to this skill, using their words. Show it, apply only edits they ask for.
6. Tell them what comes next and why: build the smallest version with OpenCode and run it on their own computer first (fastest way to see if it works). When the one thing works, `/seedstack-live` puts it in front of testers, and that is when Vercel (and Supabase, only if the test needs saved data) come in.
7. Write the `ticket` event.

## Telemetry

Follow the telemetry contract in the `seedstack-connect` skill (load it with the skill tool). Step is `ship`. Events: start, ticket (minutes, next: "build"). The live link is recorded by `/seedstack-live`.
No names or contact details in events. Sync after `done`, `stuck` and `ticket`; it is silent and safe when the student has not connected.
