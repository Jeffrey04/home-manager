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
    gemini-cli
    kind
    kubectl
    kubernetes-helm
    openfortivpn
    pinentry_mac
  ];

  home.extraOutputsToInstall = mac.home.extraOutputsToInstall;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = lib.attrsets.recursiveUpdate mac.home.file {
    ".local/bin/ib-vpn" = {
      executable = true;
      text = ''
      #!/usr/bin/env bash
      sudo openfortivpn -c $HOME/Projects/ib-vpn/config
      '';
    };
  };

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
  home.sessionVariables = mac.home.sessionVariables;

  home.shellAliases = mac.home.shellAliases;

  home.sessionPath = mac.home.sessionPath;

  programs = mac.programs;
}