# Case study: Fedora + KDE Plasma desktop setup

One real session's output from using an AI coding agent (Claude Code) directly
against a running desktop — not a hypothetical, the actual files and logs it
produced. Kept here as a concrete demonstration of what "the agent grows in a
directory" looks like in practice, under [`system-administration/`](../../categories/system-administration/).

**What happened:** the user asked, over several turns, for 3-finger touchpad
gestures on Fedora + KDE Plasma 6, a reference guide to Claude Code itself,
natural scrolling, screen-edge bindings, and fixes to some resulting rough
edges (an unwanted middle-click-paste gesture). The agent inspected the live
system over D-Bus, verified claims against upstream source before writing
them down, corrected an earlier wrong guess once it was checked against the
real system, and left behind a log of exactly what it changed and why.

## Files

| File | What it is |
|---|---|
| `CHANGES.md` | Full log of every system change made, with commands, rationale, and what's still pending |
| `touchpad-gestures.html` | The gesture setup guide (published as a Claude Artifact) |
| `claude-code-guide.html` | A Claude Code reference guide (published as a Claude Artifact) |
| `libinput-gestures.conf` | The working gesture-daemon config produced during the session |
| `install-gestures.sh` | One-shot installer script the agent wrote so the user only had to run one command |
| `terminal-workflow.md` | A snapshot of what else was running on the machine at the time, for context |

This is machine- and session-specific — the touchpad guide assumes Fedora and
KDE Plasma 6, and the config paths are this user's. It's kept as evidence of
the workflow, not as a generic template; see the category READMEs for the
general pattern this instance follows.
