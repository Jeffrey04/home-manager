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
          name = "ruby-3.3";

          # List of packages to be available in the development environment.
          buildInputs = with pkgs; [
            # fish is kept so that fish-specific completions from other
            # packages can be made available.
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
          ] ++ lib.optionals stdenv.isDarwin [
            # Add macOS-specific dependencies.
            libiconv
          ] ++ lib.optionals stdenv.isLinux [
            # procps is needed for the `ps` command on Linux.
            # gawk is used for robustly parsing the output of ps.
            procps
            gawk
          ];

          # This hook now correctly detects the parent shell (e.g., fish)
          # and works for both `nix develop` and `direnv`.
          shellHook = ''
            # Ruby-specific setup
            export BUNDLE_PATH="${bundlePath}"
            # Set a custom variable for Starship to display.
            # The 'name' variable is set by mkShell.
            export STARSHIP_NIX_PROMPT="($name)"

            echo "Ruby dev environment activated for ${system}!"
            echo "Gems will be installed in: $BUNDLE_PATH"

            # This logic makes `nix develop` drop you into your current shell,
            # while remaining compatible with `direnv`.
            # It checks for a variable that direnv sets when running .envrc.
            if [ -z "$DIRENV_IN_ENVRC" ]; then
              # Find the grandparent process ID (the user's shell) and trim whitespace.
              grandparent_pid=$(ps -o ppid= -p $PPID | xargs)
              # Get the full command of the grandparent process and use awk to get the first word.
              parent_shell_path=$(ps -o command= -p "$grandparent_pid" | awk '{print $1}')
              echo "Switching to your current shell: $parent_shell_path"
              # Execute the shell.
              exec "$parent_shell_path"
            fi
          '';
        };
      });
    };
}
