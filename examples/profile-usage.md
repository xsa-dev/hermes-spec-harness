# Profile Usage

Install the profile distribution:

```bash
hermes profile install github.com/xsa-dev/hermes-spec-harness --name hsh --alias --yes
```

If the profile already exists and you want the latest bundled config defaults:

```bash
hermes profile update hsh --force-config --yes
```

Use `hermes profile update hsh --yes` without `--force-config` when preserving local config overrides is more important than adopting new defaults.

Run it:

```bash
hsh chat
```

Alternative standard profile workflows can point Hermes at this distribution through the user's local profile management command. Profile mode gives HSH its own config, identity, skills, sessions, and runtime state.

No secrets or user memories are shipped. Profile mode is not a sandbox; use worktrees, constrained cwd, Docker, or a remote terminal backend for filesystem isolation.
