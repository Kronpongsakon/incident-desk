# Pull Request Guidelines

A PR is written for the reviewer. They should understand what changed, why, and how to check it in a couple of minutes, without reading the diff first.

GitHub fills in `.github/pull_request_template.md` when you open a PR. This page explains how to fill it in well. For what must be true before merge, see `docs/definition-of-done.md`.

## Keep it focused

- One PR, one purpose: one issue, one bug, or one refactor. If the summary needs "and", consider splitting it.
- Aim for a diff a reviewer can read in one sitting (roughly under 400 changed lines, excluding generated files like `db/schema.rb`).
- Don't mix refactors or formatting with behavior changes. Put them in their own PR or at least their own commit.
- No drive-by changes. If you spot something unrelated, open an issue for it.
- Open a draft PR early when you want feedback on direction rather than details.

## Title

Use the same format as commit messages: `type(scope): Summary`.

- `type` is one of `feat`, `fix`, `refactor`, `test`, `docs`, `chore`.
- `scope` is the area you touched, for example `auth`, `tickets`, `comments`.
- The summary starts with a capital letter, uses the imperative mood, and says what the PR does, not how.

| Good | Not helpful |
| --- | --- |
| `feat(tickets): Let agents change ticket status` | `Ticket stuff` |
| `fix(auth): Redirect signed-out users to sign-in` | `Fix bug` |
| `refactor(tickets): Scope customer queries to Current.user` | `WIP changes from review` |

## Description

Fill in every section of the template. Write short sentences and bullets, not paragraphs.

**Summary.** One or two sentences a reviewer could repeat to someone else. Add `Closes #<issue>` so the issue closes on merge.

**What Changed.** The meaningful changes, one bullet each. Name the behavior, not every file: "Customers can only see their own tickets" beats "Updated tickets_controller.rb". Leave out renames, formatting, and anything the diff already makes obvious.

**Why.** The problem or user story behind the change. Link the issue or `docs/user-stories.md` instead of copying it. If you picked one approach over an obvious alternative, say why in one line.

**Test Plan.** What a reviewer runs or clicks to see it working.

- List exact commands, such as `bin/ci` or `bin/rails test test/controllers/sessions_controller_test.rb`.
- For UI or real-time behavior, give numbered steps with the expected result: which user to sign in as, what to click, what should appear.
- Add a screenshot or short recording for visible UI changes.
- Say what you did **not** test and why.

**Risks / Notes.** Anything that could surprise a reviewer or break after merge:

- Breaking changes, migrations (and whether they roll back), and data changes.
- New gems, npm packages, or environment variables. Say why a dependency is needed.
- Security-relevant changes: authentication, access control, new unauthenticated endpoints.
- Known limitations and planned follow-ups, with issue links.

If there are none, write "None." An empty section makes the reviewer wonder whether you forgot.

## Leave out

- Long implementation narratives. The diff shows how; the description says what and why.
- Pasted logs or full test output. Quote the one line that matters.
- Secrets, credentials, real customer data, or internal-only information, in the description, screenshots, or the diff. If a credential is ever committed, purge it from the commit history and rotate it before merge.

## Make review easy

- Review your own diff on GitHub before requesting review. Remove debug code and stray files.
- Run `bin/ci` and make sure it passes. This repo has no GitHub Actions workflow, so `bin/ci` is the gate.
- Leave PR comments on lines that need context, such as a tricky query or a deliberate trade-off.
- Respond to every review comment, either with a change or a short reason. Push fixes as new commits during review so reviewers can see what changed.
- Update the description if the scope changes during review.
