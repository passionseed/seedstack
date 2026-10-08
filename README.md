# SeedStack

ชุดเครื่องมือสำหรับนักเรียน SHIFT ที่ใช้ใน [OpenCode](https://opencode.ai): ตั้งเครื่องเอง, ล็อก scope เอง, ship ของจริงเอง

AI ในนี้ **ไม่ตอบแทนเรา** มันถามคำถาม ให้เราไปคุยกับคนจริง แล้วช่วยเช็กว่าเราพร้อมหรือยัง ทุกคำสั่งติดตั้งเราพิมพ์เอง

## ติดตั้ง

**Mac** เปิด Terminal แล้ววาง:

```bash
curl -fsSL https://raw.githubusercontent.com/passionseed/seedstack/main/install.sh | bash
```

**Windows** เปิด **PowerShell** (ไม่ใช่ cmd) แล้ววาง:

```powershell
irm https://raw.githubusercontent.com/passionseed/seedstack/main/install.ps1 | iex
```

ใช้ได้ทั้งแอป OpenCode (Desktop), OpenCode ใน terminal และ Claude Code ถ้ามีแอปอยู่แล้ว ตัวติดตั้งจะไม่ติดตั้ง OpenCode ซ้ำ ถ้ามี Claude Code ในเครื่อง จะติดตั้งให้ Claude Code ด้วย (`~/.claude`) ถ้ามี Codex จะติดตั้งที่ `~/.agents/skills` (ใน Codex พิมพ์ `$seedstack` แทน `/seedstack`)

เสร็จแล้ว **ปิด OpenCode ให้สนิท** (Mac: Cmd+Q, Windows: ปิดจาก system tray ด้วย) แล้วเปิดใหม่ เปิดโฟลเดอร์โปรเจกต์ แล้วเลือกโมเดลตามที่ mentor บอกใน #อ่านก่อน

ตัวติดตั้งจะบอกก่อนว่าจะทำอะไรในเครื่อง แล้วรอให้เราพิมพ์ `y` ถึงจะเริ่ม

## สิ่งที่เปลี่ยนในเครื่อง

- **Mac:** ติดตั้ง OpenCode (ถ้ายังไม่มี) และเพิ่ม PATH ใน `~/.zshrc` หรือ `~/.bashrc`
- **Windows:** ติดตั้ง OpenCode ด้วย npm (ถ้ายังไม่มี Node.js ตัวติดตั้งจะเปิดหน้า nodejs.org ให้เราติดตั้งเองก่อน), ตั้ง PowerShell execution policy เป็น `RemoteSigned` เฉพาะบัญชีเรา
- ทั้งสองแบบ: คัดลอก skills และ commands ไปที่ `~/.config/opencode` (Windows: `$HOME\.config\opencode`)

ลบออก: ลบโฟลเดอร์ `seedstack*` ใน `~/.config/opencode/skills` (และ `~/.claude/skills`, `~/.agents/skills` ถ้ามี) และไฟล์ `seedstack*.md` ใน `~/.config/opencode/commands` (และ `~/.claude/commands`)

## อัปเดต

Skills ของ SeedStack จะเช็กเองตอนเริ่มว่ามีเวอร์ชันใหม่ไหม แล้วบอกเรา (ไม่ติดตั้งเอง) จะอัปเดต: ปิด OpenCode ให้สนิท แล้วรันบรรทัดติดตั้งเดิมอีกครั้งใน Terminal/PowerShell แล้วเปิด OpenCode ใหม่ เช็กเวอร์ชันได้ด้วย `node ~/.config/opencode/skills/seedstack-connect/sync.mjs check-update`

## ใช้ยังไง

| คำสั่งใน OpenCode | ทำอะไร | ได้อะไร |
|---|---|---|
| `/seedstack` | ไม่รู้จะทำอะไรต่อ? ดูโฟลเดอร์โปรเจกต์แล้วแนะนำขั้นถัดไป เราเลือกเอง | ขั้นถัดไปที่เหมาะ |
| `/seedstack-install` | ตั้งแค่ที่ต้องใช้สร้างงานในเครื่อง (Node, git, โฟลเดอร์) เปิดหน้าเว็บทางการให้ บอกว่าทำไมต้องมี เราติดตั้งและพิมพ์คำสั่งเอง | เครื่องพร้อมสร้าง + โฟลเดอร์โปรเจกต์ |
| `/seedstack-scope` | ถามคำถามจากบทสัมภาษณ์ของเรา จนเราพิมพ์ "ล็อก" | `scope-card.md` |
| `/seedstack-ship` | เช็กก่อนสร้างว่าพร้อมเทสต์กับคนจริงไหม | `ship-ticket.md` |
| `/seedstack-test` | หาคนเทสต์แบบทักตรง ไม่ใช่โพสต์ลอยๆ, เทสต์แบบดูเขาทำ, ถามเรื่องที่เคยเกิดขึ้นจริง, จดหลักฐาน, ตัดสินใจเปลี่ยน | `test-log.md` |
| `/seedstack-live` | พอของในเครื่องเวิร์กแล้ว พาขึ้น Vercel ให้เพื่อนเปิดได้ (ทำใน Google AI Studio มา? ถามก่อนว่าอยากย้ายไหม แล้วพา export zip) และ Supabase เฉพาะถ้าเทสต์ต้องเก็บข้อมูล | ลิงก์ live |

| `/seedstack-connect` | (ไม่บังคับ) ให้พี่ mentor เห็นความคืบหน้า ต้องยินยอมทั้งเราและผู้ปกครอง | พี่เห็นว่าเราติดตรงไหน |

## ข้อมูลและความเป็นส่วนตัว

- ทุกขั้นจดสถานะและเวลาไว้ใน `~/.seedstack/events.jsonl` ในเครื่องเรา ไม่มีชื่อหรือข้อมูลติดต่อของใคร
- **ไม่มีอะไรออกจากเครื่อง** จนกว่าเราจะ `/seedstack-connect` และทั้งเราและผู้ปกครองยินยอมที่ [passionseed.org/shift/seedstack](https://www.passionseed.org/shift/seedstack) ซึ่งบอกชัดว่าเก็บอะไร เก็บไว้นานแค่ไหน และใครเห็น
- ไม่เก็บบทสนทนากับ AI ไม่เก็บไฟล์หรือโค้ด
- ถอนความยินยอมได้ทุกเมื่อที่หน้าเดียวกัน ระบบลบข้อมูลที่ส่งไปแล้วทั้งหมด
- บทสนทนากับ AI ไปที่ผู้ให้บริการโมเดลที่เลือกใน OpenCode ตามนโยบายของผู้ให้บริการนั้น

ติดตรงไหน โพสต์ error ใน #ถามได้ทุกเรื่อง เพื่อนตอบไวกว่าที่คิด

## For maintainers

- Skills live in `skills/<name>/SKILL.md` (OpenCode skill format), slash commands in `commands/`.
- Installers copy both into `~/.config/opencode/` (`$HOME\.config\opencode` on Windows).
- `./scripts/validate.sh` checks skill names, descriptions and no em dashes.
- Releasing: bump `skills/seedstack-connect/VERSION` (date, e.g. `2026.10.09`) in the same commit as any skill change, and post what changed in Discord. Students see the update notice next time a skill starts. Avoid pushing during a live session.
- Test an install from a local checkout: `SEEDSTACK_YES=1 SEEDSTACK_SRC=$PWD HOME=$(mktemp -d) ./install.sh`
- Telemetry: `skills/seedstack-connect/sync.mjs` posts to `https://www.passionseed.org/api/seedstack/events` (override with `SEEDSTACK_API_URL`).
