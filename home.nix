# home-manager switch

{ config, pkgs, ...}:

{
  home = {
    username = "jodosha";
    homeDirectory = "/Users/jodosha";
    stateVersion = "24.11";

    packages = [
      pkgs.binutils
      pkgs.gnupg
      pkgs.oh-my-zsh
      pkgs.xz
      pkgs.tree
      pkgs.squashfsTools
      pkgs.git
      pkgs.gh
      pkgs.bc
      pkgs.jq
      pkgs.neovim
      pkgs.ripgrep
      pkgs.luarocks
      pkgs.nerd-fonts.hack
      pkgs._1password-cli
      pkgs.tmux
      pkgs.devenv
      pkgs.nodejs_22
      pkgs.claude-code
      pkgs.codex
      pkgs.mkcert
      pkgs.uv
      pkgs.git-cliff
      pkgs.nixfmt
      pkgs.yq
      pkgs.github-copilot-cli
      pkgs.cargo              # needed to install tree-sitter-cli >= 0.26.1
      pkgs.lazygit            # git TUI for snacks.lazygit + astronvim
      pkgs.fd                 # fast file finder for snacks.picker
      pkgs.gdu                # disk usage analyzer for astronvim
      pkgs.bottom             # system monitor (btm) for astronvim
      pkgs.wget               # alternative downloader for mason
    ];

    # https://github.com/nix-community/home-manager/issues/761
    file.".cache/oh-my-zsh/themes/jodosha.zsh-theme".source = ./misc/omz.zsh-theme;
    file.".ssh/config".source = ./misc/ssh;
    file.".config/ghostty/config".source = ./misc/ghostty;
    file.".tmuxrc".source = ./misc/tmuxrc;

    file.".local/bin" = {
      source = ./bin;
      recursive = true;
    };

    sessionVariables = {
      TERM = "xterm-256color";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.cargo/bin"
    ];
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    shellAliases = {
      ll = "ls -l";
      dnsflush="dscacheutil -flushcache";
      rebuild="sudo darwin-rebuild switch";
      nix-upgrade="nix flake update && sudo darwin-rebuild switch --flake";
      nix-remote-builder="nix run nixpkgs#darwin.linux-builder";

      # Git
      gp="git push origin $(git_current_branch)";
      gpb="git push -u origin $(git_current_branch)";
      gs="git status";
      gaa="git add --all";
      gc="git commit";
      gca="git commit --amend --date=\"$(date)\"";
      wip="gaa && gca -m 'WIP'";
      gsh="git show HEAD";
      gd="git diff";
      grev="git diff master";
      ggpull="git pull --rebase";

      # Ruby
      be="bundle exec";
      ber="bundle exec rake";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "git-flow"
      ];
      custom = "$HOME/.cache/oh-my-zsh/";
      theme = "jodosha";
    };
  };

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Luca Guidi";
        email = "me@lucaguidi.com";
      };
      core = {
        editor = "nvim";
      };
      init = {
        defaultBranch = "main";
      };
      gpg = {
        format = "ssh";
      };
      signing = {
        signByDefault = true;
        key = "/Users/jodosha/.ssh/github";
      };
    };

    ignores = [
      "*devenv*"
      ".direnv"
      ".claude"
      ".pre-commit-config.yaml"
    ];
  };

  programs.gh = {
    enable = true;
    settings.editor = "nvim";
    extensions = [
      pkgs.gh-dash
    ];
  };

  programs.tmux = {
    enable = true;
    focusEvents = true;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    baseIndex = 1;
    escapeTime = 0;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.tokyo-night-tmux;
        extraConfig = ''
          set -g @tokyo-night-tmux_transparent 0
          set -g @tokyo-night-tmux_show_datetime 0
          set -g @tokyo-night-tmux_show_git 1
          set -g @tokyo-night-tmux_show_wbg 0
        '';
      }
      tmuxPlugins.vim-tmux-navigator
    ];
    prefix = "C-f";
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";
    clock24 = true;
    extraConfig = ''
      # True color for NeoVim
      set -ga terminal-overrides ",xterm-256color:Tc"

      # C-f C-f switches between the last two windows
      bind-key C-f last-window
      bind-key 'f' last-pane

      # Navigate windows with arrows
      bind-key -n 'S-right' next-window
      bind-key -n 'S-left' previous-window
      bind-key -n 'M-right' next-window
      bind-key -n 'M-left' previous-window

      # Respawn dead pane
      bind-key C-l respawn-pane -k
      unbind-key l

      set -g status-style bg=default
      set -g status-left-length 90
      set -g status-right-length 90
      set -g status-justify centre
      set -g status-position top
    '';
  };
}
