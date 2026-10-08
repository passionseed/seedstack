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

# Each install clears the previous version first so renamed or removed
# skills and commands do not linger. Both use $SRC, set in main.
install_skills() {
  mkdir -p "$1"
  rm -rf "$1"/seedstack "$1"/seedstack-*
  cp -R "$SRC"/skills/seedstack* "$1/"
}

install_commands() {
  mkdir -p "$1"
  rm -f "$1"/seedstack*.md
  cp "$SRC"/commands/seedstack*.md "$1/"
}

# Wrapped in main so the whole script is parsed before it runs (safe for curl | bash).
confirm() {
  cat <<'MSG'

SeedStack จะทำสิ่งนี้ในเครื่องเรา:
  1. ติดตั้ง OpenCode จาก opencode.ai (ถ้ายังไม่มีทั้งแอป OpenCode และตัว terminal) และเพิ่ม PATH ในไฟล์ตั้งค่า shell
  2. คัดลอก skills และ commands ของ SeedStack ไปที่ ~/.config/opencode
     และ ~/.claude ถ้ามี Claude Code, ~/.agents/skills ถ้ามี Codex
  ไม่ส่งข้อมูลอะไรให้ PassionSeed จนกว่าเราจะพิมพ์ /seedstack-connect และผู้ปกครองยินยอมบนเว็บ
  ลบออกทีหลังได้: rm -rf ~/.config/opencode/skills/seedstack* ~/.config/opencode/commands/seedstack*.md ~/.claude/skills/seedstack* ~/.claude/commands/seedstack*.md ~/.agents/skills/seedstack*

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
  install_skills "$CONFIG_DIR/skills"
  install_commands "$CONFIG_DIR/commands"

  # Claude Code reads the same SKILL.md format from ~/.claude. OpenCode also
  # scans ~/.claude/skills; identical copies there are harmless.
  if command -v claude >/dev/null 2>&1 || [ -d "$HOME/.claude" ]; then
    say "Also installing for Claude Code into ~/.claude"
    install_skills "$HOME/.claude/skills"
    install_commands "$HOME/.claude/commands"
  fi

  # Codex reads skills (no slash commands) from ~/.agents/skills; students
  # start one by typing $seedstack-test. OpenCode scans this folder too.
  if command -v codex >/dev/null 2>&1 || [ -d "$HOME/.codex" ]; then
    say "Also installing for Codex into ~/.agents/skills (type \$seedstack in Codex)"
    install_skills "$HOME/.agents/skills"
  fi

  say "Installed SeedStack $(cat "$CONFIG_DIR/skills/seedstack-connect/VERSION" 2>/dev/null)"
  say "Done. Quit OpenCode completely (Cmd+Q) and open it again so it loads the new skills."
  say "Then open your project folder and type: /seedstack-test (or /seedstack-install if you are just starting)"
}

main "$@"
