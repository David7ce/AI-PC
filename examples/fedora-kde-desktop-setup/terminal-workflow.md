# VS Code terminal state — 2026-09-08 18:22

Three integrated terminals open in this VS Code window, each running its own
active `claude --resume` session in a different project directory.

## Terminal 1 (pts/1) — `~/Workspaces/PlayTorrioMov`
- Flutter app (torrent/movie player).
- Git: on `master`, tracking `origin/master`.
- Uncommitted changes in: `analysis_options.yaml`, `android/app/src/main/AndroidManifest.xml`, `ios/Podfile`, `ios/Runner.xcodeproj/project.pbxproj`, `ios/Runner/Info.plist`, `lib/main.dart`, `lib/pages/player/player_screen.dart`, `lib/widgets/player/player_top_bar.dart`, `lib/widgets/player/player_transport.dart`.
- Reads as active work on the player screen/transport UI.

## Terminal 2 (pts/2) — `~/Workspaces/celular-automata-rust`
- Rust project (cellular automata), has `README.md` and a `ROADMAP.md`.
- Git: on `master`, 1 commit ahead of `origin/master`, working tree otherwise clean.

## Terminal 3 (pts/3) — `~/Workspaces/AI+PC`
- This session — Fedora/KDE Plasma touchpad gesture setup and global Claude Code config changes.
- See [`CHANGES.md`](./CHANGES.md) in this same directory for the full list of what was changed (touchpad gestures, scroll speed/direction, screen edges, Konsole paste behavior, global permission settings).

## How this was captured
Read directly off the running system rather than guessed: each terminal's shell PID, cwd, and child process were found via `ps`/`/proc/<pid>/cwd` (three `bash` processes under VS Code's integrated-terminal shell integration script, each with a `claude --resume` child), then each project's git state was checked with `git status --short --branch`.
