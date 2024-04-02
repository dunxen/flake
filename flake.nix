{
  description = "dunxen's Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/0.1.9.tar.gz";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # firefox = {
    #   url = "github:nix-community/flake-firefox-nightly";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    helix-master = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-cosmic, home-manager, fh, hyprland, /* firefox, */ helix-master }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      overlays.default = final: prev: {
        # Add overlays
        # myFancyOverlay = final.callPackage ./packages/myFancyOverlay { };
      };

      packages = forAllSystems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
              config.allowUnfree = true;
            };
          in
          {
            inherit (pkgs);

            # Excluded from overlay deliberately to avoid people accidently importing it.
            unsafe-bootstrap = pkgs.callPackage ./packages/unsafe-bootstrap { };
          });

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      devShells = forAllSystems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            };
          in
          {
            default = pkgs.mkShell
              {
                inputsFrom = with pkgs; [ ];
                buildInputs = with pkgs; [
                  nixpkgs-fmt
                ];
              };
          });

      homeConfigurations = forAllSystems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            };
          in
          {
            dunxen = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                ./home/home.nix
              ];
            };
          }
        );

      nixosConfigurations =
        let
          # Shared config between both the liveimage and real system
          aarch64Base = {
            system = "aarch64-linux";
            modules = with self.nixosModules; [
              ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
              home-manager.nixosModules.home-manager
              traits.overlay
              traits.base
            ];
          };
          x86_64Base = {
            system = "x86_64-linux";
            modules = with self.nixosModules; [
              ({ config = { nix.registry.nixpkgs.flake = nixpkgs; }; })
              {
                environment.systemPackages = [
                  fh.packages.x86_64-linux.default
                  # firefox.packages.x86_64-linux.firefox-nightly-bin
                  helix-master.packages.x86_64-linux.default
                ];
              }
              {
                nix.settings = {
                  substituters = ["https://cosmic.cachix.org/"];
                  trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
                };
              }
              nixos-cosmic.nixosModules.default
              traits.overlay
              traits.base
              services.openssh
            ];
          };
        in
        with self.nixosModules; {
          x86_64IsoImage = nixpkgs.lib.nixosSystem {
            inherit (x86_64Base) system;
            modules = x86_64Base.modules ++ [
              platforms.iso
            ];
          };
          brute = nixpkgs.lib.nixosSystem rec {
            inherit (x86_64Base) system;
            specialArgs = {
              inherit hyprland;
              inherit helix-master;
              inherit system;
              inherit self;
            };
            modules = x86_64Base.modules ++ [
              hyprland.nixosModules.default
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = specialArgs;
              }
              platforms.brute
              traits.machine
              traits.workstation
              traits.headed
              traits.hardened
              traits.gaming
              users.dunxen
            ];
          };
          neon = nixpkgs.lib.nixosSystem rec {
            inherit (x86_64Base) system;
            specialArgs = {
              inherit hyprland;
              inherit helix-master;
              inherit system;
              inherit self;
            };
            modules = x86_64Base.modules ++ [
              hyprland.nixosModules.default
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = specialArgs;
              }
              platforms.neon
              traits.machine
              traits.workstation
              traits.headed
              traits.hardened
              traits.gaming
              users.dunxen
            ];
          };
        };

      nixosModules = {
        platforms.neon = ./platforms/neon.nix;
        platforms.brute = ./platforms/brute.nix;
        platforms.iso = "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";
        traits.overlay = { nixpkgs.overlays = [ self.overlays.default ]; };
        traits.base = ./traits/base.nix;
        traits.machine = ./traits/machine.nix;
        traits.gaming = ./traits/gaming.nix;
        traits.headed = ./traits/headed.nix;
        traits.hardened = ./traits/hardened.nix;
        traits.sourceBuild = ./traits/source-build.nix;
        services.openssh = ./services/openssh.nix;
        # This trait is unfriendly to being bundled with platform-iso
        traits.workstation = ./traits/workstation.nix;
        users.dunxen = ./home;
      };

      checks = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        {
          format = pkgs.runCommand "check-format"
            {
              buildInputs = with pkgs; [ rustfmt cargo ];
            } ''
            ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt --check ${./.}
            touch $out # it worked!
          '';
        });

    };
}
