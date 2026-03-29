{ lib, pkgs, self, username, region, ... }:
let
  software = import ../shared/software.nix {
    inherit lib pkgs;
  };
in
{
  nixpkgs.config.allowUnfree = true;

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  environment.pathsToLink = [ "/share/zsh" ];
  environment.variables = {
    DOTFILES_REGION = region;
  };
  environment.systemPackages = software.nix;

  programs.zsh = {
    enable = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    dock.autohide = true;
    menuExtraClock.Show24Hour = true;
    spaces.spans-displays = false;

    NSGlobalDomain = {
      _HIHideMenuBar = true;
      # Keyboard: enable key repeat and speed it up
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      # Disable smart substitutions (interferes with coding)
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "clmv";
      FXDefaultSearchScope = "SCcf";
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "@admin"
      username
    ];
  };

  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 3;
      Minute = 15;
    };
    options = "--delete-older-than 30d";
  };

  system.primaryUser = username;
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
}
