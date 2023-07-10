{
  description = "My Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, flake-parts, home-manager, ... }:
    let mkHome = { system, username ? "adam", features ? [] }: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        modules = [ ./home ];
        extraSpecialArgs = { inherit features username; };
      };

    in flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {

        devShells.default = pkgs.mkShell {
          packages = [
            inputs'.home-manager.packages.home-manager
            pkgs.neovim
            pkgs.xplr
          ];
        };

      };

      flake = {
        homeConfigurations = {
          "adam@mac" = mkHome {
            system = "aarch64-darwin";
            features = [ "cli" "nvim" ];
          };

          "adam@linux" = mkHome {
            system = "x86_64-linux";
            features = [ "cli" "nvim" ];
          };
        };
      };
    };
}
