{ lib, pkgs, ... }:
let
  shell = {
    git = {
      source = "nix";
      package = "git";
    };
    zsh = {
      source = "nix";
      package = "zsh";
    };
  };

  terminal = {
    atuin = {
      source = "nix";
      package = "atuin";
    };
    bat = {
      source = "nix";
      package = "bat";
    };
    btop = {
      source = "nix";
      package = "btop";
    };
    dust = {
      source = "nix";
      package = "dust";
    };
    eza = {
      source = "nix";
      package = "eza";
    };
    fastfetch = {
      source = "nix";
      package = "fastfetch";
    };
    fd = {
      source = "nix";
      package = "fd";
    };
    fzf = {
      source = "nix";
      package = "fzf";
    };
    jq = {
      source = "nix";
      package = "jq";
    };
    ripgrep = {
      source = "nix";
      package = "ripgrep";
    };
    starship = {
      source = "nix";
      package = "starship";
    };
    tree = {
      source = "nix";
      package = "tree";
    };
    wget = {
      source = "nix";
      package = "wget";
    };
    yazi = {
      source = "nix";
      package = "yazi";
    };
    zoxide = {
      source = "nix";
      package = "zoxide";
    };
  };

  development = {
    gh = {
      source = "nix";
      package = "gh";
    };
    lazygit = {
      source = "nix";
      package = "lazygit";
    };
    neovim = {
      source = "nix";
      package = "neovim";
    };
    nil = {
      source = "nix";
      package = "nil";
    };
    nixfmt = {
      source = "nix";
      package = "nixfmt";
    };
    prettier = {
      source = "nix";
      package = "prettier";
    };
    nodejs = {
      source = "nix";
      package = "nodejs_24";
    };
  };

  homebrewFormulae = {
    borders = {
      source = "brew";
    };
    sketchybar = {
      source = "brew";
    };
    skhd = {
      source = "brew";
    };
    "switchaudio-osx" = {
      source = "brew";
    };
    yabai = {
      source = "brew";
    };
  };

  applications = {
    "google-chrome" = {
      source = "cask";
    };
    kitty = {
      source = "cask";
    };
    "visual-studio-code" = {
      source = "cask";
    };
  };

  fonts = {
    "font-fira-code" = {
      source = "cask";
    };
    "font-hack-nerd-font" = {
      source = "cask";
    };
    "font-sf-mono" = {
      source = "cask";
    };
    "font-symbols-only-nerd-font" = {
      source = "cask";
    };
    "sf-symbols" = {
      source = "cask";
    };
  };

  inventory =
    shell
    // terminal
    // development
    // homebrewFormulae
    // applications
    // fonts;

  resolvePackage = package:
    lib.attrByPath
      (lib.splitString "." package)
      (throw "Nix package '${package}' was not found in pkgs")
      pkgs;

  grouped = builtins.groupBy
    (name: inventory.${name}.source)
    (builtins.attrNames inventory);
in
{
  nix = map (name: resolvePackage inventory.${name}.package) (grouped.nix or [ ]);
  brew = grouped.brew or [ ];
  cask = grouped.cask or [ ];
}
