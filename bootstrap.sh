#!/usr/bin/env bash
# Bootstrap a fresh macOS machine with this dotfiles repo.
# Usage:  git clone https://github.com/QuakeWang/dotfiles.git && cd dotfiles && ./bootstrap.sh
set -euo pipefail

HOSTNAME="erxis-macbook-pro"

info()  { printf '\033[1;34m[info]\033[0m  %s\n' "$*"; }
ok()    { printf '\033[1;32m[ok]\033[0m    %s\n' "$*"; }
warn()  { printf '\033[1;33m[warn]\033[0m  %s\n' "$*"; }
error() { printf '\033[1;31m[error]\033[0m %s\n' "$*"; exit 1; }

# ── 1. Xcode Command Line Tools ──────────────────────────────────────
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools …"
  xcode-select --install
  echo "Press <Enter> after the installer finishes."
  read -r
else
  ok "Xcode Command Line Tools already installed"
fi

# ── 2. Nix (Determinate Installer) ───────────────────────────────────
if ! command -v nix &>/dev/null; then
  info "Installing Nix via Determinate Installer …"
  curl --proto '=https' --tlsv1.2 -sSf -L \
    https://install.determinate.systems/nix | sh -s -- install
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
  ok "Nix already installed"
fi

# ── 3. Homebrew ───────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew …"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  ok "Homebrew already installed"
fi

# ── 4. Back up /etc shell files to avoid nix-darwin hash mismatch ────
for f in /etc/bashrc /etc/zshrc; do
  if [ -f "$f" ] && [ ! -L "$f" ]; then
    warn "Backing up $f → ${f}.before-nix-darwin"
    sudo mv "$f" "${f}.before-nix-darwin"
  fi
done

# ── 5. Ensure newly added files are visible to the flake ─────────────
info "Staging all files for Nix flake evaluation …"
git add -A

# ── 6. First nix-darwin build ────────────────────────────────────────
info "Running darwin-rebuild switch (this may take a while) …"
sudo -H nix --extra-experimental-features "nix-command flakes" \
  run github:nix-darwin/nix-darwin/master#darwin-rebuild -- \
  switch --flake ".#${HOSTNAME}"

ok "Bootstrap complete!"

# ── Post-bootstrap: manual steps checklist ───────────────────────────
echo ""
printf '\033[1;35m╔══════════════════════════════════════════════════════════════╗\033[0m\n'
printf '\033[1;35m║            Remaining Manual Steps                            ║\033[0m\n'
printf '\033[1;35m╚══════════════════════════════════════════════════════════════╝\033[0m\n'
echo ""
warn "1. Grant Accessibility permissions (System Settings → Privacy & Security):"
echo "     - yabai"
echo "     - skhd"
echo ""
warn "2. Create local config files (not tracked by git):"
echo "     - ~/.config/git/local.gitconfig   (name, email, signing key)"
echo "     - ~/.ssh/config.local             (private host entries)"
echo "     - ~/.config/zsh-local/common.zsh  (machine-specific overrides)"
echo ""
warn "3. Copy SSH keys to ~/.ssh/ and set permissions:"
echo "     chmod 700 ~/.ssh && chmod 600 ~/.ssh/id_*"
echo ""
warn "4. Log in to applications:"
echo "     - Google Chrome"
echo "     - VS Code (Settings Sync)"
echo ""
warn "5. Optional: install additional tools not managed by Nix:"
echo "     - Bitwarden CLI (for nvim GPT plugin API key)"
echo ""
echo "Starting a fresh login shell …"
exec zsh -l
