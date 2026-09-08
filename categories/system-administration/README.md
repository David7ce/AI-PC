# System Administration

O\*NET-SOC 43-0000 — Office and Administrative Support Occupations;
49-0000 — Installation, Maintenance, and Repair Occupations.

Configuring the operating system, hardware, and drivers you're actually
running on; backups; networking; package/dependency maintenance; anything
where the "deliverable" is a change to the machine's own state rather than
a file you hand someone.

**Typical requests:** set up a peripheral, fix a driver, configure a
service, script a backup, diagnose a networking issue, tune a desktop
environment.

**Convention:** work here is inherently platform-specific (Linux/KDE,
macOS, Windows all differ), so name subdirectories by what they're for and
note the platform explicitly in each README's first line, the way
[`../../examples/fedora-kde-desktop-setup/`](../../examples/fedora-kde-desktop-setup/)
does. Log *what changed on the real machine and why* — not just the end
state — since that's what makes this category trustworthy to revisit later
or hand to a different agent.

See [`examples/fedora-kde-desktop-setup/`](../../examples/fedora-kde-desktop-setup/)
for a full worked example of this category in practice.
