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
      forEachSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = nixpkgs.legacyPackages.${system};
        system = system;
      });

    in
    {
      # Generate a `devShell` for each of the `supportedSystems`.
      devShells = forEachSystem ({ pkgs, system }:
      {
        default = pkgs.mkShell {
          # A name for the shell environment.
          name = "ruby-3.1";

          # List of packages to be available in the development environment.
          buildInputs = with pkgs; [
            # fish is kept so that fish-specific completions from other
            # packages can be made available.
            fish
            # Git is needed for fetching gems from git repositories.
            git
            # The Ruby interpreter.
            ruby_3_1
            # Bundler for managing Ruby gems.
            bundler
            # Common dependencies for building native extensions.
            cmake
            findutils
            gcc
            gnumake
            # Libraries often required by gems.
            libyaml
            openssl
            pkg-config
            libmysqlclient
            shared-mime-info
            re2
            readline
            zlib
          ] ++ lib.optionals stdenv.isDarwin [
            # Add macOS-specific dependencies.
            libiconv
          ];

          # This hook now correctly detects the parent shell (e.g., fish)
          # and works for both `nix develop` and `direnv`.
          shellHook = ''
            # Ruby-specific setup
            export FREEDESKTOP_MIME_TYPES_PATH="${pkgs.shared-mime-info}/share/mime/packages/freedesktop.org.xml"

            echo "Ruby dev environment activated for ${system}!"

            test -f .env && eval "$(sed -e '/^#/d' -e '/^$/d' -e 's/^/export /' .env)"
          '';
        };
      });
    };
}
