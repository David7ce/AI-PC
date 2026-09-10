#!/usr/bin/env bash
# Install a Linux AppImage from a GitHub repo's releases, verified and
# desktop-integrated, without building from source or needing sudo.
#
# Usage: ./install-github-appimage.sh owner/repo [tag]
#   owner/repo   e.g. MediaHub-Org/PlayTorrioMov
#   tag          optional, e.g. v1.3.0 — defaults to the latest non-prerelease
#
# Requires: gh (authenticated), jq, curl, flatpak. Installs Gear Lever
# (it.mijorus.gearlever, via Flathub, --user scope) on first run if it's
# not already present — that's what does the actual desktop-menu
# integration and can later check the same repo for updates.
set -euo pipefail

REPO="${1:?Usage: $0 owner/repo [tag]}"
TAG="${2:-}"

if ! flatpak list --user 2>/dev/null | grep -q it.mijorus.gearlever; then
    echo "==> Gear Lever not found, installing it first (Flathub, --user, no sudo)"
    flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install --user -y flathub it.mijorus.gearlever
fi

echo "==> Looking up release for $REPO${TAG:+ @ $TAG}"
if [ -n "$TAG" ]; then
    RELEASE_JSON=$(gh api "repos/$REPO/releases/tags/$TAG")
else
    RELEASE_JSON=$(gh api "repos/$REPO/releases" --jq '[.[] | select(.prerelease==false)][0]')
fi

ASSET_URL=$(echo "$RELEASE_JSON" | jq -r '.assets[] | select(.name | test("\\.AppImage$")) | .browser_download_url' | head -1)
SUMS_URL=$(echo "$RELEASE_JSON" | jq -r '.assets[] | select(.name | test("SHA256SUMS")) | .browser_download_url' | head -1)

if [ -z "$ASSET_URL" ] || [ "$ASSET_URL" = "null" ]; then
    echo "No .AppImage asset found in that release — nothing to install." >&2
    exit 1
fi
ASSET_NAME=$(basename "$ASSET_URL")

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT
cd "$WORKDIR"

echo "==> Downloading $ASSET_NAME"
curl -sSL -o "$ASSET_NAME" "$ASSET_URL"

if [ -n "$SUMS_URL" ] && [ "$SUMS_URL" != "null" ]; then
    echo "==> Verifying checksum"
    curl -sSL -o SHA256SUMS "$SUMS_URL"
    grep "$ASSET_NAME" SHA256SUMS | sha256sum -c --ignore-missing -
else
    echo "No SHA256SUMS published for this release — skipping verification."
fi

chmod +x "$ASSET_NAME"

echo "==> Integrating into the desktop via Gear Lever"
echo y | flatpak run it.mijorus.gearlever --integrate "$WORKDIR/$ASSET_NAME"

echo
echo "Done — find it in your application launcher."
