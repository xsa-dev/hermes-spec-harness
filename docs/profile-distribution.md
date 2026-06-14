# Profile Distribution

Install Hermes Spec Harness as a profile distribution:

```bash
hermes profile install github.com/xsa-dev/hermes-spec-harness --name hsh --alias --yes
hsh chat
```

If `hsh` is already installed, update the distribution-owned files in place:

```bash
hermes profile update hsh --force-config --yes
```

`profile update` takes the profile name (`hsh`), not the GitHub URL. `--force-config` is required when you want new bundled config defaults, such as `model.default: gpt-5.5`, to replace the installed profile config. For a reinstall, `profile install` uses `--force`; Hermes does not have a `--overwrite` flag for profile install.

The `hsh` alias starts Hermes with the harness identity, config, skills, sessions, and runtime state. Distribution-owned files include profile metadata, `SOUL.md`, placeholder-safe config, the HSH skill, templates, schema bundles, examples, and docs. The default profile model is `gpt-5.5` via provider `openai-codex`; the compression summarizer is also pinned to `auxiliary.compression.model: gpt-5.5` via `openai-codex`, so context compaction does not auto-route to OpenRouter. Users must configure provider auth locally.

Credentials, memories, sessions, and local state remain local and must not be bundled. The distribution contains no secrets.

Profile mode is not a sandbox. Use git worktrees for parallel changes, a constrained cwd for the terminal, Docker for risky commands, or a remote terminal backend when machine isolation is required.

Updates should replace distribution-owned files while preserving user-local credentials and runtime state managed by the installed Hermes environment.
