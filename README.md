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

เสร็จแล้วปิดเปิด Terminal / PowerShell ใหม่ พิมพ์ `opencode` แล้วเลือกโมเดลตามที่ mentor บอกใน #อ่านก่อน

ตัวติดตั้งจะบอกก่อนว่าจะทำอะไรในเครื่อง แล้วรอให้เราพิมพ์ `y` ถึงจะเริ่ม

## สิ่งที่เปลี่ยนในเครื่อง

- **Mac:** ติดตั้ง OpenCode (ถ้ายังไม่มี) และเพิ่ม PATH ใน `~/.zshrc` หรือ `~/.bashrc`
- **Windows:** ติดตั้ง Node.js LTS ด้วย winget และ OpenCode ด้วย npm (ถ้ายังไม่มี), ตั้ง PowerShell execution policy เป็น `RemoteSigned` เฉพาะบัญชีเรา
- ทั้งสองแบบ: คัดลอก skills และ commands ไปที่ `~/.config/opencode` (Windows: `$HOME\.config\opencode`)

ลบออก: ลบโฟลเดอร์ `seedstack-*` ใน `~/.config/opencode/skills` และไฟล์ `seedstack-*.md` ใน `~/.config/opencode/commands`

## ใช้ยังไง

| คำสั่งใน OpenCode | ทำอะไร | ได้อะไร |
|---|---|---|
| `/seedstack-install` | พาติดตั้ง Node, git, Vercel CLI, Supabase CLI ทีละขั้น เราพิมพ์เอง | เครื่องพร้อม ship + โฟลเดอร์โปรเจกต์ |
| `/seedstack-scope` | ถามคำถามจากบทสัมภาษณ์ของเรา จนเราพิมพ์ "ล็อก" | `scope-card.md` |
| `/seedstack-ship` | เช็กก่อนสร้าง แล้วเช็กลิงก์หลัง deploy | `ship-ticket.md` + ลิงก์ live |

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
- Test an install from a local checkout: `SEEDSTACK_YES=1 SEEDSTACK_SRC=$PWD HOME=$(mktemp -d) ./install.sh`
- Telemetry: `skills/seedstack-connect/sync.mjs` posts to `https://www.passionseed.org/api/seedstack/events` (override with `SEEDSTACK_API_URL`).
