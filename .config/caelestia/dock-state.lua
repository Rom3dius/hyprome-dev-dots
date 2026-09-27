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
local state = (os.getenv("XDG_STATE_HOME") or (home .. "/.local/state"))
    .. "/hypr-dock-watch/edp"

local f = io.open(state)
if not f then return end -- no override: monitors.lua governs eDP-1
local want = (f:read("*l") or ""):gsub("%s+", "")
f:close()

if want == "off" then
    hl.monitor({ output = "eDP-1", disabled = true })
elseif want == "on" then
    -- Explicit re-enable, used only as a fallback when monitors.lua has lost
    -- its eDP-1 block (nwg-displays regenerates that file wholesale).
    hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })
end
