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
- Never ask for their password, email, or any token. Linking happens in the browser.

## Connect flow

1. Explain in two sentences: connecting lets mentors see which step they are on and help when they are stuck. Because they are under 20, a parent also has to agree.
2. Run `node "<skills dir>/seedstack-connect/sync.mjs" link`. `<skills dir>` is `~/.config/opencode/skills` on Mac and `$HOME\.config\opencode\skills` on Windows.
3. Show the student the link and the code it printed. They open the link, sign in with **the same Discord account they used to join the SHIFT server**, and the first time they read the notice, agree, and send the parent link to a parent (LINE is fine). Once both agreed, the page shows the same code with a "ใช่ เชื่อมเครื่องนี้" button. Tell them to press it only if the code matches.
4. When they say they pressed it (or if they ask), run `node "<skills dir>/seedstack-connect/sync.mjs" link-wait`. It waits up to 90 seconds. If it says still waiting, ask whether they pressed the button, then run it again.
   If the parent has not answered yet, that is fine: tell them to run `/seedstack-connect` again after the parent agrees (the code expires in 10 minutes).
5. Tell them the result line. They never need to copy a token anywhere; it goes straight from the server to this computer.

If the page says "บัญชีนี้ยังไม่ได้ผูกกับ SHIFT", they signed in with a different Discord account, or they have not used the join link from their payment message yet. Point them to that link or to the SHIFT LINE.

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
