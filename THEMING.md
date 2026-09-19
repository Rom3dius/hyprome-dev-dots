# System Theming Guide

Theming now goes through caelestia-dots' own scheme system instead of the old
per-app file checklist (kitty/waybar/rofi/dunst/hyprlock/hyprpaper/wlogout).
`wintergreen-reference.md` remains the canonical palette definition/rationale.

## How caelestia theming works

- The active colour scheme is a Lua table at `~/.config/hypr/scheme/current.lua`,
  with the same ~40 Material-You-style roles as
  [caelestia's `default.lua`](https://github.com/caelestia-dots/caelestia/blob/main/hypr/scheme/default.lua)
  (`base`, `mantle`, `crust`, `surface0-2`, `text`, `subtext0/1`, `overlay0-2`,
  plus Catppuccin-named accents: `pink`, `mauve`, `red`, `peach`, `yellow`,
  `green`, `teal`, `sky`, `sapphire`, `blue`, `lavender`, `rosewater`,
  `flamingo`, `maroon`). Most of `wintergreen-reference.md`'s roles map onto
  these directly (base/mantle/crust/surface0-2/text/subtext/overlay0-2/pink/
  mauve/red/peach/yellow/green/blue/lavender all have a 1:1 match already).
- caelestia-shell (quickshell), Hyprland, foot, and fish's prompt/abbrs all
  read from this one file — there is no more per-app color duplication to
  keep in sync.
- `caelestia scheme set -n <name> [-f <flavour>] [-m <mode>]` (from
  `caelestia-cli`, built into the `hyprome` OS image, see
  `~/src/hyprome/files/scripts/install-caelestia.sh`) switches schemes and
  regenerates `current.lua` + notifies running apps. Built-in schemes ship
  as Python package data in caelestia-cli itself (`nord`, `catppuccin`,
  `everforest`, `darkgreen`, `gruvbox`, `dracula`, `tokyonight`, `rosepine`,
  `solarized`, `onedark`, `oldworld`, `everblush`, `shadotheme`,
  `caelestia`) — there's no "wintergreen" entry among them, and no
  documented way to add a custom named scheme without adding a new
  `src/caelestia/data/schemes/wintergreen/...` directory and rebuilding
  caelestia-cli from source (that would happen in `install-caelestia.sh` at
  `hyprome` image-build time, not in this repo).
- **Interim default**: until a real "wintergreen" scheme is added to
  caelestia-cli's package data, `darkgreen` or `everforest` are the closest
  built-in matches (cool/dark, green-leaning) — pick one with
  `caelestia scheme set -n darkgreen` after first login.
- `~/.config/hypr/scheme/current.lua` is deliberately left alone by
  `hyprome-dev-dots`' yadm bootstrap (see `.config/yadm/bootstrap`) even
  though the rest of `~/.config/hypr` is re-synced from upstream caelestia
  on every run — otherwise every bootstrap re-run would revert your chosen
  scheme back to caelestia's default.

## Per-app overrides that still exist

A few things sit outside the scheme system and are set directly:

- `~/.config/caelestia/hypr-vars.lua` — non-colour Hyprland variables
  (terminal, browser, gaps, blur, etc.) — see `hypr-vars.lua` in this repo.
- `~/.config/caelestia/hypr-user.lua` — raw Hyprland config appended after
  caelestia's own (currently just our monitor layout) — see `hypr-user.lua`.
- `~/.config/caelestia/user-config.fish` — fish shell customization, sourced
  at the end of caelestia's `fish/config.fish`.
- **SDDM login theme** (`hyprome` repo,
  `files/system/usr/share/sddm/themes/sddm-hyprome-theme/`) — caelestia
  doesn't manage a login screen, so this custom SDDM theme's colours are
  still set by hand and won't automatically follow a `caelestia scheme set`
  call. Update
  `Themes/hyprome_theme.conf` (HeaderTextColor, FormBackgroundColor,
  LoginButtonBackgroundColor, etc.) and the `Backgrounds/` wallpaper to
  match whichever scheme is active if you want them to stay in sync.

## Retired

Kitty, waybar, rofi, dunst, hyprlock, hyprpaper, and wlogout configs (and
their theme files in this repo's git history / the `hyprome-backup` branch)
are no longer the source of truth for desktop theming — caelestia-shell and
Hyprland's own scheme-driven config replace them. `.config/kitty` is left in
this repo for now (harmless, foot is the new default terminal per
`hypr-vars.lua`'s `terminal` var) but is no longer theme-synced.
