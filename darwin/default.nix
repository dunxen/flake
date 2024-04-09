#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ default.nix *
#       └─ <host>.nix
#

{ inputs, nixpkgs, darwin, home-manager, vars, ... }:

let
  system = "aarch64-darwin";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  carbon = darwin.lib.darwinSystem {
    inherit system;
    specialArgs = { inherit inputs pkgs vars; };
    modules = [
      ./carbon.nix
      ../modules/editors/nvim.nix

      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
