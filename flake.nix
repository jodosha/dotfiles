{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.colima
          pkgs.docker
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Suggested by `devenv` for remote builders
      nix.settings.trusted-users = ["root" "jodosha"];

      # https://nixos.org/manual/nixpkgs/unstable/#sec-darwin-builder
      #
      # Run with:
      #
      #   ```
      #   $ nix run nixpkgs#darwin.linux-builder
      #   ```
      nix.settings.builders = "ssh-ng://builder@linux-builder aarch64-linux /etc/nix/builder_ed25519 4 - - - c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=";

      # Not strictly necessary, it reduces disk utilization
      nix.settings.builders-use-substitutes = true;

      # Allows to build Linux packages.
      nix.linux-builder = {
        enable = true;
        ephemeral = true;
        maxJobs = 4;
        config = {
          virtualisation = {
            darwin-builder = {
              diskSize = 40 * 1024;
              memorySize = 8 * 1024;
              hostPort = 22022;
            };
            cores = 6;
          };
        };
      };

      # Pre-built binaries for `devenv`
      nix.extraOptions = ''
        extra-substituters = https://devenv.cachix.org
        extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
      '';

      # Allow non-free software (`gh` by GitHub)
      nixpkgs.config.allowUnfree = true;

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Touch ID for sudo password
      security.pam.services.sudo_local = {
        touchIdAuth = true;
        reattach = true; # needed for Tmux sessions
      };

      # For Home Manager
      users.users.jodosha.home = "/Users/jodosha";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#kamado
    darwinConfigurations."kamado" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
	      home-manager.darwinModules.home-manager {
	        home-manager.useGlobalPkgs = true;
	        home-manager.useUserPackages = true;
	        home-manager.users.jodosha = import ./home.nix;
	      }
      ];
    };
  };
}
