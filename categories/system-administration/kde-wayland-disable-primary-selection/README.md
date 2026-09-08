# Disable primary selection (KDE Plasma, Wayland)

**Platform:** KDE Plasma 6+, Wayland session. No sudo required.

Stops two related behaviors that read as accidental rather than intentional
on most systems:

- **Click/select auto-copy** — selecting text with a drag or a double-click
  copies it into a clipboard buffer with no explicit `Ctrl+C`.
- **Middle-click / 3-finger-tap paste** — pastes whatever was last selected
  *anywhere on screen*, which is rarely what you meant to paste.

Both come from X11's "primary selection" concept, which Wayland compositors
including KWin still support for compatibility. Turning it off leaves the
normal clipboard (`Ctrl+C` / `Ctrl+V`) completely untouched — that's a
separate mechanism.

## Run it

```bash
./disable-primary-selection.sh
```

Writes `EnablePrimarySelection=false` under `[Wayland]` in `~/.config/kwinrc`
and reloads KWin live over D-Bus — confirmed against
[KWin's own config schema](https://invent.kde.org/plasma/kwin/-/blob/master/src/kwin.kcfg)
rather than assumed. No logout needed if a KWin session is already running.

## Revert

```bash
kwriteconfig6 --file kwinrc --group "Wayland" --key "EnablePrimarySelection" true
busctl --user call org.kde.KWin /KWin org.kde.KWin reconfigure
```

## Related

This was the more thorough fix for the same problem partially mitigated in
[`../../../examples/fedora-kde-desktop-setup/`](../../../examples/fedora-kde-desktop-setup/)
(which only redirected Konsole's middle-click paste source, since at the
time the system-wide toggle hadn't been found). With this applied, that
Konsole-specific workaround is no longer necessary but is left in place —
it's harmless with primary selection off.
