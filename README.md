# dotfiles

macOS dotfiles managed with Nix, Home Manager, and nix-darwin.

Config files live in this repo; Nix installs software, links them into place, and manages launchd services. Identity, secrets, and machine-local state stay in local include files outside the repo.

## Prerequisites

Install on a fresh Mac before anything else:

```bash
# 1. Xcode Command Line Tools
xcode-select --install

# 2. Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 3. Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Quick Start

```bash
git clone https://github.com/QuakeWang/dotfiles.git && cd dotfiles
git add -A
sudo -H nix --extra-experimental-features "nix-command flakes" \
  run github:nix-darwin/nix-darwin/master#darwin-rebuild -- \
  switch --flake .#erxis-macbook-pro
exec zsh -l
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

1. Install prerequisites, clone repo, run bootstrap command above.
2. Create local overlay files as needed.
3. Grant macOS permissions (Accessibility for yabai/skhd).

> [!NOTE]
> `/etc/bashrc` or `/etc/zshrc` hash mismatch on first activation? Run `shasum -a 256 /etc/bashrc /etc/zshrc` and append hashes to `nix/modules/darwin/base.nix`.
