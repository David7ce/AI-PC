# Install a GitHub-release AppImage (no sudo, no build)

**Platform:** Any Linux desktop with Flatpak available (Fedora ships it by
default). Uses only `--user`-scoped Flatpak installs — no `sudo` anywhere.

## Why this method

Fedora's install-method hierarchy, best to last resort:

1. `dnf` (Fedora repos) — native, auto-updates with the system
2. `dnf` + RPM Fusion — for codecs/media tools Fedora can't ship
3. **Flatpak (Flathub)** — sandboxed, cross-desktop, independent updates
4. COPR — community-maintained real RPMs
5. **AppImage** — portable pre-built binary, for when nothing above publishes one
6. Raw tarball/binary — last resort, no integration, no updates

This script handles case 5: a project that only publishes a GitHub-release
AppImage for Linux. It doesn't replace `dnf`/Flatpak/COPR when those are
actually available — check those first for anything you're installing.

## What it does

1. Installs [Gear Lever](https://gearlever.mijorus.it) (`it.mijorus.gearlever`)
   from Flathub if it isn't already present — this is what gives the
   AppImage a real desktop-menu entry and lets it check the same GitHub repo
   for updates later, instead of it being a loose executable you have to
   remember to re-download.
2. Looks up the latest **non-prerelease** release for a given `owner/repo`
   (or a specific tag, if you pass one), finds its `.AppImage` asset.
3. Downloads it, verifies it against the release's `SHA256SUMS` file if one
   is published, and integrates it via Gear Lever's CLI.

## Run it

```bash
./install-github-appimage.sh owner/repo [tag]

# Example — what actually installed PlayTorrioMov v1.3.0 on this machine:
./install-github-appimage.sh MediaHub-Org/PlayTorrioMov v1.3.0
```

Requires `gh` (authenticated), `jq`, `curl`, and `flatpak` — all standard on
a Fedora + `gh`-CLI setup already.

## Limitations

- Only handles the `.AppImage` asset — if a release publishes multiple
  Linux variants (e.g. separate x86_64/aarch64 AppImages), it grabs the
  first match. Pin a `tag` and check the release's asset list first if
  that matters.
- If a release publishes no `SHA256SUMS` file, the script says so and
  skips verification rather than failing — verify some other way if that
  matters to you for a given app.
