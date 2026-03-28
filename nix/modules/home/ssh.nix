{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [
      "${config.home.homeDirectory}/.ssh/config.local"
    ];
    matchBlocks."*" = {
      compression = true;
      serverAliveCountMax = 5;
      serverAliveInterval = 30;
    };
  };
}
