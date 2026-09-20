-- Loaded last by caelestia's hypr/hyprland.lua, after all its default config.
-- Monitor layout lives in ~/.config/hypr/monitors.lua (NOT this file, and
-- NOT tracked by yadm/caelestia sync — see the rsync --exclude in
-- .config/yadm/bootstrap) so nwg-displays can write to it directly: run
-- `nwg-displays` (installed via hyprome's recipe.yml) to adjust
-- resolution/refresh-rate/position/scale through a GUI instead of hand-
-- editing Lua. It generates real hl.monitor({...}) blocks matching this
-- config's syntax. A recovery copy lives at monitors.lua.reference in
-- hyprome-dev-dots' repo root, in case this machine is ever reprovisioned.
require("monitors")

-- NOTE: the old config also pinned default workspaces per monitor
-- (workspace 1/2 on the dock outputs, 3 on eDP-1). caelestia doesn't
-- document an `hl.workspace(...)` equivalent for this yet — if/when one
-- shows up, port it here. Until then Hyprland's normal automatic
-- workspace-to-monitor assignment applies.

-- caelestia's own hypr/hyprland/execs.lua tries to launch
-- /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1, which isn't
-- installed here (hyprome installs hyprpolkitagent instead, matching the
-- rest of the Hyprland stack, and gnome-keyring is skipped since 1Password
-- already owns secrets storage) — that exec silently fails, so nothing ends
-- up providing a polkit auth agent. Start the one we actually have (full
-- path required — it installs to /usr/libexec, not on PATH).
hl.on("hyprland.start", function()
	hl.exec_cmd("/usr/libexec/hyprpolkitagent")
end)

-- ─────────────────────────────────────────────────────────────────────
-- Keybinds carried over from the old (pre-caelestia) binds.conf on the
-- hyprome-backup branch, that don't have a matching caelestia variable to
-- reassign (see hypr-vars.lua for the ones that do). Most of the modifier
-- key handling, volume/brightness/media keys, mouse move/resize, and
-- workspace-scroll binds are already covered by caelestia's own defaults —
-- only genuinely missing behavior is added here.
local fn = require("utils.functions")

-- NOTE: old config had SUPER + M for "exit Hyprland" — dropped, it conflicts
-- with caelestia's own kbMusicWs default (also SUPER + M, toggles a special
-- music workspace). caelestia's session menu (kbSession, default
-- CTRL + ALT + Delete) covers exit/logout/shutdown/reboot with a UI instead
-- of an instant no-confirmation exit, so nothing is lost by not re-adding it.

-- Toggle dwindle split (relocated off SUPER+J to make room for hjkl below —
-- old config had it on J, but J is needed for vim-style focus-down now)
hl.bind("SUPER + ALT + J", hl.dsp.exec_cmd("hyprctl dispatch togglesplit"))

-- Vim-style (hjkl) focus movement, resize, and window movement — additive
-- to caelestia's own arrow-key/Minus/Equal defaults, both work. K and L
-- would otherwise collide with caelestia's kbShowPanels/kbLock/kbSleep
-- defaults (Hyprland binds are case-insensitive, so SUPER+k == SUPER+K) —
-- those three got relocated in hypr-vars.lua instead of dropping the vim
-- binds, so all four directions work here.
local hjkl_dirs = { h = "left", j = "down", k = "up", l = "right" }
for key, dir in pairs(hjkl_dirs) do
	hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = dir }))
	hl.bind("SUPER + CTRL + " .. key, hl.dsp.window.move({ direction = dir }))
end
-- resize_active_window takes a %-of-current-size delta, not pixels like the
-- old resizeactive dispatcher did — 5% per press is a comparable feel.
hl.bind("SUPER + SHIFT + h", fn.resize_active_window(-5, 0), { repeating = true })
hl.bind("SUPER + SHIFT + l", fn.resize_active_window(5, 0), { repeating = true })
hl.bind("SUPER + SHIFT + k", fn.resize_active_window(0, -5), { repeating = true })
hl.bind("SUPER + SHIFT + j", fn.resize_active_window(0, 5), { repeating = true })

-- Dropdown terminal (floating, centered, 70%x60%). Uses a window_rule keyed
-- on a distinguishing --class instead of the classic inline [float;size;...]
-- exec prefix — that bracket syntax doesn't parse correctly through
-- exec_cmd on this Hyprland version (errors: "']' expected near ';'").
hl.window_rule({
	match = { class = "kitty-dropdown" },
	float = true,
	size = "(monitor_w*0.7) (monitor_h*0.6)",
	center = true,
})
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("kitty --class kitty-dropdown"))

-- Wifi toggle
hl.bind("XF86WLAN", hl.dsp.exec_cmd("nmcli radio wifi toggle"))

-- Refresh key -> F5 (xdotool isn't installed; wtype is the Wayland-native equivalent)
hl.bind("XF86Refresh", hl.dsp.exec_cmd("wtype -k F5"))

-- Searchable keybind cheatsheet (fuzzel, see .local/bin/keybind-cheatsheet —
-- parses KEYBINDS.md into fuzzel's fuzzy-search picker, copies the selected
-- bind to the clipboard). fuzzel is a floating overlay itself, no
-- window_rule needed.
hl.bind("SUPER + F1", hl.dsp.exec_cmd("$HOME/.local/bin/keybind-cheatsheet"))
