# Profile Distribution

Install Hermes Spec Harness as a profile distribution:

```bash
hermes profile install github.com/xsa-dev/hermes-spec-harness --name hsh --alias --yes
hsh chat
```

The `hsh` alias starts Hermes with the harness identity, config, skills, sessions, and runtime state. Distribution-owned files include profile metadata, `SOUL.md`, placeholder-safe config, the HSH skill, templates, schema bundles, examples, and docs. The default profile model is `gpt-5.5` via provider `openai-codex`; users must configure provider auth locally.

Credentials, memories, sessions, and local state remain local and must not be bundled. The distribution contains no secrets.

Profile mode is not a sandbox. Use git worktrees for parallel changes, a constrained cwd for the terminal, Docker for risky commands, or a remote terminal backend when machine isolation is required.

Updates should replace distribution-owned files while preserving user-local credentials and runtime state managed by the installed Hermes environment.
