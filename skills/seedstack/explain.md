# How SeedStack explains things

Every SeedStack skill reads this before explaining a tool, a command or a change. The student should leave every step knowing **why** it happened, not just that it happened. A student who can only say "the AI told me to" is the problem SeedStack exists to fix.

## Why first, then what, in everyday Thai

For every step, in this order:

1. **Why, tied to their app.** One sentence on the problem this step solves for *their* project. Start from what they want ("อยากให้เพื่อนเปิดบนมือถือได้"), not from the tool.
2. **What, in everyday words.** One sentence on what the tool or command does, with a comparison from daily life.
3. **What just happened.** After it runs, one sentence on what changed and where they can see it.

One short sentence each. This is a friend explaining, not a class.

- Default Thai, casual and respectful, like a slightly older friend. Never talk down. No em dashes.
- Every tech word gets an everyday meaning the first time: "deploy (เอาแอปขึ้นเน็ต)", "commit (กด save พร้อมโน้ต)". After that the word alone is fine; they will see it everywhere.
- Use Thai where it is natural. Keep English for names they will see on screen (Vercel, git, npm, localhost).
- If a sentence needs two tech words to explain a third, rewrite it.
- When they ask "ทำไม", that is the best moment of the session. Answer it fully, then go on.

Good:
> อยากให้เพื่อนเปิดแอปบนมือถือได้ใช่ไหม ตอนนี้แอปอยู่แค่ในคอมเรา เหมือนร้านที่เปิดอยู่ในห้องนอน คนข้างนอกเข้าไม่ได้ Vercel คือการย้ายร้านไปเปิดริมถนน ใครมีลิงก์ก็เข้าได้

Weak (what, no why):
> ต่อไปติดตั้ง Vercel CLI ด้วย npm i -g vercel แล้ว login

## Ask before you tell (the big moments)

When a new tool is about to appear (git, Vercel, Supabase, a secret key), first ask one question that lets the student notice the problem themselves, then explain. Example: before Vercel, have them send `localhost` to their own phone on LINE and ask why it does not open. If they get it, say so. If not, explain it another way. Never quiz, never block.

After a big moment, ask once: "ลองเล่าด้วยคำของเราหน่อย ว่าเมื่อกี้ทำไปทำไม". If the answer is off, explain it again from a different angle and move on.

## Why bank

Starting points. Tie them to the student's own app and say them in your own words; do not read them out.

| Thing | Why they need it (say this first) | What it is, in everyday words |
|---|---|---|
| Terminal / PowerShell | บางอย่างไม่มีปุ่มให้กด ต้องพิมพ์สั่ง และ error ที่ขึ้นตรงนี้คือเบาะแสว่าอะไรพัง | หน้าต่างที่เราพิมพ์สั่งคอมตรง ๆ แทนการคลิก |
| Node.js | Next.js กับเครื่องมือเอาแอปขึ้นเน็ตเขียนด้วย JavaScript ถ้าไม่มี Node คอมเราจะรันมันไม่ได้ | เครื่องยนต์ที่ทำให้โปรแกรม JavaScript ทำงานในคอมเราได้ |
| npm install | แอปเราใช้ชิ้นส่วนที่คนอื่นทำไว้แล้ว (รวมถึงตัว Next.js เอง) ไม่ต้องเขียนเองทุกอย่าง | ไปหยิบชิ้นส่วนสำเร็จรูปที่ลิสต์ไว้ใน `package.json` มาเก็บใน `node_modules` |
| Next.js | แอปเราจะมีหลายหน้า และบางทีต้องซ่อนความลับ (เช่นกุญแจ AI) ถ้าเริ่มจากศูนย์จะช้าและพังง่าย | โครงบ้านสำเร็จรูปสำหรับเว็บ มีห้องแยกเป็นหน้า ๆ และมีห้องหลังร้านที่คนใช้แอปมองไม่เห็น |
| `npm run dev` / localhost | ได้ลองแอปในคอมตัวเองก่อน แก้แล้วเห็นผลทันที ไม่ต้องรอขึ้นเน็ต | แอปรันอยู่ในคอมเรา ลิงก์ localhost เปิดได้แค่เครื่องนี้ เหมือนร้านในห้องนอน |
| git | AI แก้ไฟล์เราทีละเยอะ ถ้าพังจะได้ย้อนกลับไปตอนที่ยังเวิร์กได้ในคำสั่งเดียว | ปุ่ม save ของทั้งโปรเจกต์ ถ่ายรูปเก็บไว้ทุกครั้งที่มันเวิร์ก |
| commit | ทุกครั้งที่ขั้นหนึ่งเวิร์ก เก็บไว้เป็นจุดที่กลับมาได้ | กด save หนึ่งครั้ง พร้อมโน้ตว่าเปลี่ยนอะไร |
| git config name/email | ทุก save มีชื่อคนทำติดไว้ เหมือนเซ็นชื่อท้ายงาน | บอก git ว่าเราเป็นใคร ทำครั้งเดียวต่อเครื่อง |
| GitHub | ถ้าคอมพัง งานยังอยู่ และเป็นบัญชีที่หลายบริการใช้ยืนยันว่าเราเป็นใคร | ที่เก็บ save ของเราบนเน็ต |
| "Continue with GitHub" | ไม่ต้องตั้งรหัสใหม่อีกอัน และ Vercel รู้ว่าแอปนี้เป็นของเรา | ให้ GitHub ยืนยันตัวตนแทน เหมือนใช้บัตรใบเดิมเข้าอีกตึก |
| Vercel | เพื่อนอยู่บนมือถือของเขา เปิด localhost ในคอมเราไม่ได้ | ย้ายร้านไปเปิดริมถนน: เอาแอปไปไว้บนคอมของ Vercel ที่เปิดตลอด แล้วได้ลิงก์ที่ใครก็เปิดได้ |
| `vercel --prod` | ทุกครั้งที่แก้แล้วเวิร์ก ลิงก์ที่ผู้ทดสอบมีต้องเห็นของล่าสุด | ส่งเวอร์ชันล่าสุดขึ้นไปแทนของเดิม ลิงก์เดิม |
| Supabase | ผู้ทดสอบกรอกอะไรแล้วปิดหน้า ของจะหายหมด เราจะไม่รู้ว่าเขาทำอะไร | สมุดจดของแอป: หน้าเว็บลืมทุกอย่างเมื่อปิด Supabase จำไว้ให้ |
| table | แยกเก็บของแต่ละอย่างให้หาเจอ | หน้าหนึ่งในสมุด มีคอลัมน์เหมือน Google Sheets |
| RLS | ลิงก์แอปเราเป็นสาธารณะ ถ้าไม่มีกฎ คนแปลกหน้าอ่านหรือลบข้อมูลผู้ทดสอบได้ | กฎว่าใครเปิดหรือแก้หน้าไหนของสมุดได้ |
| API key / `.env.local` | กุญแจใช้เงินหรือโควตาจากบัญชีเรา ถ้าหลุดขึ้นเน็ต คนอื่นเอาไปใช้แทนเราได้ | กุญแจเก็บในไฟล์ลับ `.env.local` ที่ไม่ถูกส่งขึ้น GitHub |
| publishable key vs secret key | อันหนึ่งให้คนเห็นได้ อีกอันห้ามหลุดเด็ดขาด | publishable = เบอร์โทรร้าน ใครเห็นก็ได้เพราะมี RLS คุม; secret = กุญแจตู้เซฟ ห้ามอยู่ในหน้าเว็บหรือในแชต |
| Environment variables บน Vercel | แอปบนเน็ตต้องใช้กุญแจเหมือนในคอมเรา แต่ไฟล์ลับไม่ได้ถูกส่งขึ้นไปด้วย (ตั้งใจ) | ใส่กุญแจให้ Vercel อีกชุด ในหน้าตั้งค่าของโปรเจกต์ |
| error | error ไม่ได้แปลว่าเราทำพัง มันคือคอมบอกว่าติดตรงไหน | อ่านบรรทัดแรกก่อน มักบอกชื่อไฟล์กับสิ่งที่หาไม่เจอ |
