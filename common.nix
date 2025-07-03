{ pkgs, lib }:

{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  stateVersion = "25.05"; # Please read the comment before changing.

  packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    #vscode-fhs
    rustup
    fnm
    uv

    # utilities
    byobu
    clang
    dogedns
    graphviz
    scrcpy
    xh
    lazydocker

    # libraries
    openssl
    zlib-ng
    bzip2
    readline
    sqlite
    ncurses
    xz
    tcl
    tk
    xml2
    xmlsec
    libffi
    libtool
    libyaml
    libxml2
    libxslt
  ];

  extraOutputsToInstall = [ "dev" "lib" ];

  file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".local/bin/ssh-ident" = {
      source = ./configurations/.local/bin/ssh-ident;
      executable = true;
    };

    ".byobu/.tmux.conf" = {
      source = ./configurations/.byobu/.tmux.conf;
    };

    # nvim custom plugins
    ".local/share/nvim" = {
      source = ./configurations/.local/share/nvim;
      recursive = true;
    };
    ".local/share/nvim/site/pack/rainbow_csv/start/rainbow_csv" = {
      source = builtins.fetchGit {
        url = https://github.com/mechatroner/rainbow_csv;
        rev= "3dbbfd7d17536aebfb80f571255548495574c32b";
      };
      recursive = true;
    };
  };

  sessionVariables = {
    # EDITOR = "emacs";
    VISUAL = "nvim";

    PYTHON_CONFIGURE_OPTS = "--enable-loadable-sqlite-extensions --enable-shared";
    PYTHONBREAKPOINT = "ipdb.set_trace";
  };

  shellAliases = {
    cat = "$HOME/.nix-profile/bin/bat";
    dig = "$HOME/.nix-profile/bin/doge";
    http = "$HOME/.nix-profile/bin/xh";
    ssh = "$HOME/.local/bin/ssh-ident";
  };

  sessionPath = [
    "$HOME/.local/bin"
  ];

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    neovim = {
      enable = true;

      defaultEditor = true;
      extraConfig = lib.strings.fileContents ./configurations/.config/nvim/init.vim;

      plugins = with pkgs.vimPlugins; [
        base16-nvim
        deoplete-nvim
        deoplete-go
        deoplete-jedi
        rainbow_parentheses-vim
        vim-airline
        vim-airline-themes
        vim-css-color
        delimitMate
        vim-fugitive
        golden-ratio
        VimCompletesMe
        vim-vinegar
      ];

      viAlias = true;
      vimAlias = true;

      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = false;
      enableFishIntegration = true;
      settings = {
        add_newline = false;

        character = {
          success_symbol = "[\\[I\\]](bold bg:green fg:black) ";
          error_symbol = "[\\[▲\\]](bold bg:red fg:black) ";
          vicmd_symbol = "[\\[N\\]](bold bg:red fg:black) ";
        };

        cmd_duration = {
          disabled = true;
        };

        hostname = {
          format = "[$hostname]($style):";
          ssh_only = false;
        };

        line_break = {
          disabled = true;
        };

        username = {
          format = "[$user]($style)@";
          show_always = true;
        };

        custom.direnv = {
          ignore_timeout = true;
          format = "[\\[direnv\\]]($style) ";
          style = "fg:yellow dimmed";
          when = "env | grep -E '^DIRENV_DIFF='";
        };
      };
    };

    pyenv = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    rbenv = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      plugins = [
        {
          name = "ruby-build";
          src = pkgs.fetchFromGitHub {
            owner = "rbenv";
            repo = "ruby-build";
            rev = "v20241007";
            hash = "sha256-R66O4EeVZqznKA9p0uFCfVpeUUf4tKjjncGnIKJwoBs=";
          };
        }
      ];
    };

    zoxide = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;

      options = [ "--cmd cd" ];
    };

    bat = {
      enable = true;
    };

    lsd = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    go = {
      enable = true;
      goPath = ".go";
    };

    poetry = {
      enable = true;
      settings = {
        virtualenvs.prefer-active-python = true;
      };
    };

    nix-index = {
      enable = true;

      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    bash = {
      enable = true;

      profileExtra = ''
        # Ubuntu make installation of Ubuntu Make binary symlink
        PATH=/home/jeffrey04/.local/share/umake/bin:$PATH
      '';


      initExtra = ''
        # rust
        PATH=/home/jeffrey04/.cargo/bin:$PATH

        # node
        eval "$(fnm env --use-on-cd)"
        export FNM_COREPACK_ENABLED=true
        export FNM_VERSION_FILE_STRATEGY=recursive
      '';
    };

    fish = {
      enable = true;

      shellInit = ''
        fish_vi_key_bindings

        # rust
        set -Ua fish_user_paths $HOME/.cargo/bin

        # node
        fnm env --use-on-cd | source
        set -Ux FNM_COREPACK_ENABLED true
        set -Ux FNM_VERSION_FILE_STRATEGY recursive
      '';
    };

    tmux = {
      enable = true;
    };
  };
}
