# Pull requests

A good PR lets a reviewer understand the change and decide whether to merge it in a few minutes, without reading the issue or asking you.

GitHub fills in [the template](../.github/pull_request_template.md) when you open a PR. Before you ask for review, check the PR against the [Definition of Done](definition-of-done.md).

## Keep it focused

- One PR closes one issue. Link it with `Closes #<issue>` so GitHub closes the issue on merge.
- Keep refactors, formatting changes and dependency bumps out of feature PRs. Open a separate PR for them.
- If the diff passes about 400 changed lines, not counting `db/schema.rb`, lockfiles or generated files, try to split it.
- Open a draft PR for early feedback. Mark it ready for review once `bin/ci` passes.

## Title

- Use the commit subject format: `type(scope): Capitalized subject`, for example `feat(tickets): Flag overdue High tickets`.
- Say what the change does, not how it does it. Keep it under 72 characters.

## Description

Write for a reviewer who has not read the issue. Fill in every section of the template, and use the terms from `GLOSSARY.md` and [requirements.md](requirements.md): ticket, customer, agent, severity, status.

| Section | Write | Skip |
| --- | --- | --- |
| Summary | What the PR does, in one to three sentences, plus `Closes #<issue>` | Background the issue already covers |
| What Changed | The key changes as bullets grouped by area. For structural changes, use a small file tree or diff sketch. | Every file. GitHub already shows the diff. |
| Why | The problem it solves, and why you chose this approach if a reviewer would ask | How the code works line by line |
| Test Plan | Commands a reviewer can copy, and manual steps with the role and expected result. Paste the output, or before/after screenshots for UI changes. | "Tested locally" without saying what you ran |
| Risks / Notes | What could break or be hard to undo. Write "None." when there is nothing. | Leaving the section empty |

### Test Plan

Evidence beats claims. In order of preference:

1. Before/after screenshots for UI changes.
2. A test that failed before the change and passes after it. Name the test.
3. Command output, such as `bin/rails test test/models/ticket_test.rb`.
4. Manual steps, for example: "Sign in as a customer, create an Urgent ticket, wait 15 minutes: the ticket shows Overdue."

### Risks / Notes

Call out anything a reviewer would want to know before merging:

- **Hard to undo:** migrations that drop or rewrite data, removed columns, sent emails or notifications. Say how to roll back, or that you can't.
- **Breaking changes:** renamed routes, params or broadcast channels.
- **Setup changes:** new environment variables, secrets (`config/deploy.yml` `env.secret`), gems or npm packages.
- **Access control:** anything that changes what a customer or agent can see or do.
- **Limits:** known gaps or follow-up issues.
- **Definition of Done:** each applicable item you did not check, and why.

## What to leave out

- The full diff, the commit log, or long stack traces. Link to them or quote the relevant lines.
- Vague text like "misc fixes" or "see code".
- Secrets, tokens, or real customer or employee data in text, logs or screenshots.

## Make review easy

- Read your own diff on GitHub before you request review.
- Comment on the lines where you want the reviewer to look closely.
- Reply to every review comment. Push fixes as new commits so the reviewer can see what changed since their last review.
- If the scope changes, update the description too.
