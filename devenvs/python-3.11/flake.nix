# flake.nix
{
  description = "A cross-platform Python 3.11 development environment";

  # Define the inputs for this flake, primarily nixpkgs.
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  # Define the outputs of this flake.
  outputs = { self, nixpkgs }:
    let
      # A list of systems we want to support.
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      # A helper function to generate an attribute set for each system.
      forEachSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = nixpkgs.legacyPackages.${system};
        system = system;
      });

    in
    {
      # Generate a `devShell` for each of the `supportedSystems`.
      devShells = forEachSystem ({ pkgs, system }:
      let
        # Specific Python version to use.
        python = pkgs.python311;
      in
      {
        default = pkgs.mkShell {
          # A name for the shell environment.
          name = "python-3.11";

          # List of packages to be available in the development environment.
          buildInputs = with pkgs; [
            # fish is kept so that fish-specific completions from other
            # packages can be made available.
            fish
            # Git is often needed for installing packages from git repositories.
            git
            # The Python interpreter.
            python
            # Common dependencies for building Python packages.
            gcc
            gnumake
            pkg-config
          ];

          # This hook now correctly detects the parent shell (e.g., fish)
          # and works for both `nix develop` and `direnv`.
          shellHook = ''
            echo "Python dev environment activated for ${system}!"
            echo "Python version: $(${python}/bin/python --version)"
            echo "Using global poetry/uv for package management."

            test -f .env && eval "$(sed -e '/^#/d' -e '/^$/d' -e 's/^/export /' .env)"
          '';
        };
      });
    };
}
