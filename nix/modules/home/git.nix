{ config, ... }:
{
  programs.git = {
    enable = true;
    includes = [
      {
        path = "${config.home.homeDirectory}/.config/git/local.gitconfig";
      }
    ];
    ignores = [
      ".DS_Store"
      "*.swp"
    ];
    settings = {
      core.editor = "nvim";
      push.default = "current";
      push.autoSetupRemote = true;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
