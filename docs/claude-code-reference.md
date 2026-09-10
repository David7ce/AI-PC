# Claude Code — Full Reference

A detailed, working reference for the Claude Code CLI — install, every
subcommand and flag, every slash command, permissions, settings, memory,
MCP, and plugins. Companion to
[`ai-agent-concepts.md`](ai-agent-concepts.md), which covers the
generic ideas (agentic loop, context windows, permission models) that
apply to any AI agent and aren't repeated here.

Written to be exported to PDF (VS Code + the `yzane.markdown-pdf`
extension: open this file, `Ctrl+Shift+P` → **Markdown PDF: Export
(pdf)**). Every link below points at `code.claude.com/docs/en/...`,
verified live against the site on 2026-09-11, not recalled from memory —
this moves faster than most docs, and a stale cached URL is worse than no
link. Refined over time rather than written once and frozen.

Official docs hub: [code.claude.com/docs/en/overview](https://code.claude.com/docs/en/overview)

---

## What it is, and where it runs

Claude Code is Anthropic's agentic coding tool: reads your codebase,
edits files, runs commands, integrates with git and your dev tools. The
same engine runs on several **surfaces**, all sharing the same
`CLAUDE.md` files, settings, and MCP servers:

| Surface | What it adds |
|---|---|
| **Terminal CLI** | Full-featured, scriptable — this document's focus |
| **VS Code / JetBrains** | Inline diffs, @-mentions, plan review in the editor |
| **Desktop app** | Visual diff review, multiple sessions side by side, scheduling |
| **Web** (`claude.ai/code`) | No local setup, long-running tasks, work on repos you don't have locally |

## Install

```bash
# macOS, Linux, WSL
curl -fsSL https://claude.ai/install.sh | bash

# Windows PowerShell
irm https://claude.ai/install.ps1 | iex

# Windows CMD
curl -fsSL https://claude.ai/install.cmd -o install.cmd && install.cmd && del install.cmd
```

Also installable via `brew install --cask claude-code` (Homebrew),
`winget install Anthropic.ClaudeCode` (WinGet), or apt/dnf/apk on
Debian/Fedora/RHEL/Alpine. **Native installs auto-update in the
background**; Homebrew/WinGet installs need a manual `brew upgrade
claude-code` / `winget upgrade Anthropic.ClaudeCode`.

```bash
cd your-project
claude          # first run prompts you to log in
```

Docs: [setup](https://code.claude.com/docs/en/setup) (advanced install,
manual updates, uninstall) ·
[troubleshoot-install](https://code.claude.com/docs/en/troubleshoot-install) ·
[quickstart](https://code.claude.com/docs/en/quickstart)

---

## CLI subcommands

Everything after `claude` on the command line. The bare `claude` command
starts an interactive session; everything else here is a distinct
subcommand.

| Command | Does |
|---|---|
| `claude` | Start interactive session |
| `claude "query"` | Start interactive session with an opening prompt |
| `claude -p "query"` | Print mode: answer once, then exit (scriptable) |
| `claude -c` | Continue the most recent conversation in this directory |
| `claude -r "<session>"` | Resume a session by ID or name |
| `claude update` | Update to the latest version |
| `claude install [version]` | Install or reinstall the native binary |
| `claude auth login` / `logout` / `status` | Sign in / out / show auth status |
| `claude setup-token` | Generate a long-lived OAuth token for CI/scripts |
| `claude doctor` | Read-only installation and settings diagnostics |
| `claude mcp ...` | Configure MCP servers (see [MCP](#mcp) below) |
| `claude plugin ...` | Manage plugins (see [Plugins](#plugins) below) |
| `claude agents` | Open agent view: monitor/dispatch parallel background sessions |
| `claude attach <id>` | Attach to a background session in this terminal |
| `claude respawn <id>` | Restart a background session, conversation intact |
| `claude logs <id>` | Print recent output from a background session |
| `claude stop <id>` (alias `kill`) | Stop a background session |
| `claude rm <id>` | Remove a background session from the list |
| `claude daemon status` / `stop` | Background-session supervisor status / stop it |
| `claude gateway` | Start the self-hosted Claude apps gateway server |
| `claude self-hosted-runner` | Start a runner process for self-hosted environments |
| `claude remote-control` | Start Remote Control server (control from claude.ai) |
| `claude import [source]` | Bring configuration in from another coding agent |
| `claude project purge [path]` | Delete all local Claude Code state for a project |
| `claude auto-mode defaults` | Print built-in auto-mode classifier rules as JSON |
| `claude auto-mode reset` | Restore default auto-mode configuration |
| `claude ultrareview [target]` | Run ultrareview non-interactively |

## CLI flags

The practical set, grouped. There are more (see the full
[cli-reference](https://code.claude.com/docs/en/cli-reference)) but these
cover normal day-to-day and scripted use.

**Session basics**

| Flag | Purpose |
|---|---|
| `-p, --print` | Answer once without interactive mode |
| `-c, --continue` | Load the most recent conversation here |
| `-r, --resume "<session>"` | Resume a specific session by ID or name |
| `-n, --name` | Name the session, for easier resuming later |
| `--fork-session` | Resume into a *new* session ID instead of reusing the original |
| `--add-dir` | Grant access to an extra directory outside the cwd |
| `--bg, --background` | Start as a background agent, return immediately |

**Model & behavior**

| Flag | Purpose |
|---|---|
| `--model` | Pick a model (alias or full name) for this session |
| `--effort` | `low` / `medium` / `high` / `xhigh` / `max` / `ultracode` |
| `--fallback-model` | Auto-switch model if the primary is overloaded |
| `--max-turns` | Cap the number of agentic-loop iterations |
| `--max-budget-usd` | Hard dollar cap on API spend for the session |
| `--agent` | Use a specific (sub)agent definition for the main thread |
| `--agents` | Define custom subagents dynamically via JSON |

**Permissions & tools**

| Flag | Purpose |
|---|---|
| `--permission-mode` | Start in a specific mode — see [Permission modes](#permission-modes) |
| `--dangerously-skip-permissions` | Shorthand for `--permission-mode bypassPermissions` |
| `--allowedTools` / `--disallowedTools` | Allow/deny specific tools without prompting |
| `--permission-prompt-tool` | MCP tool that answers permission prompts in non-interactive mode |

**MCP & plugins**

| Flag | Purpose |
|---|---|
| `--mcp-config` | Load MCP servers from JSON files or an inline string |
| `--plugin-dir` | Load a plugin from a local directory or `.zip` (repeatable) |
| `--plugin-url` | Fetch a plugin `.zip` from a URL for this session only |

**System prompt**

| Flag | Purpose |
|---|---|
| `--append-system-prompt` / `--append-system-prompt-file` | Add to the default system prompt |
| `--system-prompt` / `--system-prompt-file` | Replace the entire system prompt |
| `--append-subagent-system-prompt[-file]` | Same, but for every subagent's prompt |

**Scripting & automation**

| Flag | Purpose |
|---|---|
| `--output-format` | `text` / `json` / `stream-json` |
| `--input-format` | `text` / `stream-json` |
| `--json-schema` | Get validated JSON output matching a JSON Schema |
| `--exec` | Run a shell command as a PTY-backed background job |
| `--no-session-persistence` | Don't write a session transcript at all |
| `--autocompact <auto\|tokens>` | Set the auto-compact window for this session |

**Diagnostics**

| Flag | Purpose |
|---|---|
| `--debug` | Enable debug mode (optionally filtered by category) |
| `--debug-file <path>` | Write debug logs to a specific file |
| `--safe-mode` | Start with all customizations disabled, for troubleshooting |
| `--bare` | Minimal mode — skip auto-discovery for faster startup |

Full reference (every flag, including web/remote/CI-specific ones not
listed above): [cli-reference](https://code.claude.com/docs/en/cli-reference)

**Piping** — Claude Code follows the Unix philosophy both directions:

```bash
tail -200 app.log | claude -p "flag anything unusual"
git diff main --name-only | claude -p "review these files for security issues"
```

---

## Slash commands

Typed inside a running session. Run `/help` any time for the current,
authoritative list — it changes across versions faster than anything else
in this document. Organized here by what they're for.

**Project setup & configuration**

| Command | Does |
|---|---|
| `/init` | Generate a starting `CLAUDE.md` by analyzing the repo |
| `/memory` | Edit `CLAUDE.md` files, toggle auto memory, view memory entries |
| `/mcp [reconnect\|enable\|disable]` | Manage MCP server connections and OAuth |
| `/permissions` | View/edit allow, ask, and deny rules |
| `/config [key=value]` | Open settings, or set a key directly |
| `/keybindings` | Open the keyboard-shortcuts file |
| `/hooks` | View hook configuration for tool events |

**Model & performance**

| Command | Does |
|---|---|
| `/model [model]` | Switch model, saves as default |
| `/effort [level\|auto\|status]` | Set effort level |
| `/fast [on\|off]` | Toggle fast mode |
| `/autocompact [auto\|tokens]` | Set the auto-compact window |
| `/compact [instructions]` | Manually free context by summarizing |
| `/advisor [model\|off]` | Enable/disable the server-side advisor tool |

**Navigation & session management**

| Command | Does |
|---|---|
| `/cd <path>` | Move the session to a new working directory |
| `/add-dir <path>` | Add a working directory for file access |
| `/clear [name]` | Start a new conversation, empty context |
| `/resume` | Interactive picker for an earlier conversation |
| `/branch [name]` | Branch the current conversation |
| `/fork [prompt]` | Copy the current conversation into a new background session |
| `/background [prompt]` (alias `/bg`) | Detach the session to run in the background |
| `/teleport` | Pull a web session into the terminal |
| `/remote-control` | Continue this session from another device |
| `/exit` (alias `/quit`) | Exit the CLI |

**Code review & quality**

| Command | Does |
|---|---|
| `/diff` | Review changes in the working tree |
| `/code-review [level] [--fix] [--comment] [pr#\|branch\|path]` (alias `/review`) | Review a diff/PR for bugs and cleanup |
| `/security-review` | Check the diff for security vulnerabilities |
| `/simplify` | Simplification pass (reuse/efficiency, not bug-hunting) |

**Development workflows**

| Command | Does |
|---|---|
| `/plan [description]` | Enter plan mode |
| `/batch <instruction>` | Orchestrate large-scale changes across the codebase in parallel |
| `/debug [description]` | Enable debug logging, troubleshoot |
| `/goal [condition\|clear]` | Set a goal Claude works toward until met |
| `/tasks` | List the session's background work, including subagents |
| `/subtask` | Hand a side task to a subagent that reports back |
| `/loop [interval] [prompt]` (alias `/proactive`) | Run a prompt repeatedly on a schedule |

**Utilities & information**

| Command | Does |
|---|---|
| `/help` | Show help and the current command list |
| `/status` | Session status |
| `/usage` (alias `/cost`) | API usage and cost |
| `/context [all]` | Visualize current context usage |
| `/btw [question]` | Side question that doesn't enter conversation history |
| `/copy [N]` | Copy the last (or Nth) assistant response |
| `/export [filename]` | Export the conversation as plain text |
| `/theme` / `/color` | Theme / prompt-bar color |
| `/focus` | Toggle a focus view (last prompt/response only) |

**Feedback & reporting**

| Command | Does |
|---|---|
| `/feedback [report]` | Send product feedback |
| `/bug [report]` (alias `/share`) | Report a bug / share the conversation |
| `/doctor` | Setup checkup and diagnosis |

**Code recovery**

| Command | Does |
|---|---|
| `/rewind` | Roll code and conversation back to a checkpoint |

**Design**

| Command | Does |
|---|---|
| `/design [brief]` | Draft UI mockups as Artifacts |
| `/design-sync [hint]` | Convert a React design system, upload to Claude Design |
| `/dataviz [request]` | Guidance for charts, graphs, dashboards |

**Research**

| Command | Does |
|---|---|
| `/deep-research <question>` | Fan out web searches, synthesize a cited report |
| `/insights` | HTML report analyzing recent sessions |

**Account**

| Command | Does |
|---|---|
| `/login` / `/logout` | Sign in / out |
| `/upgrade` | Upgrade plan (not shown on Enterprise) |

**IDE & integrations**

| Command | Does |
|---|---|
| `/ide` | Manage IDE integrations |
| `/desktop` (alias `/app`) | Continue this session in the Desktop app |
| `/mobile` (aliases `/ios`, `/android`) | QR code for the Claude mobile app |
| `/chrome` | Configure Claude-in-Chrome |
| `/plugin [subcommand]` | Manage plugins — see [Plugins](#plugins) |
| `/reload-plugins` | Reload plugins after a change |
| `/install-github-app` / `/install-slack-app` | Install the GitHub / Slack app |
| `/autofix-pr [prompt]` | Spawn a session that watches a PR and pushes fixes |

**Agents**

| Command | Does |
|---|---|
| `/agents` | Manage subagent configurations |
| `/list-agents` (alias `/peers`) | List subagents, teammates, other sessions |

**Misc**

| Command | Does |
|---|---|
| `/import [codex\|gemini\|cursor]` | Bring in configuration from another tool |
| `/fewer-permission-prompts` | Scan transcripts, add an allowlist to reduce prompts |

Full, current list: [commands](https://code.claude.com/docs/en/commands)

---

## Permission modes

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

**Verified gotcha (Claude Code ≥ v2.1.257):** `auto` and
`bypassPermissions` only take effect from **user**
(`~/.claude/settings.json`) or **managed** settings. Setting either in a
**project** (`.claude/settings.json`) or **local**
(`.claude/settings.local.json`) file is silently ignored. For
project-scoped autonomy, use `--permission-mode` per invocation instead —
there's no settings-file equivalent that works at that scope anymore.

Docs: [settings](https://code.claude.com/docs/en/settings) ·
[permissions](https://code.claude.com/docs/en/permissions)

## Settings files and precedence

Highest to lowest — a key set higher overrides the same key set lower:

1. **Managed settings** — org policy (MDM / `managed-settings.json` / claude.ai console)
2. **Command line** — `claude --settings <file>`, for one invocation
3. **Project local** — `.claude/settings.local.json` (gitignore this — personal)
4. **Shared project** — `.claude/settings.json` (commit this — team-shared)
5. **User** — `~/.claude/settings.json` (you, every project)

Full schema: [settings-reference](https://code.claude.com/docs/en/settings-reference)

---

## Memory: `CLAUDE.md` vs. auto memory

Two complementary systems, both loaded at the start of every session:

|  | `CLAUDE.md` | Auto memory |
|---|---|---|
| Who writes it | You | Claude, on its own |
| Contains | Instructions, rules, conventions | Learnings, corrections, preferences |
| Use for | "Always run `X` before committing" | "This user prefers terse commit messages" |

**`CLAUDE.md` locations**, broadest to most specific (all discovered files
get concatenated into context, not overridden):

| Scope | Location | Shared with |
|---|---|---|
| Managed policy | `/etc/claude-code/CLAUDE.md` (Linux) | Whole organization |
| User | `~/.claude/CLAUDE.md` | Just you, every project |
| Project | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team, via source control |
| Local | `./CLAUDE.local.md` | Just you, this project (gitignore it) |

**Claude Code reads `CLAUDE.md`, not `AGENTS.md`.** If a repo already has
an `AGENTS.md` (a cross-tool convention many agents share), the standard
move is a `CLAUDE.md` that imports it:

```markdown
@AGENTS.md

## Claude Code
Use plan mode for changes under src/billing/.
```

Exactly the pattern this repo's own `CLAUDE.md` uses. Run `/init` to
generate a starting `CLAUDE.md` from the codebase, or `/import` to pull in
configuration from Cursor/Copilot/Codex/Gemini and other tools.

**Auto memory** is on by default, stored at
`~/.claude/projects/<project>/memory/` as a `MEMORY.md` index (only the
first 200 lines / 25KB load automatically) plus one topic file per memory
(loaded on demand). Toggle with `/memory` or `autoMemoryEnabled` in
settings. Four kinds of note: `user` (your role/preferences), `feedback`
(corrections you've given), `project` (context Claude can't derive from
code), `reference` (pointers to external systems).

Docs: [memory](https://code.claude.com/docs/en/memory)

---

## MCP

```bash
# Remote server, HTTP transport (recommended for anything not local)
claude mcp add --transport http <name> <url>

# Local process, stdio transport
claude mcp add --transport stdio <name> -- <command> [args...]

# Scope: local (just you, this project) is default
claude mcp add --scope project --transport http <name> <url>   # shared, via .mcp.json
claude mcp add --scope user --transport http <name> <url>      # all your projects
```

| Command | Does |
|---|---|
| `claude mcp add` | Add a server (flags above control transport/scope) |
| `claude mcp list` | List configured servers |
| `claude mcp get <name>` | Show details for one server |
| `claude mcp remove <name>` | Remove a server |
| `claude mcp login <name>` / `logout <name>` | OAuth sign-in / clear credentials |
| `/mcp` (in-session) | Manage servers interactively |

Transports: **HTTP** (recommended for remote services), **stdio** (local
processes), **SSE** (deprecated — use HTTP), **WebSocket** (JSON-config
only). This document doesn't recommend specific third-party MCP
servers — that's a per-task choice and the ecosystem moves fast.

Docs: [mcp](https://code.claude.com/docs/en/mcp) ·
[mcp-quickstart](https://code.claude.com/docs/en/mcp-quickstart)

---

## Plugins

A plugin bundles skills, agents, hooks, and/or MCP/LSP servers into one
shareable, versioned unit — the step up from personal `.claude/`
customization once you want to share or reuse across projects.

**Using plugins someone else made:**

```bash
/plugin marketplace add anthropics/claude-plugins-official   # usually automatic on first run
/plugin install <name>@claude-plugins-official
/plugin list [--enabled|--disabled]
/plugin enable <name>@<marketplace>
/plugin disable <name>@<marketplace>
/plugin uninstall <name>@<marketplace>
/plugin marketplace list
/plugin marketplace update <marketplace-name>
/plugin marketplace remove <marketplace-name>
```

Non-interactive equivalents for scripting (don't open the panel):
`claude plugin install <name>@<marketplace> [--scope project|user|local]`,
`claude plugin uninstall`, `claude plugin details <name>`. Two official
Anthropic-run marketplaces exist: `claude-plugins-official` (curated,
added automatically) and `claude-community` (public submissions,
add manually with `/plugin marketplace add anthropics/claude-plugins-community`).

**Building your own** (brief — full guide linked below):

```bash
claude plugin init my-tool       # scaffold ~/.claude/skills/my-tool/, loads automatically
claude --plugin-dir ./my-plugin  # test a plugin without installing it
claude plugin validate ./my-plugin
```

A plugin is a directory with a `.claude-plugin/plugin.json` manifest at
its root, plus any of: `skills/`, `commands/`, `agents/`, `hooks/`
(`hooks.json`), `.mcp.json`, `.lsp.json`, `monitors/`, `bin/`,
`settings.json`. Skills are namespaced as `/plugin-name:skill-name` to
avoid collisions.

**Security note:** plugins and marketplaces run with your user
privileges. Only install/add ones you trust — Anthropic doesn't vet
third-party marketplace contents beyond automated screening.

Docs: [discover-plugins](https://code.claude.com/docs/en/discover-plugins)
(installing/managing) ·
[plugins](https://code.claude.com/docs/en/plugins) (building) ·
[plugin-marketplaces](https://code.claude.com/docs/en/plugin-marketplaces)
(distributing) ·
[plugins-reference](https://code.claude.com/docs/en/plugins-reference)
(full technical spec)

---

## Skills, hooks, and sub-agents

- **Skills** — package a repeatable workflow (e.g. "review a PR my way")
  that loads on demand instead of every session. Docs:
  [skills](https://code.claude.com/docs/en/skills)
- **Hooks** — shell commands that run at fixed lifecycle points
  (before/after a tool call, on session start, etc.) — actual
  enforcement, unlike `CLAUDE.md` which is context Claude tries to
  follow. Docs: [hooks](https://code.claude.com/docs/en/hooks)
- **Sub-agents** — delegate a narrow task to a fresh agent with its own
  context; the main conversation only sees the result. Docs:
  [sub-agents](https://code.claude.com/docs/en/sub-agents)

---

## Beyond the terminal

| Want to... | Use |
|---|---|
| Keep working from your phone | [Remote Control](https://code.claude.com/docs/en/remote-control) |
| Run on a schedule (cloud) | [Routines](https://code.claude.com/docs/en/routines) |
| Run on a schedule (local, one session) | [`/loop`](https://code.claude.com/docs/en/scheduled-tasks) |
| Automate PR review in CI | [GitHub Actions](https://code.claude.com/docs/en/github-actions) |
| Build a fully custom agent on Claude Code's engine | [Agent SDK](https://code.claude.com/docs/en/agent-sdk/overview) |

---

## Where to go deeper

- [quickstart](https://code.claude.com/docs/en/quickstart) — a full first
  real task, start to finish
- [common-workflows](https://code.claude.com/docs/en/common-workflows) and
  [best-practices](https://code.claude.com/docs/en/best-practices)
- [troubleshooting](https://code.claude.com/docs/en/troubleshooting)
- [glossary](https://code.claude.com/docs/en/glossary) — precise
  definitions for terms this document uses loosely
