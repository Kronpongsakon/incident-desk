# Docs index for AI agents

Start here. Paths are relative to this folder. Files marked *created later* do not exist yet: skip them until they do.

## Task → files to read

| Task | Read |
| --- | --- |
| Understand the product | [requirements.md](requirements.md), [user-stories.md](user-stories.md) |
| Build or change a screen | [user-stories.md](user-stories.md), the matching mockup in [design/](design/), [design/styles.css](design/styles.css) |
| Learn domain terms | `GLOSSARY.md` (*created later*), [agents/domain.md](agents/domain.md) |
| Record or check an architecture decision | `docs/adr/` (*created later*), [agents/domain.md](agents/domain.md) |
| Create, read, or close issues | [agents/issue-tracker.md](agents/issue-tracker.md) |
| Break a spec into tickets | [to-tickets skill](../.agents/skills/to-tickets/SKILL.md), [agents/issue-tracker.md](agents/issue-tracker.md) |
| Implement a ticket | [implement skill](../.agents/skills/implement/SKILL.md), [tdd skill](../.agents/skills/tdd/SKILL.md), [requirements.md](requirements.md) |
| Open a pull request | [pull-requests.md](pull-requests.md), [PR template](../.github/pull_request_template.md), [definition-of-done.md](definition-of-done.md) |
| Review a change | [code-review skill](../.agents/skills/code-review/SKILL.md), [requirements.md](requirements.md), [definition-of-done.md](definition-of-done.md) |
| Decide if a ticket is done | [definition-of-done.md](definition-of-done.md) |
| Follow project coding rules | [.claude/rules/](../.claude/rules/) |

## How to read the rules

`.claude/rules/` holds one Markdown file per rule topic.

1. List the folder (`ls .claude/rules`). If it is missing, there are no extra rules: continue.
2. Read each file's frontmatter. A file with a `paths:` glob list applies only to files that match those globs. A file without `paths:` applies everywhere.
3. Before you edit a file, read every rule that applies to it. Claude Code loads these files on its own; other agents must read them by hand.
4. A rule overrides a general habit. If a rule conflicts with `AGENTS.md`, `AGENTS.md` wins: point out the conflict to the user.

## How to read the Definition of Done

[definition-of-done.md](definition-of-done.md) is the checklist for finishing a ticket.

1. Read it before you start a ticket, so you plan the tests and docs it asks for.
2. Use only the items that apply to the change. A docs-only change skips Functionality and Access Control, for example.
3. Items without a label are required. Items marked *(optional)* are guesses that no repo rule backs yet: follow them unless the ticket says otherwise.
4. Check items by running the command they name, such as `bin/ci`. Do not tick an item from memory.
5. Before you call a ticket done, list in the PR description any applicable item that is not checked, and say why.

## Documents

| File | What it holds |
| --- | --- |
| [requirements.md](requirements.md) | Roles, ticket fields, live updates, escalation job, out of scope |
| [user-stories.md](user-stories.md) | Six user stories with acceptance criteria |
| [definition-of-done.md](definition-of-done.md) | Checklist a ticket must pass before it is done |
| [pull-requests.md](pull-requests.md) | How to write a PR title and description |
| [agents/domain.md](agents/domain.md) | How agents use the glossary and ADRs |
| [agents/issue-tracker.md](agents/issue-tracker.md) | GitHub Issues workflow with `gh` |

## UI mockups

Static HTML in [design/](design/). Open in a browser; all share [design/styles.css](design/styles.css).

| File | Screen | Role |
| --- | --- | --- |
| [design/index.html](design/index.html) | Sign in | Both |
| [design/my-tickets.html](design/my-tickets.html) | My tickets | Customer |
| [design/new-ticket.html](design/new-ticket.html) | New ticket form | Customer |
| [design/customer-ticket.html](design/customer-ticket.html) | Ticket detail and comments | Customer |
| [design/agent-tickets.html](design/agent-tickets.html) | All tickets with filters | Agent |
| [design/agent-ticket.html](design/agent-ticket.html) | Ticket detail with status and assignee | Agent |

## Skills

In `.agents/skills/` (linked into `.claude/skills/`).

| Skill | Use for |
| --- | --- |
| [code-review](../.agents/skills/code-review/SKILL.md) | Review changes against standards and spec |
| [codebase-design](../.agents/skills/codebase-design/SKILL.md) | Module interfaces and seams |
| [domain-modeling](../.agents/skills/domain-modeling/SKILL.md) | Glossary and ADRs |
| [implement](../.agents/skills/implement/SKILL.md) | Build from a spec or tickets (user-invoked) |
| [pr](../.agents/skills/pr/SKILL.md) | Write a PR body |
| [tdd](../.agents/skills/tdd/SKILL.md) | Test-first features and fixes |
| [to-tickets](../.agents/skills/to-tickets/SKILL.md) | Split a plan into tickets (user-invoked) |


