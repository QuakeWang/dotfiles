# dotfiles

Personal macOS dotfiles for:

- terminal workflow (`zsh`, `kitty`, `starship`, `fastfetch`, `btop`, `bat`, `yazi`)
- editor workflow (`nvim`, `vscode`)
- window management and bar (`yabai`, `skhd`, `sketchybar`, `borders`)

## Quick Start (new machine)

```bash
git clone https://github.com/QuakeWang/dotfiles.git
cd dotfiles
bash setup.sh
```

After setup:

```bash
exec zsh -l
```

## What `setup.sh` does

- installs Homebrew (if missing)
- installs required formula/casks and fonts
- copies configs into `~/.config/*`
- copies VSCode settings to `~/Library/Application Support/Code/User/settings.json`
- links `~/.zshenv -> ~/.config/zsh/.zshenv` (so `ZDOTDIR` config is active)
- starts `yabai`, `skhd`, `sketchybar`, `borders` services

## Sync local changes back to repo

```bash
bash update.sh
```

This copies your local config from `~/.config` back into this repository.

## Notes

- `yabai` may require additional macOS permissions / scripting addition setup for full functionality.
- `nvim` uses LazyVim + lazy.nvim and will install plugins on first launch.
