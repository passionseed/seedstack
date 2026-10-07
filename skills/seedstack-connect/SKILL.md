---
name: seedstack-connect
description: Connect SeedStack to PassionSeed so SHIFT mentors can see the student's progress, after the student and a parent consent on the web. Also defines how every SeedStack skill writes and syncs telemetry events. Use when the student runs /seedstack-connect, wants to disconnect, or another SeedStack skill needs to log an event.
license: MIT
metadata:
  step: connect
---

# SeedStack Connect

Connecting is optional. Every SeedStack skill works fully without it; events just stay on the student's computer.

## Rules

- Speak the student's language, default Thai, casual peer tone, no em dashes.
- Never pressure. If they do not want to connect, say that is completely fine and move on.
- Never ask for their password, email, or anything besides the connect code.

## Connect flow

1. Explain in two sentences: connecting lets mentors see which step they are on and help when they are stuck. Because they are under 20, a parent also has to agree.
2. Send them to **https://www.passionseed.org/shift/seedstack**. There they read what is collected, agree, send the parent link to a parent (LINE is fine), and once the parent agrees they press "สร้างรหัสเชื่อมต่อ".
3. When they paste the code (starts with `psss_`), run:
   `node "<skills dir>/seedstack-connect/sync.mjs" save-token <code>`
   `<skills dir>` is `~/.config/opencode/skills` on Mac and `$HOME\.config\opencode\skills` on Windows.
4. Tell them the result line from the script. If it says waiting for consent, remind them the parent still needs to answer.

## Disconnect

If they want to stop sending: `node "<skills dir>/seedstack-connect/sync.mjs" forget`. To also delete what was already sent, they press "ถอนความยินยอมและลบข้อมูล" on the web page (a parent can do it from their link too).

## Telemetry contract (used by every SeedStack skill)

Append one JSON object per line to `~/.seedstack/events.jsonl` (Windows: `$HOME\.seedstack\events.jsonl`). Always this file, never one inside a project folder. Use your file editing tool, not shell echo, so it works on Windows.

```json
{"id":"<random 12+ chars, letters/digits/_/->","ts":"<ISO time>","step":"install|scope|ship","event":"start|stuck|changed|ticket|done","minutes":0,"next":"","detail":"","live_url":""}
```

- `id` must be unique per event. Never reuse one.
- Only include fields you have. `next` and `detail` are short (under 280 characters).
- Never put names, phone numbers, emails, LINE IDs, or interview quotes in events.

After writing a `done`, `stuck` or `ticket` event, run the sync (it is quiet and safe when not connected):
`node "<skills dir>/seedstack-connect/sync.mjs"`
If `node` is not installed yet (early in install), skip the sync; it will catch up later.
