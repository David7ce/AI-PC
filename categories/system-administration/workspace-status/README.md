# Workspace status

**Platform:** any Linux/macOS shell with `git`, `bash`, `find`, `date`.

A live snapshot of every git repo under `~/Workspaces`: branch, working-tree
state, sync with `origin`, last commit, and — if the repo has one — a
pointer to its own roadmap/TODO file.

## Why it doesn't summarize roadmap content

Each project (`PlayTorrioMov`, `celular-automata-rust`, `app-launcher`,
`universal-map-app`) maintains its own `ROADMAP.md` in its own format —
tables, prose, checklists, whatever fits that project. This script
deliberately only reports the file's **path and last-modified date**, never
its content. "What's pending in PlayTorrioMov" always means opening
`PlayTorrioMov/docs/ROADMAP.md` itself — a parsed/copied summary here would
drift out of sync with the real thing and become actively misleading.

## Run it

```bash
./check-workspace-status.sh              # defaults to ~/Workspaces
./check-workspace-status.sh /some/other/dir
```

## Used by

[`../../../gtd/workspace-projects.md`](../../../gtd/workspace-projects.md)
(gitignored, personal) keeps a snapshot from this script for quick
reference — regenerate it by re-running the script rather than trusting an
old copy, since git and roadmap state both change constantly.
