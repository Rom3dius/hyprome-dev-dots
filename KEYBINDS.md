# Keybind Cheatsheet

The full picture: caelestia's defaults (from `caelestia-dots/caelestia`'s
`hypr/variables.lua` + `hypr/hyprland/keybinds.lua`), overridden where noted
in `.config/caelestia/hypr-vars.lua`, plus custom binds added directly in
`.config/caelestia/hypr-user.lua`. **Overridden** = we changed caelestia's
default. **Custom** = not a caelestia default at all, added from scratch.

`SUPER` = the Windows/Cmd key (called `$mainMod` in old-style Hyprland
configs).

## Apps

| Bind | Action | |
|---|---|---|
| `SUPER + Return` | Open terminal (kitty) | **Overridden** (was `SUPER+T`) |
| `SUPER + SHIFT + Return` | Dropdown terminal (floating, 70%×60%) | **Custom** |
| `SUPER + B` | Open browser (Brave) | **Overridden** (was `SUPER+W`) |
| `SUPER + E` | Open file manager (Nautilus) | |
| `SUPER + C` | Open editor (codium — not installed, currently a no-op) | |
| `CTRL + ALT + V` | Open audio settings (pavucontrol) | |

## Window management

| Bind | Action | |
|---|---|---|
| `SUPER + Q` | Close window | |
| `SUPER + T` | Toggle floating | **Overridden** (was `SUPER+ALT+Space`) |
| `SUPER + F` | Fullscreen (exclusive) | |
| `SUPER + ALT + F` | Fullscreen (maximized, bordered) | |
| `SUPER + P` | Pin window | |
| `SUPER + Z` | Move window (keyboard-driven) | |
| `SUPER + X` | Resize window (keyboard-driven) | |
| `SUPER + mouse:272` (LMB) drag | Move window | |
| `SUPER + mouse:273` (RMB) drag | Resize window | |
| `CTRL + SUPER + \` | Center window | |
| `CTRL + SUPER + ALT + \` | Normalize window size | |
| `SUPER + ALT + \` | Picture-in-picture | |
| `SUPER + U` | Ungroup window | |
| `SUPER + ,` | Toggle group | |
| `SUPER + SHIFT + ,` | Lock active group | |
| `ALT + Tab` / `SHIFT + ALT + Tab` | Cycle window next/prev | |
| `CTRL + ALT + Tab` / `CTRL + SHIFT + ALT + Tab` | Cycle window group next/prev | |
| `SUPER + Minus` / `SUPER + Equal` | Decrease/increase width | |
| `SUPER + SHIFT + Minus` / `SUPER + SHIFT + Equal` | Decrease/increase height | |
| `SUPER + ALT + J` | Toggle dwindle split | **Custom**, relocated off `SUPER+J` (was old config's bind, `J` now vim-down) |

### Vim-style (hjkl) — custom, additive to arrow keys

| Bind | Action |
|---|---|
| `SUPER + h/j/k/l` | Focus left/down/up/right |
| `SUPER + CTRL + h/j/k/l` | Move window left/down/up/right |
| `SUPER + SHIFT + h/j/k/l` | Resize window (±5% of current size) |

Arrow-key equivalents (`SUPER+Left/Right/Up/Down`, `SUPER+SHIFT+Left/...`)
still work too — both schemes are active.

## Workspaces

| Bind | Action | |
|---|---|---|
| `SUPER + [0-9]` | Go to workspace 1-10 | |
| `SUPER + SHIFT + [0-9]` | Move window to workspace | **Overridden** (was `SUPER+ALT`) |
| `CTRL + SUPER + [0-9]` | Go to workspace group | |
| `CTRL + SUPER + ALT + [0-9]` | Move window to workspace group | |
| `SUPER + mouse_down/up` (scroll) | Next/prev workspace | |
| `SUPER + Page_Down/Up` | Next/prev workspace | |
| `CTRL + SUPER + Right/Left` | Next/prev workspace | |
| `SUPER + ALT + S` | Move window to special workspace | |
| `CTRL + SUPER + SHIFT + Up/Down` | Move window to/from special workspace | |
| `SUPER + S` | Toggle special workspace | |
| `SUPER + M` | Toggle music workspace | |
| `CTRL + SUPER + D` | Toggle communication workspace | **Overridden** (was `SUPER+D`, now the launcher) |
| `SUPER + R` | Toggle todo workspace | |
| `CTRL + SHIFT + Escape` | Toggle system monitor workspace | |

## Utilities

| Bind | Action | |
|---|---|---|
| `SUPER + F1` | Searchable keybind cheatsheet (fuzzel, selecting an entry copies it) | **Custom** |
| `SUPER + D` | App launcher | **Overridden** (was `SUPER+SUPER_L` tap) |
| `SUPER + A` | Show all panels | **Overridden** (was `SUPER+K`, now vim focus-up) |
| `SUPER + N` | Show sidebar | |
| `SUPER + Escape` | Lock screen | **Overridden** (was `SUPER+L`, now vim focus-right) |
| `SUPER + ALT + L` | Restore lock | |
| `SUPER + SHIFT + Escape` | Sleep | **Overridden** (was `SUPER+SHIFT+L`) |
| `CTRL + ALT + Delete` | Session menu (logout/shutdown/reboot/hibernate) | |
| `CTRL + ALT + C` | Clear notifications | |
| `Print` | Screenshot | |
| `SUPER + SHIFT + S` | Screenshot (freeze) | |
| `SUPER + SHIFT + ALT + S` | Screenshot (region) | |
| `CTRL + ALT + R` | Record | |
| `SUPER + ALT + R` | Record (sound) | |
| `SUPER + SHIFT + ALT + R` | Record (region) | |
| `SUPER + SHIFT + C` | Color picker | |
| `SUPER + SHIFT + V` | Clipboard history | **Overridden** (was `SUPER+V`) |
| `SUPER + ALT + V` | Delete clipboard entry | |
| `CTRL + SHIFT + ALT + V` | Paste latest clipboard entry | |
| `SUPER + Period` | Emoji picker | |
| `XF86WLAN` | Toggle wifi | **Custom** |
| `XF86Refresh` | Send F5 | **Custom** |
| `CTRL + SUPER + SHIFT + R` | Kill quickshell | |
| `CTRL + SUPER + ALT + R` | Restart quickshell | |

## Media & hardware keys

All standard `XF86Audio*`/`XF86MonBrightness*` keys work as expected
(volume, mute, mic mute, brightness, play/pause/next/prev/stop) — unchanged
from caelestia's defaults, and already matched the old pre-caelestia config
almost exactly (same `wpctl`/`brightnessctl` commands).

| Bind | Action |
|---|---|
| `CTRL + SUPER + Space` | Play/pause |
| `CTRL + SUPER + Equal` / `Minus` | Next/prev track |
| `CTRL + SUPER + Backspace` | Stop |
| `SUPER + SHIFT + M` | Mute |

## Removed from the old config

- **Exit Hyprland** (`SUPER + M`) — conflicted with `kbMusicWs`. Use the
  session menu (`CTRL + ALT + Delete`) instead — has a UI, avoids an
  accidental instant exit.
- **Host shell bypass** (`SUPER + grave`) — no longer needed, running on
  host directly now.
- **Voice-to-text (hyprvoice)** (`SUPER + C` / `CTRL+C` / `SHIFT+C`) —
  removed, wasn't working.
- **Reload waybar/hyprpaper** — waybar/hyprpaper no longer exist,
  caelestia-shell has no equivalent manual-reload step to bind.
