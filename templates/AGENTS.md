# Hermes Spec Harness Rules

Use OpenSpec for all non-trivial changes. No source code changes before an OpenSpec change exists.

Core rules:

- no code before OpenSpec change.
- one-change-one-commit.
- secret safety: never print or commit secrets, tokens, `.env` values, authorization headers, private keys, or private endpoints.
- worktree rules: use worktrees for parallel agents or risky experiments.
- delegation rules: use delegation only for bounded roles with clear ownership and no overlapping write scope.

Create specs/tasks first and stop for review. Implement only after the human approves the OpenSpec scope.

One change = one purpose = one commit. Do not mix feature, refactor, docs, examples, or dependency upgrade in one change.

Secret safety is mandatory. Never print or commit secrets, tokens, `.env` values, authorization headers, private keys, or private endpoints.

Use worktrees for parallel agents. Use delegation only for bounded roles with clear ownership and no overlapping write scope.

Archive completed OpenSpec changes before commit. Keep git status clean between changes.

## Lifecycle

`create → review → approve → implement → verify → archive → commit`

## Change Types

Use focused change ids such as `audit-*`, `investigate-*`, `fix-*`, `polish-*`, `add-*`, `refactor-*`, and `modularize-*`.

## Subagent Rules

Delegate only bounded roles:

- spec review: check proposal/spec/tasks for scope and acceptance criteria.
- test audit: inspect verification coverage and gaps.
- docs/examples audit: check user-facing examples and migration notes.
- safety audit: check secret safety, destructive commands, and external writes.

Subagents should use separate worktrees when writing files. Do not let multiple agents write to the same checkout.

## Before-Commit Checklist

- OpenSpec change exists and matches the implementation.
- Specs/tasks were reviewed before source edits.
- Verification commands were run or skipped with exact reasons.
- Secrets, tokens, `.env` values, authorization headers, and private keys were not printed or committed.
- Completed OpenSpec changes were archived.
- Git status contains only the approved one-change-one-commit scope.
