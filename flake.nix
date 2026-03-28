{
  description = "Personal macOS dotfiles managed with Nix, Home Manager, and nix-darwin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      username = "wangerxi";
      region = "cn";
      system = "aarch64-darwin";
    in
    {
      darwinConfigurations.erxis-macbook-pro = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit self username region;
        };
        modules = [
          ./nix/modules/darwin/base.nix
          ./nix/modules/darwin/homebrew.nix
          ./nix/modules/darwin/services.nix
          home-manager.darwinModules.home-manager
          ({ config, ... }: {
            nixpkgs.hostPlatform = system;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = {
              inherit username;
              darwinSetEnvironment = config.system.build.setEnvironment;
            };
            home-manager.users.${username} = import ./nix/modules/home;
          })
        ];
      };

      formatter = {
        "${system}" = nixpkgs.legacyPackages.${system}.nixfmt;
      };
    };
}
