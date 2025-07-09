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
          ] ++ lib.optionals stdenv.isLinux [
            # procps is needed for the `ps` command on Linux.
            # gawk is used for robustly parsing the output of ps.
            procps
            gawk
          ];

          # This hook now correctly detects the parent shell (e.g., fish)
          # and works for both `nix develop` and `direnv`.
          shellHook = ''
            # Set a custom variable for Starship to display.
            # The 'name' variable is set by mkShell.
            export STARSHIP_NIX_PROMPT="($name)"

            echo "Python dev environment activated for ${system}!"
            echo "Python version: $(${python}/bin/python --version)"
            echo "Using global poetry/uv for package management."

            # This logic makes `nix develop` drop you into your current shell,
            # while remaining compatible with `direnv`.
            # It checks for the absence of a direnv-specific variable.
            if [ -z "$DIRENV_DIR" ]; then
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
