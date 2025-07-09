# flake.nix
{
  description = "A cross-platform Ruby development environment";

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
      # This avoids repeating the shell definition for each system.
      forEachSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = nixpkgs.legacyPackages.${system};
        system = system;
      });

    in
    {
      # Generate a `devShell` for each of the `supportedSystems`.
      devShells = forEachSystem ({ pkgs, system }:
      let
        # Define the bundle path based on the OS.
        bundlePath =
          if pkgs.stdenv.isDarwin then
            "$HOME/Library/Caches/ruby-bundle"
          else
            "$HOME/.cache/ruby-bundle";
      in
      {
        default = pkgs.mkShell {
          # A name for the shell environment.
          name = "ruby-dev-shell";

          # List of packages to be available in the development environment.
          buildInputs = with pkgs; [
            # Add fish to the environment so the shellHook can find it.
            fish
            # Git is needed for fetching gems from git repositories.
            git
            # The Ruby interpreter.
            ruby
            # Bundler for managing Ruby gems.
            bundler
            # Common dependencies for building native extensions.
            gcc
            gnumake
            # Libraries often required by gems.
            openssl
            pkg-config
            readline
            zlib
            re2
          ] ++ lib.optionals stdenv.isDarwin [
            # Add macOS-specific dependencies.
            libiconv
          ];

          # This hook runs in bash when the dev shell is activated.
          shellHook = ''
            # Set environment variables using bash syntax.
            export BUNDLE_PATH="${bundlePath}"
            echo "Ruby dev environment activated for ${system}!"
            echo "Gems will be installed in: $BUNDLE_PATH"

            # This logic checks if we're already in fish, and if not,
            # it replaces the current bash process with fish.
            if [ -z "$IN_NIX_SHELL_FISH" ]; then
              export IN_NIX_SHELL_FISH=1
              echo "Switching to fish shell..."
              exec fish
            fi
          '';
        };
      });
    };
}
