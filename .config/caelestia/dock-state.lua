-- Dock state override for the built-in panel. Written by
-- ~/.local/bin/hypr-dock-watch (hypr-dock-watch.service) and applied from
-- hypr-user.lua *after* require("monitors"), so it wins over whatever
-- nwg-displays last generated for eDP-1.
--
-- Why a config file instead of the watcher just calling
-- `hyprctl eval 'hl.monitor{...}'`: on Hyprland 0.56 hl.monitor() at runtime
-- only *records* a monitor rule, it never applies it. The call answers "ok",
-- hl.get_monitors() still shows the old state, and monitor objects are
-- read-only (`attempt to modify read-only hl object`), so there is no runtime
-- setter at all. Only a config reload re-applies monitor rules -- hence
-- state-file + `hyprctl reload` for both directions.
local home = os.getenv("HOME")
local state_dir = (os.getenv("XDG_STATE_HOME") or (home .. "/.local/state"))
    .. "/hypr-dock-watch"

local f = io.open(state_dir .. "/edp")
if not f then return end -- no override: monitors.lua governs eDP-1
local want = (f:read("*l") or ""):gsub("%s+", "")
f:close()

if want == "off" then
    hl.monitor({ output = "eDP-1", disabled = true })
elseif want == "on" then
    -- Explicit re-enable, used only as a fallback when monitors.lua has lost
    -- its eDP-1 block (nwg-displays regenerates that file wholesale) and a
    -- plain reload didn't bring the panel back on its own (see sync_edp in
    -- hypr-dock-watch). Replays whatever mode/position/scale
    -- save_edp_geometry snapshotted right before the panel was last
    -- disabled, rather than a generic default -- a hardcoded scale here
    -- used to silently override every nwg-displays scale change for as
    -- long as this fallback stayed in effect. Falls back to this laptop's
    -- known-good panel geometry (monitors.lua.reference in the dotfiles
    -- repo) only if no snapshot exists yet, e.g. a fresh machine that has
    -- never docked before.
    local ok, geo = pcall(dofile, state_dir .. "/edp-geometry.lua")
    if not ok or type(geo) ~= "table" then
        geo = { mode = "2880x1920@120.000000", position = "0x0", scale = 2.0 }
    end
    hl.monitor({ output = "eDP-1", mode = geo.mode, position = geo.position, scale = geo.scale })
end
