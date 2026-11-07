{ pkgs, username, ... }:
let
  brewPrefix = if pkgs.stdenv.hostPlatform.isAarch64 then "/opt/homebrew" else "/usr/local";
  brewBin = "${brewPrefix}/bin";
  brewOpt = "${brewPrefix}/opt";
  homeDir = "/Users/${username}";
  configDir = "${homeDir}/.config";
  launchdPath = builtins.concatStringsSep ":" [
    "${homeDir}/.nix-profile/bin"
    "/etc/profiles/per-user/${username}/bin"
    "/run/current-system/sw/bin"
    "/nix/var/nix/profiles/default/bin"
    brewBin
    "${brewOpt}/sketchybar/bin"
    "${brewOpt}/borders/bin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
  ];
in
{
  # SIP stays enabled; run yabai without a privileged scripting-addition loader.
  launchd.user.agents.yabai = {
    serviceConfig.ProgramArguments = [
      "${brewBin}/yabai"
      "-c"
      "${configDir}/yabai/yabairc"
    ];
    serviceConfig.KeepAlive = true;
    serviceConfig.RunAtLoad = true;
    serviceConfig.EnvironmentVariables = {
      PATH = launchdPath;
    };
    managedBy = "dotfiles.window-stack.yabai";
  };

  launchd.user.agents.skhd = {
    serviceConfig.ProgramArguments = [
      "${brewBin}/skhd"
      "-c"
      "${configDir}/skhd/skhdrc"
    ];
    serviceConfig.KeepAlive = true;
    serviceConfig.ProcessType = "Interactive";
    serviceConfig.RunAtLoad = true;
    serviceConfig.EnvironmentVariables = {
      PATH = launchdPath;
    };
    managedBy = "dotfiles.window-stack.skhd";
  };

  launchd.user.agents.sketchybar = {
    serviceConfig.ProgramArguments = [
      "${brewOpt}/sketchybar/bin/sketchybar"
      "--config"
      "${configDir}/sketchybar/sketchybarrc"
    ];
    serviceConfig.KeepAlive = true;
    serviceConfig.RunAtLoad = true;
    serviceConfig.EnvironmentVariables = {
      LANG = "en_US.UTF-8";
      PATH = launchdPath;
    };
    managedBy = "dotfiles.window-stack.sketchybar";
  };

  launchd.user.agents.jankyborders = {
    serviceConfig.ProgramArguments = [
      "${brewOpt}/borders/bin/borders"
      "width=3.0"
      "active_color=0xffe1e3e4"
      "inactive_color=0xff494d64"
    ];
    serviceConfig.KeepAlive = true;
    serviceConfig.RunAtLoad = true;
    serviceConfig.EnvironmentVariables = {
      PATH = launchdPath;
    };
    managedBy = "dotfiles.window-stack.jankyborders";
  };
}
