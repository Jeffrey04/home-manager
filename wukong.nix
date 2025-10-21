{ config, pkgs, lib, ... }:
let
  mac = import ./mac.nix {config=config; pkgs=pkgs; lib=lib;};
in {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "code"
      "vscode"
    ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "jeffrey04";
  home.homeDirectory = "/Users/jeffrey04";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = mac.home.stateVersion; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; mac.home.packages ++ [
    colima
    docker
    docker-buildx
    docker-compose
    docker-credential-helpers
    kind
    kubectl
    kubectx
    kubernetes-helm
    openfortivpn
    oras
    pinentry_mac
    watchman

    (writeShellScriptBin "colima-start" ''
    #!/usr/bin/env bash
    eval `ssh-agent -s`
    ssh-add $HOME/.ssh/identities/work/id_ib
    colima start --cpu 4 --memory 8 --disk 30 --vm-type=vz --mount-type=virtiofs --ssh-agent
    '')
    (writeShellScriptBin "ib-vpn" ''
    #!/usr/bin/env bash
    sudo openfortivpn -c $HOME/Projects/ib-vpn/config
    '')
    (writeShellScriptBin "gemini" ''
    #!/usr/bin/env bash
    fnm install lts-latest; fnm exec --using=lts-latest npx -y https://github.com/google-gemini/gemini-cli "$@"
    '')
  ];

  home.extraOutputsToInstall = mac.home.extraOutputsToInstall;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = mac.home.file;

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jeffrey04/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = mac.home.sessionVariables // {
    COMPOSE_PARALLEL_LIMIT = 0;
  };

  home.shellAliases = mac.home.shellAliases //  {
    k = "$HOME/.nix-profile/bin/kubectl";
  };

  home.sessionPath = mac.home.sessionPath;

  programs = lib.attrsets.recursiveUpdate mac.programs {
    bash.profileExtra = ''
      test -f "${config.home.homeDirectory}/.config/user-secrets" && eval "$(sed -e '/^#/d' -e '/^$/d' -e 's/^/export /' ${config.home.homeDirectory}/.config/user-secrets)"
    '';

    zed-editor = {
      enable = true;
      extensions = [
        "ruby"
      ];

      userSettings = {
        languages = {
          Ruby = {
            language_servers = [
              "solargraph"
              "!ruby-lsp"
            ];
          };
        };

        lsp = {
          solargraph = {
            settings = {
              use_bundler = false;
            };
          };
        };
      };
    };
  };
}
