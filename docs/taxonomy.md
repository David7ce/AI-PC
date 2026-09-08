# Taxonomy

AI+PC organizes work by **domain**, not by tool or project. Each domain is a
directory under [`categories/`](../categories); each has its own README
describing what an agent working there is expected to be able to do.

The domains are adapted from the **O\*NET-SOC major groups** — the U.S.
Department of Labor's standard occupational classification
([onetonline.org](https://www.onetonline.org/find/family)). O\*NET was picked
over a computing-only scheme like the ACM Computing Classification System
because the goal here is breadth across *everything a personal computer gets
used for* (including design, writing, and admin work), not just software
topics. Labels below are reworded for agent work; the SOC group is kept
alongside each one so the mapping stays checkable against the source standard.

| AI+PC category | O\*NET-SOC major group(s) | Covers |
|---|---|---|
| [`development`](../categories/development/) | 15-0000 Computer and Mathematical Occupations | Writing, testing, and shipping software; data/ML work; scripting and automation |
| [`design-art`](../categories/design-art/) | 27-0000 Arts, Design, Entertainment, Sports, and Media Occupations | Visual design, UI/UX, illustration, audio/video, generative art |
| [`system-administration`](../categories/system-administration/) | 43-0000 Office and Administrative Support; 49-0000 Installation, Maintenance, and Repair | OS configuration, device/driver setup, backups, networking, maintenance |
| [`research-analysis`](../categories/research-analysis/) | 19-0000 Life, Physical, and Social Science Occupations | Investigating a question, comparing options, summarizing sources, data analysis |
| [`writing-education`](../categories/writing-education/) | 25-0000 Education, Training, and Library Occupations | Documentation, tutorials, explanations, structured learning material |
| [`business-management`](../categories/business-management/) | 11-0000 Management Occupations; 13-0000 Business and Financial Operations Occupations | Planning, budgeting, scheduling, personal/organizational admin |
| [`engineering`](../categories/engineering/) | 17-0000 Architecture and Engineering Occupations | CAD, hardware-adjacent work, embedded systems, physical/technical design |

Security work is deliberately **not** its own top-level category: it cuts
across development (secure coding), system-administration (hardening,
patching), and research (threat analysis), and lives as a concern inside
each of those rather than a silo.

## How a request finds its category

When you prompt an agent inside AI+PC, the agent should:

1. Match the request to the closest category above.
2. Work inside `categories/<name>/`, in a subdirectory it creates for the
   specific task if there isn't already an obviously matching one.
3. If a request genuinely spans categories (e.g. "build me a tool AND design
   its logo"), split the work: code under `development/`, the logo under
   `design-art/`, cross-link the two READMEs.
4. If nothing fits, that's a signal the taxonomy needs an 8th category —
   propose one rather than force a bad fit, and add it to this table.

See [`AGENTS.md`](../AGENTS.md) at the repo root for the full operating
instructions any agent working in this repo should follow.
