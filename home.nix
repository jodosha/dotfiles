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
      pkgs.lua-language-server  # Lua LSP for NeoVim (lua_ls)
      pkgs.nerd-fonts.hack
      pkgs._1password-cli
      pkgs.tmux
      pkgs.nodejs_22
      pkgs.claude-code
      pkgs.codex
      pkgs.mkcert
      pkgs.uv
      pkgs.git-cliff
      pkgs.nixfmt
      pkgs.yq
      pkgs.graphviz
      pkgs.github-copilot-cli
      pkgs.cargo              # needed to install tree-sitter-cli >= 0.26.1
      pkgs.lazygit            # git TUI for snacks.lazygit + astronvim
      pkgs.fd                 # fast file finder for snacks.picker
      pkgs.gdu                # disk usage analyzer for astronvim
      pkgs.bottom             # system monitor (btm) for astronvim
      pkgs.wget               # alternative downloader for mason
      pkgs.shellcheck         # shell script linter for claude-code
      pkgs.difftastic         # structural, language-aware diffs for claude-code
      pkgs.tokei              # codebase composition stats for claude-code
      pkgs.ast-grep           # structural code search/refactoring for claude-code
      pkgs.hyperfine          # statistical benchmarking for claude-code
      pkgs.typos              # source code spell checker for claude-code
      pkgs.watchexec          # file watcher for claude-code
      pkgs.bat                # syntax-highlighted file viewing for claude-code
      pkgs.delta              # enhanced git diffs for claude-code
      pkgs.scc                # codebase composition stats for claude-code
      pkgs.difftastic         # structural, language-aware diffs for claude-code
    ];

    file.".ssh/config".source = ./misc/ssh;
    file.".config/ghostty/config".source = ./misc/ghostty;
    file.".tmuxrc".source = ./misc/tmuxrc;

    file.".local/bin" = {
      source = ./bin;
      recursive = true;
    };

    file.".config/nvim" = {
      source = ./nvim;
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
    antidote = {
      enable = true;
      plugins = [
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-completions"
        "zsh-users/zsh-syntax-highlighting"
      ];
    };
    localVariables = {
      PS1 = "%(?.%F{green}❯%f.%F{red}❯%f) ";
    };
    initContent = ''
      function git_current_branch() {
        git rev-parse --abbrev-ref HEAD
      }

      function git_main_branch() {
        git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|origin/||'
      }

      function gnotify () {
        local title="''${1:-Done}"
        local body="''${2:-}"
        if [ -n "$TMUX" ]; then
          printf '\033Ptmux;\033\033]777;notify;%s;%s\007\033\\' "$title" "$body"
        else
          printf '\033]777;notify;%s;%s\007' "$title" "$body"
        fi
      }

      function notifyrun () {
        local label="$1"; shift
        "$@"
        local ec=$?
        gnotify "$label" "done (exit=$ec)"
        return $ec
      }

      function bnotifyrun () {
        local label="$1"; shift
        ("$@"; gnotify "$label" "done (exit=$?)") &
        disown
      }

      function watchpr () {
        local pr_number
        pr_number=$(gh pr view --json number -q '.number' 2>/dev/null)
        if [ -z "$pr_number" ]; then
          echo "No PR found for the current branch"
          return 1
        fi

        local repo
        repo=$(gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null)
        local label="''${repo}#''${pr_number}"

        bnotifyrun "$label" _watchpr_poll "$pr_number"
        echo "Watching checks for $label in background"
      }

      function _watchpr_poll () {
        local pr_number="$1"
        while true; do
          local output
          output=$(gh pr checks "$pr_number" --json=bucket,state 2>/dev/null)

          local pending
          pending=$(echo "$output" | jq '[.[] | select(.state != "SUCCESS" and .state != "NEUTRAL" and .state != "SKIPPED")] | length')

          if [ "$pending" = "0" ]; then
            return 0
          fi

          local failed
          failed=$(echo "$output" | jq '[.[] | select(.state == "FAILURE" or .state == "ERROR" or .state == "CANCELLED")] | length')

          if [ "$failed" != "0" ]; then
            return 1
          fi

          sleep 60
        done
      }
    '';
    shellAliases = {
      ll = "ls -l";
      nr = "notifyrun";
      bnr = "bnotifyrun";
      dnsflush="dscacheutil -flushcache";
      rebuild="sudo darwin-rebuild switch";
      nix-upgrade="nix flake update && sudo darwin-rebuild switch --flake";
      nix-remote-builder="nix run nixpkgs#darwin.linux-builder";
      nix-gc="nix-collect-garbage -d";

      # Git
      ga="git add";
      gb="git branch";
      gco="git checkout";
      gp="git push origin $(git_current_branch)";
      gpb="git push -u origin $(git_current_branch)";
      gs="git status";
      gaa="git add --all";
      gc="git commit --verbose";
      gca="git commit --amend --date=\"$(date)\"";
      wip="gaa && gca -m 'WIP'";
      gsh="git show HEAD";
      gd="git diff";
      grev="git diff master";
      ggpull="git pull --rebase origin $(git_current_branch)";
      glo="git log --oneline --decorate";
      gcm="git checkout $(git_main_branch)";

      # Ruby
      be="bundle exec";
      ber="bundle exec rake";
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

      # Allow escape sequences (e.g. OSC 777 notifications) to pass through to Ghostty
      set -g allow-passthrough on

      # Clear screen (preserving scrollback history) via Cmd+k
      bind-key K send-keys C-l
    '';
  };
}
