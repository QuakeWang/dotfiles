{
  config,
  lib,
  pkgs,
  self,
  darwinSetEnvironment,
  ...
}:
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
    "zsh/zsh-autosuggestions".source = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
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
    "Library/Application Support/Code/User/settings.json".source = sourcePath "vscode/setting.json";
  };

  home.activation.batCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -x "${pkgs.bat}/bin/bat" ]; then
      ${pkgs.bat}/bin/bat cache --build >/dev/null 2>&1 || true
    fi
  '';

  home.activation.windowStackRefresh = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    state_dir="${config.home.homeDirectory}/.local/state/dotfiles/window-stack"
    uid="$(/usr/bin/id -u)"
    gui_domain="gui/$uid"

    if /bin/launchctl print "$gui_domain" >/dev/null 2>&1; then
      /bin/mkdir -p "$state_dir"

      refresh_service_if_target_changed() {
        link_path="$1"
        state_file="$2"
        service_target="$3"

        if [ ! -L "$link_path" ]; then
          return 0
        fi

        current_target="$(/usr/bin/readlink "$link_path")"
        previous_target=""

        if [ -f "$state_file" ]; then
          previous_target="$(/bin/cat "$state_file")"
        fi

        if [ "$current_target" = "$previous_target" ]; then
          return 0
        fi

        printf '%s' "$current_target" > "$state_file"
        /bin/launchctl kickstart -k "$service_target" >/dev/null 2>&1 || true
      }

      refresh_service_if_target_changed \
        "${config.home.homeDirectory}/.config/sketchybar" \
        "$state_dir/sketchybar.target" \
        "$gui_domain/org.nixos.sketchybar"

      refresh_service_if_target_changed \
        "${config.home.homeDirectory}/.config/skhd/skhdrc" \
        "$state_dir/skhdrc.target" \
        "$gui_domain/org.nixos.skhd"

      refresh_service_if_target_changed \
        "${config.home.homeDirectory}/.config/yabai/yabairc" \
        "$state_dir/yabairc.target" \
        "$gui_domain/org.nixos.yabai"
    fi
  '';
}
