{
  description = "Bravocode: All about Nix";

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv/latest";
  };

  outputs = inputs@{ nixpkgs, flake-parts, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      imports = [ inputs.devenv.flakeModule ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {

        devenv.shells.default = {
          packages = with pkgs; [
            ttyd
            slides
          ];

          processes.slides.exec = "slides serve --host 0.0.0.0 --port 53531 SLIDES.md";
          processes.ttyd.exec = "ttyd -Rp 7681 tmux a -rtBravocode";

          scripts.start.exec = "slides SLIDES.md";
          scripts.serve.exec = "devenv up";
        };

      };
    };
}
