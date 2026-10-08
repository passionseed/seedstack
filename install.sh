#!/usr/bin/env bash
# SeedStack installer for macOS / Linux.
# Usage: curl -fsSL https://raw.githubusercontent.com/passionseed/seedstack/main/install.sh | bash
set -euo pipefail

REPO="passionseed/seedstack"
REF="${SEEDSTACK_REF:-main}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"

say() { printf '\033[1;32m==>\033[0m %s\n' "$1"; }

# The desktop app reads skills from the same ~/.config/opencode, but does not
# put `opencode` on PATH, so look for it too.
has_opencode() {
  command -v opencode >/dev/null 2>&1 ||
    [ -x "$HOME/.opencode/bin/opencode" ] ||
    [ -d "/Applications/OpenCode.app" ] ||
    [ -d "$HOME/Applications/OpenCode.app" ] ||
    [ -d "$HOME/Library/Application Support/ai.opencode.desktop" ]
}

# Wrapped in main so the whole script is parsed before it runs (safe for curl | bash).
confirm() {
  cat <<'MSG'

SeedStack จะทำสิ่งนี้ในเครื่องเรา:
  1. ติดตั้ง OpenCode จาก opencode.ai (ถ้ายังไม่มีทั้งแอป OpenCode และตัว terminal) และเพิ่ม PATH ในไฟล์ตั้งค่า shell
  2. คัดลอก skills และ commands ของ SeedStack ไปที่ ~/.config/opencode
  ไม่ส่งข้อมูลอะไรให้ PassionSeed จนกว่าเราจะพิมพ์ /seedstack-connect และผู้ปกครองยินยอมบนเว็บ
  ลบออกทีหลังได้: rm -rf ~/.config/opencode/skills/seedstack-* ~/.config/opencode/commands/seedstack-*.md

MSG
  if [ "${SEEDSTACK_YES:-}" = "1" ]; then return 0; fi
  if ! { exec 3</dev/tty; } 2>/dev/null; then
    echo "ไม่มีหน้าจอให้ตอบ ตั้ง SEEDSTACK_YES=1 ถ้าตั้งใจติดตั้ง" >&2
    exit 1
  fi
  printf 'ติดตั้งไหม? พิมพ์ y แล้วกด Enter [y/N] '
  read -r answer <&3
  exec 3<&-
  case "$answer" in
    y|Y|yes|YES) ;;
    *) echo "ยกเลิกแล้ว ไม่มีอะไรเปลี่ยนในเครื่อง"; exit 0 ;;
  esac
}

main() {
  confirm
  if has_opencode; then
    say "Found OpenCode, skipping its install"
  else
    say "Installing OpenCode"
    curl -fsSL https://opencode.ai/install | bash
  fi

  # SEEDSTACK_SRC lets you install from a local checkout (for testing).
  if [ -n "${SEEDSTACK_SRC:-}" ]; then
    SRC="$SEEDSTACK_SRC"
  else
    TMP="$(mktemp -d)"
    trap 'rm -rf "$TMP"' EXIT
    say "Downloading SeedStack ($REF)"
    curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/heads/$REF" | tar -xz -C "$TMP"
    SRC="$TMP/seedstack-$REF"
  fi

  say "Installing skills and commands into $CONFIG_DIR"
  mkdir -p "$CONFIG_DIR/skills" "$CONFIG_DIR/commands"
  # Clear the previous version first so renamed or removed skills do not linger.
  rm -rf "$CONFIG_DIR"/skills/seedstack-* "$CONFIG_DIR"/commands/seedstack-*.md
  for dir in "$SRC"/skills/seedstack-*; do
    cp -R "$dir" "$CONFIG_DIR/skills/$(basename "$dir")"
  done
  cp "$SRC"/commands/seedstack-*.md "$CONFIG_DIR/commands/"

  say "Installed SeedStack $(cat "$CONFIG_DIR/skills/seedstack-connect/VERSION" 2>/dev/null)"
  say "Done. Quit OpenCode completely (Cmd+Q) and open it again so it loads the new skills."
  say "Then open your project folder and type: /seedstack-test (or /seedstack-install if you are just starting)"
}

main "$@"
