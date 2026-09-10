# Case study: Fedora + KDE Plasma desktop setup

One real session's output from using an AI coding agent (Claude Code) directly
against a running desktop — not a hypothetical, the actual files and logs it
produced. Kept here as a concrete demonstration of what "the agent grows in a
directory" looks like in practice, under [`system-administration/`](../../categories/system-administration/).

**What happened:** the user asked, over many turns, for 3-finger touchpad
gestures on Fedora + KDE Plasma 6, a reference guide to Claude Code itself,
natural scrolling, screen-edge bindings, and fixes to rough edges along the
way (an unwanted middle-click-paste gesture, a native desktop-switch
gesture silently fighting the new window-focus mapping, an unanimated
"minimize all"). The agent inspected the live system over D-Bus, verified
every claim against upstream KWin source before writing it down, corrected
earlier wrong guesses once checked against the real system, and left behind
a log of exactly what it changed and why.

**Final confirmed gesture mapping** (3-finger swipe): up = Overview, down =
animated minimize-all, left/right = window-focus cycle (not desktop
switching — that trade-off, and why, is written up in `CHANGES.md` and in
the guide itself). All four confirmed with a real physical touchpad
gesture, not just a D-Bus dry run.

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
