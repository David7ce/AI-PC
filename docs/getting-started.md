# Getting started

## Use it on your own machine

```bash
git clone https://github.com/David7ce/AI-PC.git
cd AI-PC
claude   # or any other AI coding agent that can read/write files
```

Then just say what you want, in plain language — the same way you'd talk to
any AI coding agent. There's nothing to configure first.

The agent should read [`AGENTS.md`](../AGENTS.md) at the start of a session
(Claude Code does this automatically via `CLAUDE.md`, which points to it).
That's what tells it where things go — you don't need to specify a category
yourself.

## What actually happens to a prompt

1. You describe a task.
2. The agent matches it to one of the seven domains in
   [`docs/taxonomy.md`](taxonomy.md).
3. It creates a subdirectory under that domain (or reuses one it created
   earlier for the same project) and does the work there.
4. If the task changed something about the machine itself rather than
   producing a file, it leaves a short log of what changed and why — see
   [`examples/fedora-kde-desktop-setup/CHANGES.md`](../examples/fedora-kde-desktop-setup/CHANGES.md)
   for what that looks like.

## Example prompts, by domain

| You say | Lands in |
|---|---|
| "Build me a CLI that renames files by date" | `categories/development/` |
| "Design a logo for a coffee shop" | `categories/design-art/` |
| "My touchpad scrolls backwards, fix it" | `categories/system-administration/` |
| "Compare Postgres and SQLite for a small app" | `categories/research-analysis/` |
| "Write a tutorial on Git branching" | `categories/writing-education/` |
| "Help me budget a home renovation" | `categories/business-management/` |
| "Design a 3D-printable phone stand" | `categories/engineering/` |

## Starting fresh vs. forking this one

This repository already has one real case study in `examples/` from the
machine it was built on. If you want a clean slate with no example content,
delete `examples/fedora-kde-desktop-setup/` after cloning — nothing else
depends on it.
