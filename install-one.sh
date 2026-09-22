#!/usr/bin/env bash
# install-one.sh — 按需安装单个技能
# 用法: bash install-one.sh <skill-name> [目标目录]

set -e

SKILL_NAME="$1"
TARGET="${2:-$HOME/.hermes/skills}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"

if [ -z "$SKILL_NAME" ]; then
  echo "用法: bash install-one.sh <skill-name>"
  echo ""
  echo "可用技能:"
  ls "$SKILLS_DIR/"
  exit 1
fi

real_dir=$(readlink -f "$SKILLS_DIR/$SKILL_NAME")

if [ ! -f "$real_dir/SKILL.md" ]; then
  echo "错误: 找不到技能 $SKILL_NAME"
  exit 1
fi

mkdir -p "$TARGET"
cp -r "$real_dir" "$TARGET/$SKILL_NAME"
echo "OK: $SKILL_NAME -> $TARGET/$SKILL_NAME"
