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

# Lets PowerShell run npm-installed tools (opencode, vercel) for this user only.
if ((Get-ExecutionPolicy -Scope CurrentUser) -in @("Undefined", "Restricted")) {
  Say "Allowing PowerShell to run tools you install (current user only)"
  Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
}

if (-not (Get-Command opencode -ErrorAction SilentlyContinue)) {
  if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Say "Installing Node.js LTS (needed for OpenCode)"
    winget install --id OpenJS.NodeJS.LTS -e --accept-source-agreements --accept-package-agreements
    Refresh-Path
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
Get-ChildItem (Join-Path $Src "skills") -Directory -Filter "seedstack-*" | ForEach-Object {
  $Dest = Join-Path $ConfigDir "skills\$($_.Name)"
  if (Test-Path $Dest) { Remove-Item $Dest -Recurse -Force }
  Copy-Item $_.FullName $Dest -Recurse
}
Copy-Item (Join-Path $Src "commands\seedstack-*.md") (Join-Path $ConfigDir "commands") -Force

if ($Tmp) { Remove-Item $Tmp -Recurse -Force }

Say "Done. Close and reopen PowerShell, then run: opencode"
Say "Inside OpenCode, type: /seedstack-install"
