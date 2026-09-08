#!/usr/bin/env bash
# One-shot installer for 3-finger touchpad gestures on this machine
# (Fedora + KDE Plasma 6, Wayland). Run this yourself in a real terminal —
# it needs your sudo password interactively, so don't pipe/redirect it
# through anything that can't prompt you for it.
set -euo pipefail

echo "==> Installing libinput-gestures"
if [ -d "$HOME/libinput-gestures" ]; then
    echo "    Already cloned at ~/libinput-gestures, pulling latest instead."
    git -C "$HOME/libinput-gestures" pull
else
    git clone https://github.com/bulletmark/libinput-gestures.git "$HOME/libinput-gestures"
fi
sudo make -C "$HOME/libinput-gestures" install

echo "==> Adding $USER to the 'input' group (lets the daemon read the touchpad)"
sudo usermod -aG input "$USER"

echo "==> Starting the daemon now, under the new group, without needing a full logout"
sg input -c "libinput-gestures-setup start"

echo "==> Registering it to autostart on every future login"
sg input -c "libinput-gestures-setup autostart"

echo
echo "Done. Try a 3-finger swipe up/down/left/right now."
echo "Note: this session's shells still won't show 'input' in \`groups\` until"
echo "you actually log out and back in — that's expected and harmless; the"
echo "autostart entry will pick up the group correctly on your next real login."
