-- Overrides merged over caelestia's hypr/variables.lua defaults
-- (see ~/.config/hypr/hyprland.lua for how this gets loaded).
return {
	-- Brave is installed as a system flatpak (see hyprome's recipe.yml)
	browser = "flatpak run com.brave.Browser",
	-- caelestia's default `pwvucontrol` isn't available in any repo hyprome
	-- has enabled for Fedora 44; wayblue's own pavucontrol is installed instead
	audioSettings = "pavucontrol",
}
