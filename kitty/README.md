# Kitty

This directory is managed by Home Manager and linked into `~/.config/kitty`.
Kitty itself is installed by nix-darwin through Homebrew, so there is no
manual copy step for this config.

## Apply Changes

Run:

```bash
sudo darwin-rebuild switch --flake .#erxis-macbook-pro
```

## Key Bindings

- `Alt-j` / `Alt-k`: scroll down/up
- `Cmd-Ctrl-hjkl`: split the current window
- `Cmd-hjkl`: move focus between kitty windows
- `Cmd-Shift-hjkl`: resize the current window
- `Cmd-Alt-hjkl`: move the current window
- `Cmd-Enter`: toggle stack layout
- `Cmd-t`: new tab
- `Cmd-[` / `Cmd-]`: previous/next tab
- `Cmd-Alt-[` / `Cmd-Alt-]`: move tab backward/forward
- `Cmd-w`: close the current window
- `Cmd-Shift-w`: close the current tab
- `Cmd-r`: clear the terminal to cursor
- `Cmd-f`: search scrollback
- `Cmd-Shift-f`: toggle maximized
- `Cmd-q`: quit kitty

For implementation details, see `kitty/kitty.conf`.
