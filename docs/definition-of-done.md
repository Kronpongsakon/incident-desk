# Definition of Done

A change is done when every item below is checked. Items marked _(optional)_ are guesses: the repo doesn't enforce them yet, and the team can confirm or delete them.

Sources: `docs/requirements.md`, `docs/user-stories.md`, `config/ci.rb`, and the existing code and git history.

## Functionality

- [ ] Every acceptance criterion of the story in `docs/user-stories.md` has a test, and that test passes.
- [ ] Ticket `severity` only accepts `Low`, `Medium`, `High`, `Urgent`, and ticket `status` only accepts `Open`, `In Progress`, `Resolved`. A model test rejects any other value.
- [ ] A new ticket's `status` is `Open`. A model test checks this.
- [ ] Ticket title validation rejects titles under 5 characters and description validation rejects descriptions under 10 characters. Model tests cover both lengths.
- [ ] A status change or a new comment broadcasts a Turbo Stream, so other open screens update without a page reload. A test asserts this with `assert_turbo_stream_broadcasts`.
- [ ] Every ticket status change records an audit event. A test asserts that one event exists per change.
- [ ] Creating a `High` or `Urgent` ticket enqueues the escalation job (`assert_enqueued_with`). The job flags the ticket only when it is still `Open` and unassigned after 15 minutes. Tests cover both the flagged and the skipped case.
- [ ] Nothing listed under "Explicitly Out of Scope" in `docs/requirements.md` is added: no SMTP password reset, no attachments, no roles other than `customer`/`agent`, and no WYSIWYG editor.

## Access Control

- [ ] Every new controller action requires sign-in. The only exceptions are listed in `allow_unauthenticated_access`, and an integration test checks that a signed-out request is redirected to `new_session_path`.
- [ ] A customer gets a not-found response or a redirect for another customer's ticket, on every action: show, edit, update, and comment. Integration tests cover each action.
- [ ] Agent-only actions (change status, assign) are refused for a customer. Integration tests cover each one.
- [ ] Ticket queries for customers go through a scope (for example `Current.user.tickets`), not `Ticket.find(params[:id])` followed by a check.
- [ ] Role checks use `User#agent?` / `User#customer?` and add no new roles.

## Code Quality

- [ ] `bin/rubocop` passes with no offenses.
- [ ] `git diff main... | grep -nE '^\+.*\b(binding\.(irb|pry)|debugger|console\.log)\b'` prints nothing.
- [ ] No new gem or npm package, unless the PR description says why. _(optional)_

## Testing

- [ ] `bin/rails test` passes.
- [ ] `env RAILS_ENV=test SEED_PASSWORD=$(ruby -rsecurerandom -e 'print SecureRandom.hex(16)') bin/rails db:seed:replant` passes.
- [ ] New rake tasks have a test under `test/tasks/`, as `users_rake_test.rb` does.
- [ ] New fixtures go in `test/fixtures/` and contain no real email addresses or passwords.
- [ ] `bin/rails test:system` passes for the real-time stories (4 and 5). It is commented out in `config/ci.rb` today. _(optional)_

## Security

- [ ] `bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error` passes.
- [ ] `bin/bundler-audit` passes.
- [ ] `yarn audit` passes.
- [ ] The diff contains no secrets, passwords or tokens. Read them from `ENV` or `bin/rails credentials:edit`. `git diff main... -- . ':!test' | grep -niE '(password|secret|token|api_key)\s*[:=]\s*["'\'']'` prints nothing (test fixtures and fake test passwords are excluded).
- [ ] If a credential was ever committed, the commit history is purged and the credential is rotated before merge.
- [ ] New sensitive params are covered by `config/initializers/filter_parameter_logging.rb`.
- [ ] Controllers take user input only through strong params (`params.expect` / `params.require(...).permit`).
- [ ] New unauthenticated endpoints use `   rate_limit`, as `SessionsController#create` does.

## Operations

- [ ] Migrations reverse cleanly: `bin/rails db:migrate && bin/rails db:rollback && bin/rails db:migrate` succeeds.
- [ ] `db/schema.rb` is committed and matches the migrations, so `git status` is clean after `bin/rails db:migrate`.
- [ ] Background jobs run on Solid Queue. Started with `bin/jobs`, the job runs and leaves no failed rows in `solid_queue_failed_executions`.
- [ ] `curl -fsS localhost:3000/up` returns 200 under `bin/dev`.
- [ ] Each new environment variable is listed by name in `config/deploy.yml` (`env.clear` / `env.secret`), and its value comes from `.kamal/secrets` through `ENV` or a secrets manager, never inline.
- [ ] `config.force_ssl` / `config.assume_ssl` are enabled in production before the first deploy. _(optional)_

## Documentation

- [ ] The README documents every new command, rake task and environment variable, as it does for `users:create` and `SEED_PASSWORD`.
- [ ] Changed behavior is reflected in `docs/requirements.md` / `docs/user-stories.md` when it differs from what they say.
- [ ] A decision that is hard to reverse (a new dependency, data model or queue design) gets an ADR in `docs/adr/`. _(optional)_
- [ ] `GLOSSARY.md`, if it exists, is used for domain terms in code and test names. _(optional)_

## Delivery

- [ ] `bin/ci` passes locally with every step green. The repo has no GitHub Actions workflow, so this is the CI gate.
- [ ] The work is tracked by a GitHub issue of type `Task` in `BananaCoding/incident-desk` (see `docs/agents/issue-tracker.md`).
- [ ] The branch is named `<type>/<issue-number>-<slug>`, for example `feat/7-sign-in-and-log-out`. _(optional)_
- [ ] Commit messages follow `type(scope): Summary`, for example `fix(auth): Harden sign-in`. _(optional)_
- [ ] The PR description contains `Closes #<issue-number>`.
- [ ] The PR is reviewed and approved by one other person before merge. _(optional)_
- [ ] A green commit status is set with `gh signoff`. It is commented out in `config/ci.rb` today. _(optional)_
- [ ] The PR is opened with every section of `.github/pull_request_template.md` filled in, and its title and description follow `docs/pull-requests.md`.
