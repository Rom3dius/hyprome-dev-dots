# System Theming Guide

This document lists all configuration files that need to be updated when changing the system theme. Use the `wintergreen-reference.md` as a template for defining your color palette.

## Quick Reference - Color Roles

When creating a new theme, define these core colors:

| Role | Description | Example (Wintergreen) |
|------|-------------|----------------------|
| `base` | Main background | `#1a2332` |
| `mantle` | Darker background (sidebars, headers) | `#151d28` |
| `crust` | Darkest background | `#0f1419` |
| `surface0` | Elevated surfaces, inputs | `#243342` |
| `surface1` | Selection, hover states | `#2d3f52` |
| `surface2` | Active selections | `#364b62` |
| `text` | Primary text | `#c8d5e3` |
| `subtext` | Secondary text | `#a8b8c7` |
| `overlay` | Borders, inactive elements | `#495f75` |
| `accent` | Primary accent (teal) | `#73c5b8` |
| `accent_bright` | Hover accent | `#99e0d9` |
| `green` | Success, additions | `#8fc5a1` |
| `yellow` | Warnings, search | `#e6d89c` |
| `red` | Errors, deletions | `#d88a8a` |
| `blue` | Info, links, functions | `#7da6d6` |
| `pink` | Keywords | `#d4a5c9` |
| `mauve` | Special, preprocessor | `#b5a5d6` |
| `peach` | Constants, numbers | `#e6b89c` |

---

## Files to Update

### 1. Terminal (Kitty)

**File:** `.config/kitty/kitty-themes/<theme>.conf`

```conf
foreground            #text
background            #base
selection_foreground  #base
selection_background  #accent
cursor                #text
cursor_text_color     #base

# ANSI colors (color0-color15)
color0  #crust      # black
color1  #red        # red
color2  #green      # green
color3  #yellow     # yellow
color4  #blue       # blue
color5  #pink       # magenta
color6  #accent     # cyan
color7  #text       # white
color8  #overlay    # bright black
color9-15           # bright variants
```

**Also update:** `.config/kitty/kitty.conf` - change the `include` line

---

### 2. Shell Prompt (Starship)

**File:** `.config/starship.toml`

Key sections to update:
- `[palettes.<theme>]` - define all colors
- Module styles use `bg:#hex fg:#hex` format
- `[character]` - success/error symbols

---

### 3. Neovim Colorscheme

**File:** `~/.config/nvim/lua/plugins/<theme>.lua`

Contains:
- `M.colors` table with all color definitions
- `M.setup()` function that applies highlights
- Highlight groups for: Editor, Syntax, Treesitter, LSP, Plugins

**Also update:** `~/.config/nvim/lua/plugins/colorscheme.lua` to load your theme

---

### 4. Waybar

**File:** `.config/waybar/style.css`

Update the CSS variables at the top:
```css
@define-color backgroundlight #surface0;
@define-color backgrounddark #base;
@define-color workspacesbackground1 #accent;
@define-color workspacesbackground2 #surface1;
@define-color bordercolor #overlay;
@define-color textcolor1 #text;
@define-color textcolor2 #subtext;
@define-color textcolor3 #subtext0;
@define-color iconcolor #accent;
```

Also check hardcoded colors in:
- `#network.disconnected`
- `#battery.critical`
- `#custom-hypridle` states

---

### 5. Rofi

**File:** `.config/rofi/config.rasi`

Update the `* { }` block at the top:
```rasi
* {
    background:      rgba(base, 0.9);
    foreground:      #text;
    border-color:    #accent;
    selection:       #surface1;
    accent:          #accent;
    /* etc */
}
```

---

### 6. Dunst (Notifications)

**File:** `.config/dunst/dunstrc`

Update sections:
- `frame_color` in `[global]`
- `[urgency_low]` - background, foreground, frame_color
- `[urgency_normal]` - background, foreground, frame_color
- `[urgency_critical]` - background, foreground, frame_color

---

### 7. Hyprland

**Files:**
- `.config/hypr/conf/general.conf` - border colors
- `.config/hypr/conf/decoration.conf` - shadow color

```conf
# general.conf
col.active_border = rgba(accentff)
col.inactive_border = rgba(overlayaa)

# decoration.conf
shadow { color = rgba(crustee) }
```

---

### 8. Hyprlock (Lock Screen)

**File:** `.config/hypr/hyprlock.conf`

Update:
- `background { path = }` - wallpaper
- `input-field` colors: outer_color, inner_color, font_color, check_color, fail_color
- `label` colors

---

### 9. Hyprpaper (Desktop Wallpaper)

**File:** `.config/hypr/hyprpaper.conf`

```conf
preload = ~/.config/ml4w/wallpapers/<wallpaper>
wallpaper = ,~/.config/ml4w/wallpapers/<wallpaper>
```

---

### 10. Wlogout

**File:** `.config/wlogout/style.css`

Update:
- `window { background-color }` - base with alpha
- `button { color, background-color, border }` - text, surface, accent
- `button:hover` - hover states

---

### 11. Yazi (File Manager)

**File:** `.config/yazi/theme.toml`

Sections:
- `[manager]` - cwd, hovered, markers, tabs, borders
- `[status]` - mode colors, progress
- `[input]`, `[select]`, `[tasks]` - borders
- `[which]`, `[help]` - key hints
- `[filetype]` - file type colors

---

### 12. Lazygit

**File:** `.config/lazygit/config.yml`

Add under `gui:`:
```yaml
gui:
  theme:
    activeBorderColor: ["#accent", bold]
    inactiveBorderColor: ["#overlay"]
    selectedLineBgColor: ["#surface1"]
    # etc
```

---

### 13. bat

**File:** `.config/bat/config`

Uses terminal colors via `--theme="ansi"`, so Kitty theme applies automatically.

---

### 14. GTK 3/4

**Files:**
- `.config/gtk-3.0/gtk.css`
- `.config/gtk-4.0/gtk.css`

GTK4 supports `@define-color` for libadwaita apps. Update all color definitions and element styles.

---

### 15. SDDM (Login Screen) - In `hyprome` repo

**File:** `files/system/usr/share/sddm/themes/sddm-hyprome-theme/Themes/hyprome_theme.conf`

Update:
- `Font` - font family
- All color settings (HeaderTextColor, FormBackgroundColor, LoginButtonBackgroundColor, etc.)
- `Background` - wallpaper filename

**Also:** Copy wallpaper to `Backgrounds/` folder in the theme directory

---

## Repositories Affected

| Repository | Files |
|------------|-------|
| `hyprome-dev-dots` | Kitty, Starship, Neovim, Waybar, Rofi, Dunst, Hyprland, Hyprlock, Hyprpaper, Wlogout, Yazi, Lazygit, bat, GTK |
| `hyprome` | SDDM theme |
| `~/.config/nvim` | Neovim colorscheme (if not in dots) |

---

## Testing Checklist

After applying a new theme:

- [ ] Open new terminal - colors correct
- [ ] Check Starship prompt segments
- [ ] Open Neovim - syntax highlighting works
- [ ] Check Waybar - hover states, workspace indicators
- [ ] Open Rofi (Super+D) - colors and selection
- [ ] Trigger notification - dunst colors
- [ ] Check window borders - active vs inactive
- [ ] Lock screen - hyprlock colors
- [ ] Open wlogout - button colors
- [ ] Open yazi - file colors, status bar
- [ ] Open lazygit - borders and selections
- [ ] Run `bat` on a file - syntax colors
- [ ] Open GTK app - buttons, inputs, selections
- [ ] Reboot and check SDDM login screen
