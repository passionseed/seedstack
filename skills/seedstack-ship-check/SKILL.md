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

- **Hand off, do not send away.** If what they need now is another SeedStack step (scope, ship, test, live, install), say so in one line with the why, and when they agree load that skill (skill tool, or read its SKILL.md if there is none) and continue. Do not make them type a new command.
- Speak the student's language, default Thai, casual peer tone, no em dashes.
- For every check, say in one sentence why it matters for their test (not a rule to obey).
- You check that decisions exist. You never make them. If the cut is missing, ask what they will cut. Do not suggest one.
- Every gap you find ends with a question back to the student, not a fix.
- This skill does not write the app. `/seedstack-guidance-build` builds it with them in the same chat, step by step, explaining why at each one.

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
6. **Pick the cheapest test that answers their 48-hour question.** Show this ladder, explain that each rung costs more time, and ask which is the lowest rung that would still tell them if they are wrong. They choose; you can say which you would pick and why.

   | Rung | What | Time | Good when |
   |---|---|---|---|
   | 0 | Paper prototype test: put the drawing in front of someone, ask them to "tap" | 30 min | Checking if people understand it and want it at all |
   | 1 | Do it by hand (concierge): a Google Form or LINE chat where *they* do the service manually | 1-2 hrs | The value is the result, not the software |
   | 2 | Web app with one main screen, built with `/seedstack-guidance-build` (fake data, no login) | 2-4 hrs | People need to click through the one thing themselves |
   | 3 | Web app + saved data (Supabase) | a day | The test only works if testers' data is kept or shared |

   Default to the lowest rung that answers the question. Why: the goal of this week is evidence from real people, and every hour building is an hour not testing. Rung 0 and 1 can be tested today, before any code.
   If they pick rung 2 or 3: `/seedstack-guidance-build` sets up a Next.js project for them and builds only the one thing that must work, with fake data first. Why: one small working screen is faster to test than a whole app, and it can grow later without starting over.
7. Whatever the rung, the next step is `/seedstack-test`: finding testers and running the test. For rung 2 and 3, they build first with `seedstack-guidance-build` (offer to load it now: the AI builds it with them in this chat, one small step at a time), and `/seedstack-live` gives them a link testers can open, and that is when Vercel (and Supabase, only if needed) come in.
8. Add the chosen rung to `ship-ticket.md` and write the `ticket` event (`next`: the rung, e.g. "rung 1: Google Form").

## Telemetry

Follow the telemetry contract in the `seedstack-connect` skill (load it with the skill tool, or read its SKILL.md). Step is `ship`. Events: start, ticket (minutes, next: "build"). The live link is recorded by `/seedstack-live`.
No names or contact details in events. Sync after `done`, `stuck` and `ticket`; it is silent and safe when the student has not connected.
