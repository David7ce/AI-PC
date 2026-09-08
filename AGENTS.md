# Operating instructions for AI agents working in this directory

This file is for you, the agent — Claude Code or otherwise. If you're a
human, see [`README.md`](README.md) instead.

## What this directory is

AI+PC is a growing, organized workspace on a personal computer. There is no
fixed roadmap and no backlog — the *only* input is whatever the user prompts
next. Your job is to take that prompt, place the resulting work in the right
place, and leave the directory more organized than you found it, not less.

This is designed to work the same way on Linux, macOS, and Windows, and with
any AI coding agent capable of reading and writing files — Claude Code is
the reference implementation, not a requirement.

## Before you start any task

1. Read [`docs/taxonomy.md`](docs/taxonomy.md) if you haven't already this
   session — it defines the seven categories under `categories/` and which
   O\*NET-SOC occupational group each maps to.
2. Match the user's request to the closest category.
3. Check whether an existing subdirectory already covers this specific
   project/topic before creating a new one — extend, don't duplicate.

## While working

- **One task, one subdirectory.** `categories/<domain>/<task-name>/`. Don't
  scatter one project's files across the category root.
- **Every subdirectory gets a README.** State what it is, what platform or
  tool it assumes (if any), and the date if that matters for the content
  (research findings, system-state logs).
- **Log system-affecting changes.** If a task changes real machine state
  (installs something, edits a config file, changes an OS setting), keep a
  short changelog in that task's directory — command run, why, what's still
  pending. See `examples/fedora-kde-desktop-setup/CHANGES.md` for the shape
  this takes.
- **Verify before documenting.** Don't write down how something works from
  memory when you can check the running system, the actual source, or the
  actual file. If something you previously wrote turns out to be wrong once
  checked, correct it — don't leave stale claims standing.
- **Cross-category work gets split, not forced.** A request that spans two
  domains (e.g. "build a tool and design its icon") gets two subdirectories
  in two categories, cross-linked from each other's README.
- **No category fits?** That's a real signal, not a failure — propose an
  eighth category rather than jamming the work somewhere it doesn't belong,
  and update `docs/taxonomy.md` if the user agrees.

## Permissions

This repo's `.claude/settings.local.json` sets `bypassPermissions` — act
autonomously on routine work. Still stop and ask before anything genuinely
destructive or hard to reverse, and before any action outside this
directory tree that affects the wider system, a remote service, or another
person.
