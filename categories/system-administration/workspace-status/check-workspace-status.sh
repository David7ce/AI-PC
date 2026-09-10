#!/usr/bin/env bash
# Live snapshot of every git repo under ~/Workspaces: branch, working-tree
# state, sync with origin, last commit, and a pointer to the repo's own
# roadmap/TODO file if it has one.
#
# Deliberately does NOT parse or summarize roadmap content — every project
# owns its roadmap's format and content; this only says where it is and
# when it last changed, so "what's pending in X" always means opening X's
# own file, never a stale copy of it.
#
# Usage: ./check-workspace-status.sh [workspaces-dir]
set -euo pipefail

WORKSPACES="${1:-$HOME/Workspaces}"

for dir in "$WORKSPACES"/*/; do
    name=$(basename "$dir")
    [ -d "$dir/.git" ] || continue
    cd "$dir"

    branch=$(git branch --show-current 2>/dev/null || echo "(detached)")
    dirty=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    ahead_behind=""
    if git rev-parse --verify -q "origin/$branch" >/dev/null; then
        read -r behind ahead <<< "$(git rev-list --left-right --count "origin/$branch...$branch" 2>/dev/null)"
        [ "$ahead" != "0" ] && ahead_behind+=" ahead $ahead"
        [ "$behind" != "0" ] && ahead_behind+=" behind $behind"
    else
        ahead_behind=" (no origin/$branch)"
    fi
    last_commit=$(git log -1 --format="%h %cr: %s" 2>/dev/null || echo "(no commits)")

    roadmap=$(find "$dir" -maxdepth 2 \
        \( -iname "roadmap*.md" -o -iname "todo*.md" -o -iname "tasks*.md" \) \
        -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | head -1)

    echo "=== $name ($branch) ==="
    if [ "$dirty" = "0" ]; then
        echo "  clean, in sync${ahead_behind:+ —$ahead_behind}"
    else
        echo "  $dirty uncommitted change(s)${ahead_behind:+ —$ahead_behind}"
    fi
    echo "  last commit: $last_commit"
    if [ -n "$roadmap" ]; then
        rel="${roadmap#"$dir"}"
        modified=$(date -r "$roadmap" "+%Y-%m-%d" 2>/dev/null || echo "?")
        echo "  roadmap: $rel (last touched $modified)"
    fi
    echo
done
