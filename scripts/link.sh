#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_AGENTS="${CLAUDE_AGENTS:-$HOME/.claude/agents}"
CLAUDE_SKILLS="${CLAUDE_SKILLS:-$HOME/.claude/skills}"
CURSOR_SKILLS="${CURSOR_SKILLS:-$HOME/.cursor/skills}"
CLAUDE_AGENT_MEMORY="${CLAUDE_AGENT_MEMORY:-$HOME/.claude/agent-memory}"

mkdir -p "$CLAUDE_AGENTS" "$CLAUDE_SKILLS" "$CURSOR_SKILLS" "$CLAUDE_AGENT_MEMORY"

link_memory() {
  local name="$1"
  local repo_memory="$REPO/agents/$name/memory"
  local claude_memory="$CLAUDE_AGENT_MEMORY/$name"

  mkdir -p "$repo_memory"

  # Migrate existing ~/.claude/agent-memory/<name> into repo if not already linked
  if [ -d "$claude_memory" ] && [ ! -L "$claude_memory" ]; then
    if [ -n "$(ls -A "$claude_memory" 2>/dev/null)" ]; then
      echo "    migrating memory → $repo_memory"
      cp -a "$claude_memory/." "$repo_memory/"
    fi
    rm -rf "$claude_memory"
  fi

  ln -sfn "$repo_memory" "$claude_memory"
  echo "    memory → $claude_memory"
}

echo "Linking agents from $REPO/agents/ → $CLAUDE_AGENTS/"
for agent_dir in "$REPO"/agents/*/; do
  [ -d "$agent_dir" ] || continue
  name="$(basename "$agent_dir")"
  agent_md="$agent_dir/agent.md"

  if [ ! -f "$agent_md" ]; then
    echo "  SKIP $name (no agent.md)"
    continue
  fi

  ln -sfn "$agent_md" "$CLAUDE_AGENTS/$name.md"
  echo "  $name.md"

  if grep -q '^memory:' "$agent_md"; then
    link_memory "$name"
  fi
done

echo ""
if [ -d "$REPO/private-context" ]; then
  echo "Linking private-context → $CLAUDE_SKILLS/private-context"
  ln -sfn "$REPO/private-context" "$CLAUDE_SKILLS/private-context"
  echo "Linking private-context → $CURSOR_SKILLS/private-context"
  ln -sfn "$REPO/private-context" "$CURSOR_SKILLS/private-context"
else
  echo "WARNING: private-context/ not found."
  echo "  Run: cp -r private-context.example private-context"
  echo "  Then edit private-context/SKILL.md with your environment details."
fi

echo "Done."
