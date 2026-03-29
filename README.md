# dotfiles

macOS dotfiles managed with Nix, Home Manager, and nix-darwin.

Config files live in this repo; Nix installs software, links them into place, and manages launchd services. Identity, secrets, and machine-local state stay in local include files outside the repo.

## Quick Start

On a **fresh Mac**, clone and run the bootstrap script — it handles Xcode CLT, Nix, Homebrew, and the first `darwin-rebuild` automatically:

```bash
git clone https://github.com/QuakeWang/dotfiles.git && cd dotfiles
./bootstrap.sh
```

Subsequent updates:

```bash
sudo darwin-rebuild switch --flake .#erxis-macbook-pro
```

> Newly added files must be `git add`ed before rebuild (Git flake requirement).

## What Is Managed

| Layer | Manages |
|-------|---------|
| Home Manager | zsh, nvim, kitty, bat, btop, fastfetch, yazi, starship, git, ssh, VS Code settings, sketchybar, zsh plugins |
| nix-darwin | macOS defaults, yabai, skhd, sketchybar, jankyborders, login shell, Nix settings |
| Homebrew (via nix-darwin) | kitty, google-chrome, fonts, switchaudio-osx |

## Private Local Overlays

Create these only if needed — they are not part of flake evaluation:

- `~/.config/git/local.gitconfig` — Git identity and signing
- `~/.ssh/config.local` — private SSH hosts
- `~/.config/zsh-local/common.zsh` — private shell overrides

## Shell Layering

```
~/.zshenv (HM-generated)
  → source darwinSetEnvironment
  → source ~/.config/zsh/.zshenv     # env vars, PATH, region overlay
      → source regions/<region>.zsh  # e.g. cn.zsh for China mirrors

~/.config/zsh/.zshrc                 # interactive: plugins, starship, atuin
  → keymap.zsh, function.zsh
```

## New Machine

1. Clone repo and run `./bootstrap.sh`.
2. Create local overlay files as needed.
3. Grant macOS permissions (Accessibility for yabai/skhd).
