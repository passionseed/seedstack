---
name: seedstack
description: SeedStack front door for SHIFT students. "/seedstack guidance-build <idea>" starts building the app with them; "/seedstack auto-build <idea>" is the fast lane where the AI does almost everything. With nothing after it, looks at the project folder to see where the student is (scope card, ship ticket, test log, app files, live link), recommends the next SeedStack step with a one-line why, and loads that skill once the student agrees. Use when the student runs /seedstack, says "what next", is not sure what to do, or asks for help with their SHIFT project without naming a step.
license: MIT
metadata:
  step: router
---

# SeedStack

Figure out where the student is, suggest the next step, and get them moving. The student decides; you recommend.

`explain.md` in this folder is how every SeedStack skill explains things: why first, then what, in everyday Thai. Follow it here too.

## What did they type?

Read the student input that came with the command first:

| They typed | Do this |
|---|---|
| `create ...`, `สร้าง...`, `build ...`, or describes an app they want ("เว็บจองคิว...") | Load `seedstack-guidance-build` now and pass their idea along. Skip the folder check. |
| `auto-build ...` or `auto ...` | Load `seedstack-auto-build` now and pass the rest along. Skip the folder check. |
| Nothing, or a question like "ทำอะไรต่อ" | Look at the folder (below) and recommend. |

## Rules

- Speak the student's language, default Thai, casual peer tone, no em dashes.
- While routing, only read (list files, read small files, `node -v`). The skill you hand off to does the rest.
- Recommend one step with a one-line why. Mention at most one alternative. Then ask "ไปทางนี้ไหม?" and load the skill they pick (skill tool, or read its SKILL.md if there is none). Never make them type another command.
- Use the emoji board style (✅ ⏳ ⬜ ❌), never words like "เขียว".

## Look at the folder

Check, read-only:

| Signal | How |
|---|---|
| Scope card | `scope-card.md` exists |
| Ship ticket | `ship-ticket.md` exists; note the rung (0 paper, 1 by hand, 2 one-page web, 3 web + data) |
| Tests | `test-log.md`: how many tests logged, whether "ตัดสินใจเปลี่ยนอะไร" has an entry |
| Something built | `index.html`, `package.json`, or an AI Studio export |
| Live | `.vercel/` folder exists, or a link under "ลิงก์" in the ship ticket |
| Building | `build-plan.md`: which steps are ✅ and which are ⬜ |

If the folder is empty or is not a project folder, ask one question: "ตอนนี้อยู่ตรงไหน: เพิ่งเริ่ม / มีไอเดียแล้ว / มีของให้คนลองแล้ว / เทสต์แล้วได้ feedback?" If they already have an idea and want to build, tell them they can just say what they want and you will start (`seedstack-guidance-build`).

## Recommend

First matching row wins, but listen to what they say they need over what the files say:

| Situation | Recommend | Why (say it in their terms) |
|---|---|---|
| Just starting, no tools, no folder | `seedstack-install-doctor` | Get set up to build on this computer |
| Has feedback but it is not logged yet | `seedstack-test` | Sort what testers did vs said, then decide |
| Fewer than 3 tests logged | `seedstack-test` | Real people beat more building right now |
| No scope card and no tests | `seedstack-test` (test the problem) or `seedstack-scope-lock` | Either talk to people today or lock what to build first; ask which they prefer |
| Scope card but no ship ticket | `seedstack-ship-check` | Pick the cheapest test that answers the question |
| Says they are behind, out of time, or "ทำให้เลยได้ไหม" | `seedstack-auto-build`, with `seedstack-guidance-build` as the alternative | Auto-build gets their idea live fastest; build is slower but they set up each tool and know why it is there |
| Ship ticket at rung 2 or 3 and nothing built yet, or a decision logged that needs the app changed | `seedstack-guidance-build` | Build it together in this chat, one small step at a time, knowing why each part is there |
| Tests done and a decision made, the test needs a link testers can open, not live yet | `seedstack-live` | Testers are on their own phones |
| `build-plan.md` has steps still ⬜ | `seedstack-guidance-build` | Pick up at the next step |
| Live, fewer than 3 tests with the new version | `seedstack-test` | Test the change with new people |
| 3+ tests and a decision logged | Celebrate, then `seedstack-test` with new people or update the scope card's change log | The change log is what goes into the พอร์ต 1 หน้า |

Show a short board of what you found before recommending, for example:

```
SeedStack ของเรา
✅ scope card
✅ ship ticket (ขั้น 2: เว็บหน้าเดียว)
⏳ เทสต์แล้ว 1 / 3
⬜ ลิงก์ live
```

## Telemetry

None for this skill; the step it hands off to writes its own events.
