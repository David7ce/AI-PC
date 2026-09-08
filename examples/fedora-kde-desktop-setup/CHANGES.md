# Changes made on this machine — 2026-09-08

## Global Claude Code config

**`permissions.defaultMode` upgraded from `"auto"` to `"bypassPermissions"`.** Auto still asked before destructive/irreversible actions; bypass skips every prompt, everywhere, including those. Applied globally.

**Per-project `.claude/settings.local.json` added in every repo under `~/Workspaces/`** (`AI+PC`, `app-launcher`, `celular-automata-rust`, `PlayTorrioMov`, `universal-map-app`), each with `{"permissions": {"defaultMode": "bypassPermissions"}}`. Added to `.gitignore` in the 4 git repos (it's a personal setting, not team policy). This was requested because sessions already running in other terminals kept asking for permission after the global change — **the likely real cause is that Claude Code reads settings at session startup, so a `claude --resume` process started before the global edit won't pick up the new global setting until it's restarted.** The project-level files are a legitimate belt-and-suspenders addition either way, but if prompts persist in those other two terminals (`PlayTorrioMov`, `celular-automata-rust`), exit and restart the session there rather than looking for more config to change.

**`~/.claude/settings.json`** — added:
```json
"permissions": { "defaultMode": "auto" }
```
Claude Code now acts autonomously by default across every project (writes/edits without asking routine questions), still pausing for destructive or irreversible actions.

**`~/.claude/CLAUDE.md`** (new file) — global working-style instructions telling every session to proceed without clarifying questions except for genuine blockers (real decisions only you can make, missing info, destructive/hard-to-reverse actions).

## Touchpad / KDE Plasma

**Natural (touch-drag) scrolling — done, live:**
- Set live on the running session: `busctl --user set-property org.kde.KWin /org/kde/KWin/InputDevice/event8 org.kde.KWin.InputDevice naturalScroll b true`
- Persisted to `~/.config/kcminputrc` under `[Libinput][1267][5][Elan Touchpad]` → `NaturalScroll=true`, so it survives reboot.

**Second virtual desktop — done:**
- Created via `busctl --user call org.kde.KWin /VirtualDesktopManager org.kde.KWin.VirtualDesktopManager createDesktop us 1 "Escritorio 2"`. You only had one before, which made left/right desktop-switch gestures no-ops.

**3-finger swipe left/right (switch desktop) — already works natively.**
No daemon involved — this is Plasma's built-in KWin gesture, confirmed by finding no `libinput-gestures` binary anywhere on disk. Nothing to install for this part.

**`libinput-gestures` — installed and running.** User ran the `sudo` steps themselves (this session never had that access). Confirmed via `libinput-gestures-setup status`: installed, running as a desktop-autostart application, using the custom config, `d7` is in the `input` group. Covers swipe up (Overview), down (Show Desktop), and left/right (see the window-focus remap further down) — none of that needed a daemon-config edit to activate once installed, the config was already correct and waiting.

Still open: confirming with an actual physical swipe (not a D-Bus test, which bypasses libinput's gesture recognizer entirely) that all four directions fire correctly, and specifically that left/right's old native desktop-switch gesture doesn't fire *alongside* the new window-focus remap below. Tracked in this machine's local GTD `next-actions.md` (gitignored, not in this repo).
Once installed, swipe up/down start working immediately — the config needs no further edits.

**3-finger tap → open all apps — not achievable with this toolchain.**
`libinput-gestures` has no tap support (open, unresolved upstream requests: [#44](https://github.com/bulletmark/libinput-gestures/issues/44), [#240](https://github.com/bulletmark/libinput-gestures/issues/240)), and KDE's native tap settings are fixed to right/middle-click, not remappable to an action. Swipe-up will cover the same "show all apps" function once the daemon above is installed, so this was treated as covered rather than pursued separately.

**Two-finger scroll speed — done, live:**
- Was `ScrollFactor=1.5` (too fast for small finger movements). Set to `0.6`, live via `busctl --user set-property .../InputDevice/event8 ... scrollFactor d 0.6` and persisted to `kcminputrc`. Tell me if it needs further adjustment — any value works.

**3-finger tap pasting the clipboard (middle-click-paste) — confirmed unfixable at the source, mitigated instead.**
This is libinput's default tap-to-click mapping: 1 finger = left-click, 2 = right-click, 3 = middle-click, and middle-click pastes the X11 primary selection everywhere. Checked directly against upstream source — **neither libinput nor Konsole expose a way to disable this for a specific finger count**:
- libinput's only knob (`lmrTapButtonMap`) swaps which of 2/3 fingers gets middle vs right — it can't be turned off, and swapping would move the paste onto the far more frequently used 2-finger tap. Not done, deliberately.
- Konsole's `MiddleClickPasteMode` (confirmed via [Konsole's `Enumeration.h`](https://invent.kde.org/utilities/konsole/-/blob/master/src/Enumeration.h)) only has two values — `PasteFromX11Selection` (default) and `PasteFromClipboard` — there is no "disabled" option, unlike its `RightClickPasteMode` sibling which does have one.

Given no true "off" exists, applied the safer fallback: created `~/.local/share/konsole/Default.profile` with `MiddleClickPasteMode=1` (paste from clipboard) and set it as Konsole's default profile in `konsolerc`. Accidental 3-finger taps in a terminal now paste your last explicit `Ctrl+C` copy instead of whatever text was last merely highlighted anywhere on screen — much lower risk of pasting garbage or running a stray command, but not a full disable. Outside the terminal, 3-finger tap still pastes the primary selection (no fix exists for that).

**Top-left hot corner → Overview (open all windows) — done, live.**
Moving the cursor into the screen's top-left corner now opens Overview, the same effect swipe-up is already configured for. Confirmed the exact mechanism from KWin's own source ([`kwinscreenedgeeffectsettings.kcfg`](https://invent.kde.org/plasma/kwin/-/blob/master/src/kcms/screenedges/kwinscreenedgeeffectsettings.kcfg), [`globals.h`](https://invent.kde.org/plasma/kwin/-/blob/master/src/effect/globals.h) for the `ElectricBorder` enum where `ElectricTopLeft = 7`) — this is the identical write-then-reload sequence the Screen Edges settings panel itself performs:
```
kwriteconfig6 --file kwinrc --group "Effect-overview" --key "BorderActivate" "7"
busctl --user call org.kde.KWin /Effects org.kde.kwin.Effects reconfigureEffect s "overview"
```
So there are now three ways to reach the same "all windows" view: 3-finger swipe up (pending the `libinput-gestures` install), the top-left hot corner (works right now, no install needed), and Overview's own default keyboard shortcut. Swipe down and `Super+D` already point at the same `Show Desktop` shortcut — no separate change needed there, they were already the same action.

**3-finger swipe left/right remapped: desktop-switch → window focus — done, live.**
Changed on request: left/right no longer switch virtual desktops, they now cycle window focus like Alt+Tab, including unminimizing a hidden window if that's the one selected. Uses KWin's existing TabBox shortcuts, confirmed via `kglobalaccel`'s own shortcut list and tested live (each call is a clean single-shot cycle — no overlay gets left stuck open, unlike holding real Alt+Tab):
```
gesture swipe left 3  busctl --user call org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component invokeShortcut s "Walk Through Windows (Reverse)"
gesture swipe right 3 busctl --user call org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component invokeShortcut s "Walk Through Windows"
```
Updated in both `~/.config/libinput-gestures.conf` (live) and `libinput-gestures.conf` in this directory (reference copy) — up/down (Overview / Show Desktop) are unchanged. Note: `touchpad-gestures.html`, the published Artifact guide, still describes the old desktop-switch behavior for left/right and hasn't been regenerated to match.

## Files in this directory

| File | What it is |
|---|---|
| `touchpad-gestures.html` | Full gesture setup guide (also published as an Artifact) |
| `claude-code-guide.html` | Claude Code reference guide (also published as an Artifact) |
| `libinput-gestures.conf` | Ready-to-use gesture config — copy to `~/.config/libinput-gestures.conf` (already there; this is a copy for reference) |
| `CHANGES.md` | This file |
