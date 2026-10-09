# Definition of Done

A ticket is done when every item below that applies to it is checked. Items marked *(optional)* are not backed by an existing rule or command in this repo yet. Follow them unless the ticket says otherwise.

Sources: [requirements.md](requirements.md), [user-stories.md](user-stories.md), [`config/ci.rb`](../config/ci.rb), [`config/deploy.yml`](../config/deploy.yml), [agents/issue-tracker.md](agents/issue-tracker.md), [agents/domain.md](agents/domain.md).

## Functionality

- [ ] Every acceptance criterion of the linked user story has a passing test or a written manual check in the PR description.
- [ ] Ticket validation rejects a title under 5 characters, a description under 10 characters, and a severity other than `Low`, `Medium`, `High`, `Urgent`.
- [ ] Ticket status accepts only `Open`, `In Progress`, `Resolved`, and a new ticket is saved as `Open`.
- [ ] Submitting the new-ticket form redirects to the ticket detail page.
- [ ] A wrong email or password shows exactly "Invalid email or password".
- [ ] When an agent changes a status, the badge on the customer's already open tab updates without a reload.
- [ ] A new comment appears at the bottom of the thread on every open tab without a reload, and the comment input is cleared after submit.
- [ ] Creating a `High` or `Urgent` ticket enqueues the escalation job.
- [ ] A `High` or `Urgent` ticket that is still `Open` and unassigned after 15 minutes is flagged Overdue and writes a notification log line.
- [ ] Every status change creates one audit event record.
- [ ] The change adds nothing from the out-of-scope list: no SMTP password reset, no attachments, no roles besides `customer` and `agent`, no WYSIWYG editor.

## Access Control

- [ ] Every page except sign-in and `/up` redirects a signed-out user to sign-in, and a test covers it.
- [ ] A test shows that a customer requesting another customer's ticket is refused and sees none of its data.
- [ ] A test shows that a customer cannot change a ticket's status or assignee: the request is refused and the record is unchanged.
- [ ] A test shows that an agent can view, assign and change the status of any ticket.
- [ ] A user's role cannot be set through any form or permitted params.

## Code Quality

- [ ] `bin/rubocop` passes.
- [ ] Names of models, columns and statuses match `GLOSSARY.md` once that file exists.
- [ ] *(optional)* Every new `rubocop:disable` has a comment explaining why.
- [ ] *(optional)* No commented-out code and no leftover `debugger` or `binding` calls (`git grep -nE "debugger|binding\.(irb|b)" app` prints nothing).

## Testing

- [ ] `bin/rails test` passes.
- [ ] `env RAILS_ENV=test bin/rails db:seed:replant` passes.
- [ ] Every new validation has a model test, and every new controller action has an integration test for both the customer and the agent role.
- [ ] *(optional)* The escalation job test uses time helpers (`travel 15.minutes`) to cover both sides of the threshold.
- [ ] *(optional)* `bin/rails test:system` passes. It is commented out in `config/ci.rb` until system tests exist.

## Security

- [ ] `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error` passes.
- [ ] `bin/bundler-audit` passes, and every entry in the ignore list of `config/bundler-audit.yml` has a comment explaining why it does not apply.
- [ ] `yarn audit` passes.
- [ ] The diff contains no passwords, tokens or keys. Secrets go in `config/credentials.yml.enc` or environment variables, and `git ls-files config/master.key` prints nothing.
- [ ] Passwords are stored only as a hash: no plaintext password column in `db/schema.rb`.
- [ ] User text (titles, descriptions, comments) is rendered escaped: `git grep -nE "html_safe|raw\(" app/views` shows no user content.

## Operations

- [ ] `bin/setup --skip-server` succeeds on a clean checkout.
- [ ] Every new migration is committed together with the updated `db/schema.rb`.
- [ ] Background work runs on Solid Queue and live updates on Solid Cable. The change adds no other queue or cable backend.
- [ ] `GET /up` returns 200 with the change running locally (`bin/dev`).
- [ ] Every new secret is listed under `env.secret` in `config/deploy.yml` and read in `.kamal/secrets`, never written there as a literal value.
- [ ] *(optional)* `bin/rails db:rollback` followed by `bin/rails db:migrate` succeeds for every new migration.
- [ ] *(optional)* The Overdue log line includes the ticket id, so it can be found with `bin/kamal logs`.
- [ ] *(optional)* `bin/kamal deploy` succeeds. `config/deploy.yml` still has placeholder server and registry values.

## Documentation

- [ ] Every new domain term has an entry in `GLOSSARY.md`, created via the `domain-modeling` skill.
- [ ] Every hard-to-reverse decision has an ADR in `docs/adr/`.
- [ ] Every new or changed file in `docs/` is listed in [README.md](README.md).
- [ ] *(optional)* A screen that differs on purpose from its mockup in `docs/design/` has its mockup updated in the same PR.
- [ ] *(optional)* `README.md` at the repo root lists any new setup step.

## Delivery

- [ ] The work has a GitHub issue in `BananaCoding/incident-desk` of type `Task` (or `Bug` or `Feature` when asked).
- [ ] `bin/ci` passes locally on the final commit.
- [ ] The PR targets `main`, and its description contains `Closes #<issue>`.
- [ ] Commit subjects follow the repo's existing format: `type(scope): Capitalized subject`, for example `docs(agents): Create issues with the Task issue type`.
- [ ] The issue is closed once the PR is merged.
- [ ] *(optional)* `gh signoff` sets a green commit status. It is commented out in `config/ci.rb` and needs `gh extension install basecamp/gh-signoff`.
