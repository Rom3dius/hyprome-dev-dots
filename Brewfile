# Host dev tooling for Neovim, installed natively via Homebrew.
# Replaces the old localhost/nvim-editor podman container (retired 2026-07-26):
# running nvim natively avoids Wayland-socket forwarding and image-rebuild
# interpreter drift. Apply with:  brew bundle --file=Brewfile
brew "neovim"
brew "node"          # vtsls, yaml-language-server, docker LSPs, prettier
brew "go"            # gopls
brew "rust"          # rust-analyzer (cargo/rustc) + rustfmt
brew "fzf"
brew "lazygit"
brew "ripgrep"
brew "fd"
brew "wl-clipboard"  # already provided by the host; listed for reproducibility
