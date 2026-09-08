# AI+PC

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

> Repository name is `AI-PC` on GitHub — `+` isn't reliably safe in GitHub repo
> names, so it was swapped for a hyphen there. Referred to as AI+PC everywhere else.

A personal computer organized as a workspace for AI agents to grow into —
not a product, a pattern. You open a terminal here (or in any subdirectory)
and run an AI coding agent — Claude Code is the one this was built with, but
nothing about the structure is specific to it. You describe what you want.
The agent works, and places the result in the directory that matches what
kind of work it was. Over time, the directory itself becomes a structured,
navigable record of everything you've asked for — not a chat log, an actual
filesystem you or any other agent can pick back up later.

There's no backlog and no fixed scope. The only input is whatever you prompt
next.

## How it's organized

Work is sorted into seven domains, adapted from the **O\*NET-SOC** occupational
taxonomy (the U.S. Department of Labor's standard classification of what
work actually is) rather than invented from scratch — see
[`docs/taxonomy.md`](docs/taxonomy.md) for the full mapping and reasoning.

| Domain | Covers |
|---|---|
| [`development`](categories/development/) | Software: building, fixing, automating |
| [`design-art`](categories/design-art/) | Visual, audio, and generative work |
| [`system-administration`](categories/system-administration/) | Configuring the machine itself |
| [`research-analysis`](categories/research-analysis/) | Investigating and summarizing |
| [`writing-education`](categories/writing-education/) | Documentation and explanation |
| [`business-management`](categories/business-management/) | Planning, budgeting, tracking |
| [`engineering`](categories/engineering/) | Hardware and physical-world design |

## Getting started

See [`docs/getting-started.md`](docs/getting-started.md) for how to clone
this and start using it, with example prompts per domain.

## Platform

Plain files and folders plus Markdown — nothing here depends on a specific
OS. It's used identically on Linux, macOS, and Windows, and with any AI
agent that can read and write files in a directory.

## For agents

If you're an AI agent about to work in this repo, read
[`AGENTS.md`](AGENTS.md) — it's the actual operating instructions: where
things go, what a task's subdirectory should contain, and when to stop and
ask rather than guess.

## See it in action

[`examples/fedora-kde-desktop-setup/`](examples/fedora-kde-desktop-setup/) is
a real session's output — an agent configuring touchpad gestures and
desktop behavior on a live Fedora + KDE Plasma machine, with a full log of
what it changed and why.
