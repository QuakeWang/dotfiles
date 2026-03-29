{ lib, pkgs, ... }:
let
  software = import ../shared/software.nix {
    inherit lib pkgs;
  };
in
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "none";
      upgrade = false;
    };
    taps = [
      "felixkratz/formulae"
      "koekeishiya/formulae"
    ];
    brews = software.brew;
    casks = software.cask;
  };
}
