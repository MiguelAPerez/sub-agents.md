---
name: private-context
description: >-
  Personal environment specifics for sub-agents — SSH hosts, infrastructure
  paths, CI/deploy workflows, and git conventions stripped from the generic
  agent definitions. Read this skill when running sub-agents in your environment.
---

# Private Context

Copy this directory to `private-context/` and fill in your details:

```bash
cp -r private-context.example private-context
```

**Sub-agents should read this skill before acting** when launched in your environment.

---

## Paths

| Item | Value |
|------|-------|
| Sub-agents repo | `~/development/sub-agents.md` |
| Agent memory root | `~/development/sub-agents.md/agents/<agent-name>/memory/` |

Agents with persistent memory write to the repo path above. Under Claude Code,
`link.sh` also symlinks each `memory/` dir to `~/.claude/agent-memory/<agent-name>/`.

---

## remote-host-debugger

### Infrastructure stack

| Item | Value |
|------|-------|
| SSH access | `ssh <user>@<host>` |
| Infra repo (local) | `~/path/to/infrastructure` |
| Infra repo (remote) | `~/path/to/infrastructure` on `<host>` |
| Compose layout | `components/<component>.yml` |
| Docker network | `<network-name>` |
| Env vars | root `.env` file |
| Service manager | `./toolkit start/stop/upgrade <component>` (if applicable) |

### Key services

List your services here (e.g. monitoring, CI, DNS, etc.)

### SSH examples

```bash
ssh <user>@<host> "<command>"
ssh <user>@<host> "cd ~/path/to/infrastructure && <command>"
```

### Deploy workflow (production changes)

Describe your approved production deploy path:

1. Open a PR in `<org>/<infra-repo>`
2. Merge after review
3. CI runs `<pipeline-name>`

### GPU / hardware diagnostics (if applicable)

```bash
ssh <user>@<host> "<gpu-status-command>"
ssh <user>@<host> "docker logs <service> --tail=100"
```

---

## git-workflow-manager (jimmy)

### Git hosting CLIs

Which CLIs are available (e.g. `gh` for GitHub, `tea` for Gitea).

### Commit message format

Describe your required format (e.g. Conventional Commits, Commitizen, ticket prefixes).

### Branch naming

Describe your branch naming conventions (e.g. `feat/`, `fix/`).

### History preference

e.g. linear history with rebase, merge commits allowed, etc.
