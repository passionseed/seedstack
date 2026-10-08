# SeedStack installer for Windows PowerShell.
# Usage: irm https://raw.githubusercontent.com/passionseed/seedstack/main/install.ps1 | iex
$ErrorActionPreference = "Stop"

$Repo = "passionseed/seedstack"
$Ref = if ($env:SEEDSTACK_REF) { $env:SEEDSTACK_REF } else { "main" }
$ConfigHome = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { Join-Path $HOME ".config" }
$ConfigDir = Join-Path $ConfigHome "opencode"

function Say($msg) { Write-Host "==> $msg" -ForegroundColor Green }
function Refresh-Path {
  $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")
}

Write-Host @"

SeedStack จะทำสิ่งนี้ในเครื่องเรา:
  1. ตั้ง PowerShell ให้รันเครื่องมือที่เราติดตั้งเองได้ (RemoteSigned เฉพาะบัญชีเรา)
  2. ติดตั้ง OpenCode ด้วย npm (ถ้ายังไม่มี ต้องมี Node.js ก่อน ถ้ายังไม่มีจะเปิดหน้า nodejs.org ให้ติดตั้งเอง)
  3. คัดลอก skills และ commands ของ SeedStack ไปที่ $ConfigDir
  ไม่ส่งข้อมูลอะไรให้ PassionSeed จนกว่าเราจะพิมพ์ /seedstack-connect และผู้ปกครองยินยอมบนเว็บ
  ลบออกทีหลังได้: ลบโฟลเดอร์ seedstack-* ใน $ConfigDir\skills และไฟล์ seedstack-*.md ใน $ConfigDir\commands

"@
if ($env:SEEDSTACK_YES -ne "1") {
  $Answer = Read-Host "ติดตั้งไหม? พิมพ์ y แล้วกด Enter [y/N]"
  if ($Answer -notmatch '^(y|yes)$') {
    Write-Host "ยกเลิกแล้ว ไม่มีอะไรเปลี่ยนในเครื่อง"
    return
  }
}

# Lets PowerShell run npm-installed tools (opencode, vercel) for this user only.
if ((Get-ExecutionPolicy -Scope CurrentUser) -in @("Undefined", "Restricted")) {
  Say "Allowing PowerShell to run tools you install (current user only)"
  Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
}

if (-not (Get-Command opencode -ErrorAction SilentlyContinue)) {
  if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Say "ต้องมี Node.js ก่อน กำลังเปิดหน้าดาวน์โหลด"
    Write-Host "เลือก LTS > Windows > ดาวน์โหลดไฟล์ .msi แล้วดับเบิลคลิกติดตั้ง (ค่าเริ่มต้นได้เลย)"
    Write-Host "เสร็จแล้วปิด PowerShell เปิดใหม่ แล้ววางคำสั่งติดตั้ง SeedStack อีกครั้ง"
    Start-Process "https://nodejs.org/en/download"
    return
  }
  Say "Installing OpenCode"
  npm install -g opencode-ai
  Refresh-Path
}

if ($env:SEEDSTACK_SRC) {
  $Src = $env:SEEDSTACK_SRC
} else {
  $Tmp = Join-Path ([IO.Path]::GetTempPath()) ("seedstack-" + [guid]::NewGuid())
  New-Item -ItemType Directory -Path $Tmp | Out-Null
  $Zip = Join-Path $Tmp "seedstack.zip"
  Say "Downloading SeedStack ($Ref)"
  Invoke-WebRequest -UseBasicParsing "https://codeload.github.com/$Repo/zip/refs/heads/$Ref" -OutFile $Zip
  Expand-Archive $Zip -DestinationPath $Tmp
  $Src = Join-Path $Tmp "seedstack-$Ref"
}

Say "Installing skills and commands into $ConfigDir"
New-Item -ItemType Directory -Force -Path (Join-Path $ConfigDir "skills"), (Join-Path $ConfigDir "commands") | Out-Null
# Clear the previous version first so renamed or removed skills do not linger.
Get-ChildItem (Join-Path $ConfigDir "skills") -Directory -Filter "seedstack-*" | Remove-Item -Recurse -Force
Get-ChildItem (Join-Path $ConfigDir "commands") -File -Filter "seedstack-*.md" | Remove-Item -Force
Get-ChildItem (Join-Path $Src "skills") -Directory -Filter "seedstack-*" | ForEach-Object {
  Copy-Item $_.FullName (Join-Path $ConfigDir "skills\$($_.Name)") -Recurse
}
Copy-Item (Join-Path $Src "commands\seedstack-*.md") (Join-Path $ConfigDir "commands") -Force

if ($Tmp) { Remove-Item $Tmp -Recurse -Force }

Say "Installed SeedStack $(Get-Content (Join-Path $ConfigDir 'skills\seedstack-connect\VERSION') -ErrorAction SilentlyContinue)"
Say "Done. Close and reopen PowerShell, then run: opencode"
Say "Inside OpenCode, type: /seedstack-install"
