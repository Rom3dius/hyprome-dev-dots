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

@RTK.md
