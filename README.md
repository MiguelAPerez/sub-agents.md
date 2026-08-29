# sub-agents.md

Harness-agnostic sub-agent definitions. Generic prompts live here; personal
config and runtime memory are gitignored.

## Dependencies

- **`persistent-agent-memory`** skill from [`agent-skills.md`](../agent-skills.md) —
  shared memory types, save/recall rules, and indexing. Symlink it into
  `~/.claude/skills/` and/or `~/.cursor/skills/`.
- **`private-context`** — your personal env config (copy from `private-context.example/`).

## Layout

```
sub-agents.md/
├── agents/
│   ├── remote-host-debugger/
│   │   ├── agent.md              # committed — generic agent definition
│   │   └── memory/               # gitignored — runtime learnings
│   └── git-workflow-manager/
│       └── agent.md
├── private-context/              # gitignored — your personal env config
├── private-context.example/      # committed — template
└── scripts/link.sh
```

## First-time setup

```bash
# 1. Symlink shared skills (if not already)
ln -sf ~/development/agent-skills.md/persistent-agent-memory ~/.claude/skills/persistent-agent-memory
ln -sf ~/development/agent-skills.md/persistent-agent-memory ~/.cursor/skills/persistent-agent-memory

# 2. Create your private config
cp -r private-context.example private-context
# edit private-context/SKILL.md — paths, hosts, git conventions

# 3. Wire agents into Claude Code (optional — Cursor uses repo paths directly)
./scripts/link.sh
```

## Memory — harness-agnostic

Memory files live in **`agents/<name>/memory/`** in this repo. That is the
canonical path for every harness:

| Harness | How agents reach the same files |
|---------|--------------------------------|
| **Cursor** | Read/write the repo path directly |
| **Claude Code** | `link.sh` symlinks each `memory/` to `~/.claude/agent-memory/<name>/` |

Agents reference the **`persistent-agent-memory`** skill for *how* to save;
`private-context` holds *where* (repo root path).

## link.sh symlinks (Claude Code)

| Repo path | Symlink target |
|-----------|----------------|
| `agents/<name>/agent.md` | `~/.claude/agents/<name>.md` |
| `agents/<name>/memory/` | `~/.claude/agent-memory/<name>/` |
| `private-context/` | `~/.claude/skills/private-context` and `~/.cursor/skills/private-context` |

## Generic vs private

| Committed | Gitignored |
|-----------|------------|
| Agent methodology and safety rules | SSH hosts, infra paths, service names |
| Pointer to `persistent-agent-memory` skill | Memory files (`agents/*/memory/`) |
| Placeholder patterns | Deploy workflows, commit conventions |

## Publishing

Safe to publish as-is. Others copy `private-context.example/` and symlink
`persistent-agent-memory` from `agent-skills.md`.
