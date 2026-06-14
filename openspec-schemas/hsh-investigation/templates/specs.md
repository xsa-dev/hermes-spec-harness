# Investigation Specification

## Hypothesis

State the suspected cause or the question to answer.

## Evidence plan

List files, commands, logs, and runtime checks to inspect.

## Safe commands

Use read-only commands where possible. Avoid destructive commands and external writes.

## Redaction rules

Redact secrets, tokens, `.env` values, authorization headers, private keys, personal data, and private endpoints.

## Non-goals

No source changes, no dependency upgrades, and no unrelated cleanup.

## Expected output

Provide findings, confidence, evidence, and recommended next steps.

## Follow-up recommendation

If implementation is needed, propose a separate `fix-*` OpenSpec change.

## No source changes

This workflow is investigation-only. Do not edit source files.
