-- Loaded last by caelestia's hypr/hyprland.lua, after all its default config.
-- Monitor layout ported from the old (pre-caelestia) monitors.conf /
-- workspaces.conf on the hyprome-dev-dots `hyprome-backup` branch.

-- Laptop display
hl.monitor({
	output = "eDP-1",
	mode = "2880x1920@120.0",
	position = "0x0",
	scale = 2.0,
})

-- Dell docking station (ASUS ROG PG27QRT1B, dual output)
hl.monitor({
	output = "desc:ASR PG27QRT1B H9VL0A006245",
	mode = "2560x1440@120",
	position = "1440x0",
	scale = 1.0,
})
hl.monitor({
	output = "desc:ASR PG27QRT1B H9VL0A006263",
	mode = "2560x1440@120",
	position = "4000x0",
	scale = 1.0,
})

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
