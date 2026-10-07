#!/usr/bin/env bash
# Checks every skill follows the OpenCode SKILL.md contract.
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0
for file in skills/*/SKILL.md; do
  dir="$(basename "$(dirname "$file")")"
  name="$(sed -n 's/^name: *//p' "$file" | head -1)"
  desc="$(sed -n 's/^description: *//p' "$file" | head -1)"
  [[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "bad name '$name' in $file"; fail=1; }
  [ "$name" = "$dir" ] || { echo "name '$name' != dir '$dir'"; fail=1; }
  [ -n "$desc" ] || { echo "missing description in $file"; fail=1; }
  if grep -n '—' "$file"; then echo "em dash in $file"; fail=1; fi
done
for file in commands/*.md; do
  skill="$(sed -n 's/^Load the `\(seedstack-[a-z-]*\)` skill.*/\1/p' "$file" | head -1)"
  [ -f "skills/$skill/SKILL.md" ] || { echo "$file points to missing skill '$skill'"; fail=1; }
done
[ "$fail" = 0 ] && echo "ok"
exit "$fail"
