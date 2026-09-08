#!/usr/bin/env bash
# Disable X11-style "primary selection" on KDE Plasma (Wayland).
#
# Primary selection is the mechanism behind two behaviors some people find
# surprising rather than useful:
#   - selecting text with a click-drag or double-click silently copies it
#     into a separate clipboard, with no explicit Ctrl+C
#   - middle-clicking (or, on many touchpads, a 3-finger tap) pastes
#     whatever was last selected ANYWHERE on screen, unrelated to what you
#     last explicitly copied
#
# This does not touch the normal clipboard (Ctrl+C / Ctrl+V) at all — that
# is a separate mechanism (CLIPBOARD selection) and keeps working exactly
# as before.
#
# Platform: KDE Plasma 6+ on Wayland. Confirmed via KWin's own config
# schema (src/kwin.kcfg, [Wayland] group, EnablePrimarySelection key,
# default true). No sudo required; user-scoped config only.
set -euo pipefail

kwriteconfig6 --file kwinrc --group "Wayland" --key "EnablePrimarySelection" false

if busctl --user call org.kde.KWin /KWin org.kde.KWin reconfigure >/dev/null 2>&1; then
    echo "Applied live — no logout needed."
else
    echo "Config written, but couldn't reach a running KWin session over D-Bus."
    echo "Log out and back in for it to take effect."
fi
