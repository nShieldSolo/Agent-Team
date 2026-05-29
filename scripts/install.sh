#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${LAMMUON_AGENT_REPO:-https://github.com/nShieldSolo/Agent-Team}"
BRANCH="${LAMMUON_AGENT_BRANCH:-main}"
MODE="project"
TARGET_DIR="$PWD"

usage() {
  cat <<'EOF'
Install lammuon Cursor agents/rules into a project.

Usage:
  scripts/install.sh [target-project-dir]
  scripts/install.sh --project [target-project-dir]
  scripts/install.sh --global cursor
  scripts/install.sh --global codex
  scripts/install.sh --global all

Examples:
  scripts/install.sh
  scripts/install.sh /path/to/project
  scripts/install.sh --global cursor
  scripts/install.sh --global codex
  scripts/install.sh --global all

From GitHub:
  curl -fsSL https://raw.githubusercontent.com/nShieldSolo/Agent-Team/main/scripts/install.sh | bash
  curl -fsSL https://raw.githubusercontent.com/nShieldSolo/Agent-Team/main/scripts/install.sh | bash -s -- /path/to/project
  curl -fsSL https://raw.githubusercontent.com/nShieldSolo/Agent-Team/main/scripts/install.sh | bash -s -- --global cursor
  curl -fsSL https://raw.githubusercontent.com/nShieldSolo/Agent-Team/main/scripts/install.sh | bash -s -- --global codex
  curl -fsSL https://raw.githubusercontent.com/nShieldSolo/Agent-Team/main/scripts/install.sh | bash -s -- --global all

Environment:
  LAMMUON_AGENT_BRANCH=main
  LAMMUON_AGENT_REPO=https://github.com/nShieldSolo/Agent-Team
  CODEX_HOME=$HOME/.codex
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --project)
      MODE="project"
      TARGET_DIR="${2:-$PWD}"
      [[ $# -ge 2 ]] && shift
      ;;
    --global)
      MODE="${2:-}"
      if [[ "$MODE" != "cursor" && "$MODE" != "codex" && "$MODE" != "all" ]]; then
        echo "--global must be one of: cursor, codex, all" >&2
        exit 1
      fi
      shift
      ;;
    --cursor-global)
      MODE="cursor"
      ;;
    --codex-global)
      MODE="codex"
      ;;
    --all-global)
      MODE="all"
      ;;
    --*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      TARGET_DIR="$1"
      ;;
  esac
  shift
done

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

copy_lammuon_files() {
  local source_dir="$1"
  local target_dir="$2"
  local stamp
  stamp="$(date +%Y%m%d%H%M%S)"

  mkdir -p "$target_dir/.cursor/agents" "$target_dir/.cursor/rules"

  local copied=0
  local file dest
  for file in "$source_dir"/.cursor/agents/lammuon-*.md; do
    [[ -e "$file" ]] || continue
    dest="$target_dir/.cursor/agents/$(basename "$file")"
    if [[ -e "$dest" ]] && ! cmp -s "$file" "$dest"; then
      cp "$dest" "$dest.bak.$stamp"
    fi
    cp "$file" "$dest"
    copied=$((copied + 1))
  done

  for file in "$source_dir"/.cursor/rules/lammuon-*.mdc; do
    [[ -e "$file" ]] || continue
    dest="$target_dir/.cursor/rules/$(basename "$file")"
    if [[ -e "$dest" ]] && ! cmp -s "$file" "$dest"; then
      cp "$dest" "$dest.bak.$stamp"
    fi
    cp "$file" "$dest"
    copied=$((copied + 1))
  done

  if [[ "$copied" -eq 0 ]]; then
    echo "No lammuon agent/rule files found in source: $source_dir" >&2
    exit 1
  fi

  echo "Installed $copied lammuon files into: $target_dir/.cursor"
  echo "Restart Cursor or reload the window if the agents/rules do not appear immediately."
}

copy_cursor_global_agents() {
  local source_dir="$1"
  local target_dir="${HOME}/.cursor/agents"
  local stamp
  stamp="$(date +%Y%m%d%H%M%S)"

  mkdir -p "$target_dir"

  local copied=0
  local file dest
  for file in "$source_dir"/.cursor/agents/lammuon-*.md; do
    [[ -e "$file" ]] || continue
    dest="$target_dir/$(basename "$file")"
    if [[ -e "$dest" ]] && ! cmp -s "$file" "$dest"; then
      cp "$dest" "$dest.bak.$stamp"
    fi
    cp "$file" "$dest"
    copied=$((copied + 1))
  done

  if [[ "$copied" -eq 0 ]]; then
    echo "No lammuon Cursor agents found in source: $source_dir" >&2
    exit 1
  fi

  echo "Installed $copied Cursor global agents into: $target_dir"
  echo "Note: Cursor Project Rules still live in each project's .cursor/rules directory."
}

copy_codex_global_skill() {
  local source_dir="$1"
  local codex_home="${CODEX_HOME:-$HOME/.codex}"
  local skill_src="$source_dir/codex/skills/lammuon-team"
  local skill_dest="$codex_home/skills/lammuon-team"
  local stamp
  stamp="$(date +%Y%m%d%H%M%S)"

  if [[ ! -f "$skill_src/SKILL.md" ]]; then
    echo "Codex skill source not found: $skill_src/SKILL.md" >&2
    exit 1
  fi

  mkdir -p "$skill_dest/references/.cursor/agents" "$skill_dest/references/.cursor/rules"

  if [[ -f "$skill_dest/SKILL.md" ]] && ! cmp -s "$skill_src/SKILL.md" "$skill_dest/SKILL.md"; then
    cp "$skill_dest/SKILL.md" "$skill_dest/SKILL.md.bak.$stamp"
  fi
  cp "$skill_src/SKILL.md" "$skill_dest/SKILL.md"

  local copied=1
  local file dest
  for file in "$source_dir"/.cursor/agents/lammuon-*.md; do
    [[ -e "$file" ]] || continue
    dest="$skill_dest/references/.cursor/agents/$(basename "$file")"
    if [[ -e "$dest" ]] && ! cmp -s "$file" "$dest"; then
      cp "$dest" "$dest.bak.$stamp"
    fi
    cp "$file" "$dest"
    copied=$((copied + 1))
  done

  for file in "$source_dir"/.cursor/rules/lammuon-*.mdc; do
    [[ -e "$file" ]] || continue
    dest="$skill_dest/references/.cursor/rules/$(basename "$file")"
    if [[ -e "$dest" ]] && ! cmp -s "$file" "$dest"; then
      cp "$dest" "$dest.bak.$stamp"
    fi
    cp "$file" "$dest"
    copied=$((copied + 1))
  done

  echo "Installed Codex global skill into: $skill_dest"
  echo "Copied $copied files. Restart Codex if the skill is not listed immediately."
}

install_mode() {
  local source_dir="$1"
  case "$MODE" in
    project)
      copy_lammuon_files "$source_dir" "$TARGET_DIR"
      ;;
    cursor)
      copy_cursor_global_agents "$source_dir"
      ;;
    codex)
      copy_codex_global_skill "$source_dir"
      ;;
    all)
      copy_cursor_global_agents "$source_dir"
      copy_codex_global_skill "$source_dir"
      ;;
    *)
      echo "Unsupported mode: $MODE" >&2
      exit 1
      ;;
  esac
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
LOCAL_SOURCE=""

if [[ -n "$SCRIPT_DIR" && -d "$SCRIPT_DIR/../.cursor" ]]; then
  LOCAL_SOURCE="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

if [[ -n "$LOCAL_SOURCE" ]]; then
  install_mode "$LOCAL_SOURCE"
  exit 0
fi

require_cmd curl
require_cmd tar

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

ARCHIVE_URL="${REPO_URL}/archive/refs/heads/${BRANCH}.tar.gz"
echo "Downloading $ARCHIVE_URL"
curl -fsSL "$ARCHIVE_URL" | tar -xz -C "$TMP_DIR"

SOURCE_DIR="$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
if [[ -z "$SOURCE_DIR" || ! -d "$SOURCE_DIR/.cursor" ]]; then
  echo "Downloaded archive does not contain .cursor. Check repo/branch." >&2
  exit 1
fi

install_mode "$SOURCE_DIR"
