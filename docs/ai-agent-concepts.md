# AI Agent Concepts

Generic concepts shared by any AI coding agent — Claude Code, Cursor,
GitHub Copilot, Aider, and others. Kept intentionally brief: this is
background for [`claude-code-reference.md`](claude-code-reference.md),
not a deep reference in its own right. For the export-to-PDF workflow
and how these two files relate, see that file's intro.

## What makes something an "agent," not just a chatbot

A chatbot answers in text. An **agent** additionally has:

1. **Tools** — the ability to actually do things: read/write files, run
   shell commands, browse the web, call APIs. Usually called *tool use*
   or *function calling*.
2. **A loop** — it observes the result of each tool call and decides the
   next step itself, repeating until the task looks done: prompt →
   reasoning → tool call → observe → repeat. This is the *agentic loop*.
3. **Autonomy within limits** — many small decisions made on its own
   (which file to open, what command to run) without asking each time,
   while still involving you for consequential or irreversible ones.

**Example:** ask a plain chatbot "why does this test fail?" and it can
only guess from what you paste in. Ask an agent the same thing and it
opens the test file itself, runs it, reads the actual error, greps for
the failing assertion's source, and tells you the real cause — several
tool calls chained without you doing the legwork.

## The context window

Everything an agent "knows" right now lives in a single **context
window** — a fixed-size buffer of text. It is not persistent memory; when
it fills up, something has to give. Agents handle this with
**compaction** (summarizing older parts of the conversation to free
space) and various **memory** mechanisms that persist facts *outside* the
window so they can be reloaded later instead of kept in it forever. This
is why long sessions can "forget" something from much earlier, and why
well-designed agents write important facts to a file rather than relying
on the conversation staying in context indefinitely.

## Permission models

Every serious agent tool has some version of:

- **Ask every time** — safest, slowest. Good for unfamiliar codebases.
- **Auto-approve routine actions, ask for risky ones** — the practical
  default once you trust the tool.
- **Full autonomy** — no prompts at all, including for destructive
  actions. Fast, but you're trusting the agent completely.

None of these is "more correct" — it's a real trade-off between speed and
safety that should match how much you trust the tool *and* how reversible
the current task is.

## Sessions and persistence

A "session" is one continuous conversation with the agent. Most agents let
you **resume** a previous session rather than starting fresh, since
re-explaining context every time is wasteful. *How* resumption works
(replay the whole history? summarize it? load a saved state file?) varies
a lot between tools.

## Sub-agents / multi-agent delegation

More advanced agents let the main agent spawn **sub-agents** — separate
instances with their own context window, given a narrow task, reporting
back a result. This keeps the main conversation's context clean (the
sub-agent's exploration doesn't pollute it) and can run work in parallel.
It's a delegation pattern, not a different kind of intelligence.

**Example:** "research the three best approaches to X and summarize
trade-offs" is a good sub-agent task — the research transcript (many
searches, many pages read) would otherwise fill the main context with
detail you only need distilled.

## MCP: a shared standard for tool access

The **Model Context Protocol (MCP)** is an open standard (not tied to any
one agent) for connecting an agent to external systems — a database, an
issue tracker, a design tool — through a common interface, instead of
every agent needing its own bespoke integration per service. If you see
"MCP server" mentioned, it means "a small program that exposes some
tool/data source to any MCP-compatible agent."

## Prompting an agent well

Same principles as prompting any LLM, with an agent-specific twist: be
specific about the *outcome* you want and any constraints, but you
generally don't need to specify *how* — that's what the agentic loop is
for. Give it enough context to make good autonomous decisions (repo
conventions, what "done" looks like) rather than narrating every step.
Correct it when it does something wrong; a good agent remembers the
correction going forward instead of you repeating yourself every session.

## Other agents worth knowing exist

Not a recommendation list — just names you'll encounter: **Cursor** and
**GitHub Copilot** (IDE-integrated), **Aider** (terminal, git-centric),
**Windsurf**, **Cline**. Most read a similar
[`AGENTS.md`](https://agents.md/)-style convention for repo instructions —
worth knowing about even here, since Claude Code specifically reads
`CLAUDE.md`, not `AGENTS.md` (see the reference file for how this repo
bridges the two).
