{
  lib,
  pkgs,
  region,
  ...
}:
let
  software = import ../shared/software.nix {
    inherit lib pkgs;
  };
  homebrewEnv = ''
    HOMEBREW_NO_ANALYTICS=1
  ''
  + lib.optionalString (region == "cn") ''
    HOMEBREW_API_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api
    HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
    HOMEBREW_BREW_GIT_REMOTE=https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
    HOMEBREW_CORE_GIT_REMOTE=https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
  '';
in
{
  environment.etc."homebrew/brew.env".text = homebrewEnv;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "none";
      upgrade = false;
    };
    taps = [
      "felixkratz/formulae"
      "graykode/tap"
      "koekeishiya/formulae"
    ];
    brews = software.brew;
    casks = software.cask;
  };
}
