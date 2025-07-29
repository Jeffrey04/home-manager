{
  description = "Home Manager configuration of jeffrey04";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    {
      packages.x86_64-linux.homeConfigurations."jeffrey04" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./ubuntu.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
      packages.x86_64-darwin.homeConfigurations."jeffrey04@wukong" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-darwin;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./wukong.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
      packages.x86_64-darwin.homeConfigurations."jeffrey04@gian.local" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-darwin;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./mac.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
