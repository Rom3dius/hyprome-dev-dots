# Global instructions

## Environment
- Fedora atomic desktop (hyprome image, Hyprland + caelestia shell). The root FS is immutable: install CLI tools with Homebrew (`/home/linuxbrew`), Python tools with `uv tool`, and services as podman quadlets / systemd user units.
- `$HOME` is a yadm repo (`Rom3dius/hyprome-dev-dots`); the working checkout lives at `~/src/hyprome-dev-dots`. Config that should survive a reinstall belongs there.

## Working style
- Match the surrounding code: naming, comment density, idioms.
- Keep changes scoped to what was asked; mention adjacent issues instead of fixing them unasked.
- Commits: `<type>: <description>` (feat, fix, refactor, docs, test, chore, perf, ci). Only commit or push when asked.

## Tooling
- Code navigation: prefer Serena's symbol tools (`get_symbols_overview`, `find_symbol`, `find_referencing_symbols`) over reading whole files or broad greps.
- Task tracking: projects using `beans` get its context at session start; use it for multi-step work there.

## Serena
- Serena activates the nearest repo root (`.git` or `.serena/project.yml`) from the cwd at startup; only call `activate_project` when switching repos or when it reports no project.
- First time in a repo (Serena just generated `.serena/project.yml`): check that `language_servers` covers every language in the repo — detection often picks just one — and add build output and vendored dirs to `ignored_paths`.
- Then ask whether to commit `.serena/project.yml` or add `.serena/` to `.git/info/exclude`. Serena's own `.serena/.gitignore` already keeps its cache out.
- Serena memories are disabled; project knowledge goes in the repo's `CLAUDE.md` or Claude's own memory.

## Secrets and SSH (1Password)
- SSH keys live in 1Password (vault `Dev`) and are served by its agent: `~/.ssh/config` sets `IdentityAgent ~/.1password/agent.sock` for every host. There are no key files on disk — don't generate or look for any; `ssh`/`git push` pop a 1Password approval for the user.
- The `op` CLI unlocks through the desktop app, so each use may prompt the user. There is more than one account (personal and work): check `op account list` and pass `--account` explicitly.
- Finding things is safe: `op item list --vault <v>`, `op item get <item>` (concealed fields stay hidden without `--reveal`).
- Never put a secret value in the conversation or a file. Feed it straight into the command that needs it: `cmd --token "$(op read 'op://<vault>/<item>/<field>')"` or `op run --env-file=.env -- cmd` with `op://` references in the env file.
- Ask before retrieving a credential the task doesn't obviously need.

@RTK.md
