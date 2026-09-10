# AI Agents & Claude Code — Entry Point

A personal reference for understanding AI coding agents in general, and
Claude Code specifically, in enough detail to actually use them well.
Written to be exported to PDF (VS Code + the `yzane.markdown-pdf`
extension: open this file, `Ctrl+Shift+P` → **Markdown PDF: Export
(pdf)**) and kept somewhere easy to reopen. Detailed, not exhaustive — this
gets refined over time rather than written once and frozen.

Every official-docs link below points at `code.claude.com/docs/en/...`,
verified against the live site while writing this (2026-09-11), not
recalled from memory — Claude Code's docs move, and an old cached URL is
worse than no link.

---

## Part 1 — AI agents, generically

Applies to any AI coding agent — Claude Code, Cursor, GitHub Copilot,
Aider, and others. Skip to Part 2 if you already know this.

### What makes something an "agent," not just a chatbot

A chatbot answers in text. An **agent** additionally has:

1. **Tools** — the ability to actually do things: read/write files, run
   shell commands, browse the web, call APIs. This is usually called
   *tool use* or *function calling*.
2. **A loop** — it doesn't just respond once. It observes the result of
   each tool call and decides the next step itself, repeating until the
   task looks done. This is the *agentic loop*: prompt → reasoning → tool
   call → observe result → repeat.
3. **Autonomy within limits** — it makes many small decisions on its own
   (which file to open, what command to run) without asking you each
   time, but should still involve you for consequential or irreversible
   ones.

That third point is the entire design tension of agent tooling: too
cautious and it's just a slow chatbot asking permission for everything;
too autonomous and it can do real damage before you notice. Every agent
tool solves this with some version of a **permission system** — see below.

### The context window

Everything an agent "knows" right now — your messages, its own past
responses, file contents it has read, tool results — lives in a single
**context window**, a fixed-size buffer of text. It is not persistent
memory; when it fills up, something has to give. Agents handle this with
**compaction** (summarizing older parts of the conversation to free space)
and various **memory** mechanisms that persist facts *outside* the context
window so they can be reloaded next time rather than kept in it forever.
This is why long sessions can "forget" something from much earlier, and
why well-designed agents write important facts down to a file instead of
relying on the conversation staying in context indefinitely.

### Permission models

Every serious agent tool has some version of:

- **Ask every time** — safest, slowest. Good for unfamiliar codebases.
- **Auto-approve routine actions, ask for risky ones** — the practical
  default once you trust the tool (Claude Code calls this `auto` mode).
- **Full autonomy** — no prompts at all, including for destructive
  actions. Fast, but you're trusting the agent completely; use it in
  disposable/sandboxed environments or when you've verified the specific
  task is safe.

None of these are "more correct" — it's a real trade-off between speed and
safety that should match how much you trust the tool *and* how reversible
the current task is.

### Sessions and persistence

A "session" is one continuous conversation with the agent. Most agents let
you **resume** a previous session rather than starting fresh, since
re-explaining context every time is wasteful. How resumption works (does
it replay the whole history? summarize it? pick up a saved state file?)
differs a lot between tools — see Claude Code's specifics below.

### Sub-agents / multi-agent delegation

More advanced agent tools let the main agent spawn **sub-agents** — separate
agent instances with their own context window, given a narrow task and
reporting back a result. This keeps the main conversation's context clean
(the sub-agent's exploration doesn't pollute it) and can run things in
parallel. It's a delegation pattern, not a different kind of intelligence.

### MCP: a shared standard for tool access

The **Model Context Protocol (MCP)** is an open standard (not
Claude-specific) for connecting an agent to external systems — a
database, an issue tracker, a design tool — through a common interface,
instead of every agent tool needing its own bespoke integration for every
service. If you see "MCP server" mentioned anywhere, it means "a small
program that exposes some tool/data source to any MCP-compatible agent."

### Prompting an agent well

The same principles as prompting any LLM, with an agent-specific twist:
be specific about the *outcome* you want and any constraints, but you
generally don't need to specify *how* — that's what the agentic loop is
for. Give it enough context to make good autonomous decisions (repo
conventions, what "done" looks like) rather than narrating every step
yourself. Correct it when it does something wrong; good agents remember
the correction going forward (see Auto memory below) instead of you
repeating yourself every session.

### Other agents worth knowing exist

Not a recommendation list — just names you'll encounter: **Cursor** and
**GitHub Copilot** (IDE-integrated), **Aider** (terminal, git-centric),
**Windsurf**, **Cline**. Most of these read a similar
[`AGENTS.md`](https://agents.md/)-style convention for repo instructions,
which is why this repo's own `CLAUDE.md` just points at `AGENTS.md` rather
than duplicating it — Claude Code specifically reads `CLAUDE.md`, not
`AGENTS.md`, but nothing stops `CLAUDE.md` from being a one-line pointer.

---

## Part 2 — Claude Code, in detail

Official docs hub: [code.claude.com/docs/en/overview](https://code.claude.com/docs/en/overview)

### What it actually is

Claude Code is Anthropic's agentic coding tool: reads your codebase,
edits files, runs commands, integrates with git and your dev tools. It
runs on several **surfaces** — terminal CLI, VS Code/JetBrains extension,
a desktop app, and the web (`claude.ai/code`) — all backed by the same
engine, sharing the same `CLAUDE.md` files, settings, and MCP servers.
This document focuses on the terminal CLI, since that's what's used
throughout this repo.

### Install

```bash
# macOS, Linux, WSL
curl -fsSL https://claude.ai/install.sh | bash

# Windows PowerShell
irm https://claude.ai/install.ps1 | iex
```

Also installable via Homebrew (`brew install --cask claude-code`), WinGet,
or Linux package managers (apt/dnf/apk). Native installs auto-update in
the background; Homebrew/WinGet installs need a manual `upgrade`.
Full options: [setup](https://code.claude.com/docs/en/setup) ·
troubleshooting: [troubleshoot-install](https://code.claude.com/docs/en/troubleshoot-install)

### Starting and resuming sessions

```bash
claude                        # interactive session in the current directory
claude "fix the failing test" # interactive session with an opening prompt
claude -p "summarize this"    # print-mode: answer once, then exit (scriptable)
claude -c                     # continue the most recent conversation here
claude -r "<session-id>"      # resume a specific session by ID or name
```

Sessions are stored per-project. Full CLI reference (there are many more
flags than listed here — this is the practical subset):
[cli-reference](https://code.claude.com/docs/en/cli-reference)

| Flag | Purpose |
|---|---|
| `-n, --name` | Name the session for easier resuming later |
| `--model` | Pick a model for this session |
| `--permission-mode` | Start in a specific permission mode (see below) |
| `--add-dir` | Grant access to an extra directory outside the cwd |
| `--settings <file>` | Load settings from a specific file for this run |
| `--output-format` | `text` / `json` / `stream-json` — for scripting |
| `--max-turns` | Cap the number of agentic loop iterations |
| `--fallback-model` | Auto-switch model if the primary is overloaded |

Piping works both ways — Claude Code follows the Unix philosophy:

```bash
tail -200 app.log | claude -p "flag anything unusual"
git diff main --name-only | claude -p "review these files for security issues"
```

### Slash commands (inside a session)

A few of the most commonly used; run `/help` for the full, current list —
it changes across versions more than anything else in this document:

| Command | Does |
|---|---|
| `/init` | Generate a starting `CLAUDE.md` from analyzing the repo |
| `/memory` | Browse/edit `CLAUDE.md` files and auto-memory |
| `/context` | Show what's actually loaded into context right now |
| `/resume` | Interactive session picker |
| `/mcp` | Manage MCP servers for this session |
| `/agents` | Manage sub-agents |
| `/compact` | Manually trigger context compaction |
| `/doctor` | Diagnose config/installation issues |
| `/permissions` | View/edit permission rules interactively |

### Permission modes

Set via `permissions.defaultMode` in settings, or `--permission-mode` /
`--dangerously-skip-permissions` on the command line.

| Mode | Behavior |
|---|---|
| `default` | Prompts before anything that reads/writes outside a small safe set |
| `plan` | Research-only — proposes a plan, makes no changes until approved |
| `acceptEdits` | Auto-approves file edits, still prompts for other risky actions |
| `auto` | Auto-approves routine actions, still stops for destructive/irreversible ones |
| `bypassPermissions` | No prompts at all, for anything, ever |
| `dontAsk` | Alias-adjacent mode, similar intent to `auto` |

**Verified gotcha (Claude Code ≥ v2.1.257, confirmed against this
machine's v2.1.268):** the `auto` and `bypassPermissions` values only take
effect when set in **user** (`~/.claude/settings.json`) or **managed**
settings — setting them in a **project** (`.claude/settings.json`) or
**local** (`.claude/settings.local.json`) file is silently ignored. If you
want project-scoped autonomy, use `--permission-mode` per invocation, or
accept that only the user-level setting actually controls this. (This
repo's own per-project `.claude/settings.local.json` files predate this
being discovered — see `gtd/inbox.md` for the cleanup note.)

Docs: [settings](https://code.claude.com/docs/en/settings) ·
[permissions](https://code.claude.com/docs/en/permissions)

### Settings files and precedence

Highest to lowest — a key set higher overrides the same key set lower:

1. **Managed settings** — org policy (MDM / `managed-settings.json` / claude.ai console)
2. **Command line** — `claude --settings <file>`, for one invocation
3. **Project local** — `.claude/settings.local.json` (gitignore this — personal)
4. **Shared project** — `.claude/settings.json` (commit this — team-shared)
5. **User** — `~/.claude/settings.json` (you, every project)

Full schema: [settings-reference](https://code.claude.com/docs/en/settings-reference)

### Memory: `CLAUDE.md` vs. auto memory

Two complementary systems, both loaded at the start of every session:

|  | `CLAUDE.md` | Auto memory |
|---|---|---|
| Who writes it | You | Claude, on its own |
| Contains | Instructions, rules, conventions | Learnings, corrections, preferences |
| Use for | "Always run `X` before committing" | "This user prefers terse commit messages" |

`CLAUDE.md` can live at multiple scopes (managed policy → user
`~/.claude/CLAUDE.md` → project `./CLAUDE.md` → local `./CLAUDE.local.md`,
gitignored) — all discovered files get concatenated into context, not
overridden. **Claude Code reads `CLAUDE.md`, not `AGENTS.md`** — if a repo
already has an `AGENTS.md` (a cross-tool convention), the standard move is
a `CLAUDE.md` that just does `@AGENTS.md` to import it, exactly like this
repo's own `CLAUDE.md` does.

Auto memory is on by default, stored at
`~/.claude/projects/<project>/memory/` as a `MEMORY.md` index plus one
file per memory, and only the index (first 200 lines / 25KB) loads
automatically — topic files load on demand. Toggle it via `/memory` or
`autoMemoryEnabled` in settings.

Docs: [memory](https://code.claude.com/docs/en/memory)

### MCP in Claude Code

```bash
# Remote server, HTTP transport (recommended for anything not local)
claude mcp add --transport http <name> <url>

# Local process, stdio transport
claude mcp add --transport stdio <name> -- <command> [args...]

# Scope: local (just you, this project) is default; add --scope project
# to share via a committed .mcp.json, or --scope user for all your projects
claude mcp add --scope project --transport http <name> <url>
```

Transports: **HTTP** (recommended for remote services), **stdio** (local
processes), **SSE** (deprecated, use HTTP instead), **WebSocket**
(JSON-config only). Manage servers interactively with `/mcp`, or
`claude mcp list` / `get` / `remove` from the shell.

This document deliberately doesn't recommend specific third-party MCP
servers — that's a personal choice per task, and the ecosystem changes
fast. Docs: [mcp](https://code.claude.com/docs/en/mcp) ·
[mcp-quickstart](https://code.claude.com/docs/en/mcp-quickstart)

### Skills, hooks, and sub-agents

- **Skills** — package a repeatable workflow (e.g. "review a PR my way")
  that loads on demand rather than every session. Docs:
  [skills](https://code.claude.com/docs/en/skills)
- **Hooks** — shell commands that run at fixed lifecycle points
  (before/after a tool call, on session start, etc.) — actual enforcement,
  unlike `CLAUDE.md` which is just context Claude tries to follow. Docs:
  [hooks](https://code.claude.com/docs/en/hooks)
- **Sub-agents** — delegate a narrow task to a fresh agent with its own
  context; the main conversation only sees the result, not the
  exploration that produced it. Docs:
  [sub-agents](https://code.claude.com/docs/en/sub-agents)

### Beyond the terminal

Same engine, different surface — useful to know these exist even if the
terminal is the daily driver:

| Want to... | Use |
|---|---|
| Keep working from your phone | [Remote Control](https://code.claude.com/docs/en/remote-control) |
| Run on a schedule (cloud) | [Routines](https://code.claude.com/docs/en/routines) |
| Run on a schedule (local, one session) | [`/loop`](https://code.claude.com/docs/en/scheduled-tasks) |
| Automate PR review in CI | [GitHub Actions](https://code.claude.com/docs/en/github-actions) |
| Build a fully custom agent on Claude Code's engine | [Agent SDK](https://code.claude.com/docs/en/agent-sdk/overview) |

### Where to go deeper

- [quickstart](https://code.claude.com/docs/en/quickstart) — a full first
  real task, start to finish
- [common-workflows](https://code.claude.com/docs/en/common-workflows) and
  [best-practices](https://code.claude.com/docs/en/best-practices)
- [troubleshooting](https://code.claude.com/docs/en/troubleshooting)
- [glossary](https://code.claude.com/docs/en/glossary) — precise
  definitions for terms this document uses loosely
