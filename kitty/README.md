# Kitty

In this documentation, we will learn how to use the Kitty terminal emulator.

## Preparations

In this configuration we will use `SF Mono` and `Symbols Nerd Font` fonts. You can install them using the following command:

```bash
brew tap homebrew/cask-fonts  # You only need to do this once!
brew install --cask font-sf-mono
brew install --cask font-symbols-only-nerd-font
brew install --cask sf-symbols
```

```bash
# Install Kitty
brew install --cask kitty
```

## Configuration

When you complete the preparation steps, the next step is to configure Kitty.

You only need to do is using a terminal to clone repository and copy the `kitty` directory to the `~/.config/`.

## QuickStart

- Use the `hjkl` four-key set as the left, down, top, and right keys:
  - `Alt-k`, `Alt-j` for quick up/down scrolling
  - `Cmd-{hjkl}` for window switching, `Cmd-Ctrl-{hjkl}` for splitting the screen in up/down/left/right directions
  - `Cmd-Alt-{hjkl}` to swap individual window positions, `Cmd-Shift-{hjkl}` to resize individual windows
- `Cmd-/`, `Cmd-Shift-/` to quickly scroll to the previous/next command position, `Cmd-Alt-/` to show only the last command output
- `Cmd-Enter` to create a new Tab, `Cmd-[`, `Cmd-]` to switch between Tabs, `Cmd-Alt-[`, `Cmd-Alt-]` to move Tabs forward/backward
- `Cmd-w` to close a single window, `Cmd-Shift-w` to close all windows (in a single Tab)
- `Cmd-r` to clear the screen, `Cmd-f` to search, `Cmd-Shift-f` to maximize the terminal (but not full screen)

For more detail you can refer `kitty/kitty.conf`.
