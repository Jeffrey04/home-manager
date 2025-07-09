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
          # This provides just the Python interpreter and build tools.
          # Poetry/uv will handle the rest.
          buildInputs = with pkgs; [
            # Add fish to the environment so the shellHook can find it.
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

          # This hook now works correctly for both interactive `nix develop`
          # and non-interactive `direnv` sessions.
          shellHook = ''
            echo "Python dev environment activated for ${system}!"
            echo "Python version: $(${python}/bin/python --version)"
            echo "Using global poetry/uv for package management."

            # This logic makes `nix develop` drop you into your current shell,
            # while remaining compatible with `direnv`.
            # It only runs in an interactive shell, which `direnv`'s is not.
            if [[ "$-" == *i* && -z "$IN_NIX_SHELL" ]]; then
              export IN_NIX_SHELL=1
              echo "Switching to your current shell: $SHELL"
              exec "$SHELL"
            fi
          '';
        };
      });
    };
}
