-- Overrides merged over caelestia's hypr/variables.lua defaults
-- (see ~/.config/hypr/hyprland.lua for how this gets loaded).
return {
	-- Brave is installed as a system flatpak (see hyprome's recipe.yml)
	browser = "flatpak run com.brave.Browser",
	-- caelestia's default `pwvucontrol` isn't available in any repo hyprome
	-- has enabled for Fedora 44; wayblue's own pavucontrol is installed instead
	audioSettings = "pavucontrol",
	-- Keeping kitty + zsh instead of switching to caelestia's foot/fish
	-- defaults, and GNOME's Nautilus instead of Thunar
	terminal = "kitty",
	fileExplorer = "nautilus",

	-- Reassigned to match old (pre-caelestia) muscle memory, from
	-- hyprome-backup's .config/hypr/conf/binds.conf:
	kbTerminal = "SUPER + Return",           -- was SUPER + T
	kbToggleWindowFloating = "SUPER + T",    -- was SUPER + ALT + Space (T freed up above)
	kbLauncher = "SUPER + D",                -- was SUPER + SUPER_L (tap)
	kbBrowser = "SUPER + B",                 -- was SUPER + W
	kbClipboard = "SUPER + SHIFT + V",       -- was SUPER + V
	kbMoveWinToWs = "SUPER + SHIFT",         -- was SUPER + ALT

	kbCommunicationWs = "CTRL + SUPER + D",  -- was SUPER + D (now kbLauncher)

	-- Relocated to keep the full hjkl vim-motion scheme below on K and L —
	-- these are caelestia's own defaults, not from the old config.
	kbShowPanels = "SUPER + A",              -- was SUPER + K
	kbLock = "SUPER + Escape",               -- was SUPER + L
	kbSleep = "SUPER + SHIFT + Escape",      -- was SUPER + SHIFT + L
	-- kbRestoreLock (SUPER + ALT + L) is untouched — the vim binds below
	-- only use plain/SHIFT/CTRL modifiers, never ALT, so no collision there.
}
