#!/usr/bin/env bash
# install-all.sh — 一键安装全部技能到 Hermes skills 目录
# 用法: bash install-all.sh [目标目录]
# 默认目标: ~/.hermes/skills

set -e

TARGET="${1:-$HOME/.hermes/skills}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"

echo "========================================="
echo " Hermes Skills Collection — 一键安装"
echo "========================================="
echo "目标目录: $TARGET"
echo ""

mkdir -p "$TARGET"

INSTALLED=0
SKIPPED=0
FAILED=0

for skill_dir in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill_dir")
  target_dir="$TARGET/$skill_name"

  # Resolve symlink
  real_dir=$(readlink -f "$skill_dir")

  if [ ! -f "$real_dir/SKILL.md" ]; then
    echo "  SKIP: $skill_name (no SKILL.md)"
    ((SKIPPED++))
    continue
  fi

  if [ -d "$target_dir" ]; then
    echo "  SKIP: $skill_name (already exists)"
    ((SKIPPED++))
    continue
  fi

  cp -r "$real_dir" "$target_dir"
  echo "  OK:   $skill_name"
  ((INSTALLED++))
done

echo ""
echo "========================================="
echo " 完成: $INSTALLED 安装, $SKIPPED 跳过, $FAILED 失败"
echo "========================================="
