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
  # nix-darwin already knows the stock macOS shell files plus several
  # official/Determinate installer variants. Keep only extra installer hashes
  # we have actually observed but that are not yet covered upstream.
  #
  # If a fresh machine still fails with a "/etc/... hash mismatch", run:
  #   shasum -a 256 /etc/bashrc /etc/zshrc
  # and append the reported installer hashes below.
  environment.etc."bashrc".knownSha256Hashes = [
    "8b5e3466922d1ae34bc145e21c7e53e7329a7a7b58b148b436bd954d5e651ac3" # official Nix installer 2.34.4
  ];
  environment.etc."zshrc".knownSha256Hashes = [
    "af60f7af4a5b4c1b0efe950e3e3f3ee8b136834ecb46fd7dba76f4b66adbc3e1" # official Nix installer 2.34.4
  ];

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
