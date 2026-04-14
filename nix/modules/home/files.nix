{ config, lib, pkgs, self, darwinSetEnvironment, ... }:
let
  sourcePath = path: self + "/${path}";
in
{
  xdg.enable = true;

  xdg.configFile = {
    "bat/themes".source = sourcePath "bat/themes";
    "btop".source = sourcePath "btop";
    "fastfetch".source = sourcePath "fastfetch";
    "kitty".source = sourcePath "kitty";
    "nvim".source = sourcePath "nvim";
    "sketchybar".source = sourcePath "sketchybar";
    "skhd/skhdrc".source = sourcePath "skhd/skhdrc";
    "starship.toml".source = sourcePath "starship/starship.toml";
    "yabai/yabairc".source = sourcePath "yabai/yabairc";
    "yazi".source = sourcePath "yazi";
    "zsh/regions".source = sourcePath "zsh/regions";
    "zsh/.zshenv".source = sourcePath "zsh/.zshenv";
    "zsh/.zprofile".source = sourcePath "zsh/.zprofile";
    "zsh/.zshrc".source = sourcePath "zsh/.zshrc";
    "zsh/function.zsh".source = sourcePath "zsh/function.zsh";
    "zsh/keymap.zsh".source = sourcePath "zsh/keymap.zsh";
  };

  xdg.dataFile = {
    "zsh/fzf".source = "${pkgs.fzf}/share/fzf";
    "zsh/site-functions".source = "${pkgs.zsh-completions}/share/zsh/site-functions";
    "zsh/zsh-autosuggestions".source =
      "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
    "zsh/zsh-history-substring-search".source =
      "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search";
    "zsh/zsh-syntax-highlighting".source =
      "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
  };

  home.file = {
    ".zshenv".text = ''
      source ${darwinSetEnvironment}
      source $HOME/.config/zsh/.zshenv
    '';
    ".zprofile".text = ''
      # Managed by Home Manager. Keep login-shell logic under ~/.config/zsh.
      source $HOME/.config/zsh/.zprofile
    '';
    ".zshrc".text = ''
      # Managed by Home Manager. Keep interactive-shell logic under ~/.config/zsh.
      source $HOME/.config/zsh/.zshrc
    '';
    ".npmrc".text = ''
      registry=https://registry.npmmirror.com
      prefix=${config.home.homeDirectory}/.local
    '';
    "Library/Application Support/Code/User/settings.json".source =
      sourcePath "vscode/setting.json";
  };

  home.activation.batCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -x "${pkgs.bat}/bin/bat" ]; then
      ${pkgs.bat}/bin/bat cache --build >/dev/null 2>&1 || true
    fi
  '';
}
