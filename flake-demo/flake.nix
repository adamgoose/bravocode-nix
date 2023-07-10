{
  description = "My First Flake";

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devenv.url = "github:cachix/devenv/latest";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      imports = [
        inputs.devenv.flakeModule
      ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {

        devenv.shells.default = {
          # Install Packages
          packages = with pkgs; [
            inetutils
            asciiquarium
            neo-cowsay
          ];

          # Set Environment Variables
          env.GREET = "This is a super awesome greeting!";

          # Create Scripts / Aliases
          scripts.say-hello.exec = "cowsay $GREET";
          scripts.the-force.exec = "telnet movie.gabe565.com";

          # Initialize the Environment
          enterShell = ''
            say-hello
          '';

          # Configure Programming Languages
          languages = {
            ruby = {
              enable = true;
              package = pkgs.ruby_3_2;
              bundler.enable = true;
            };
            java = {
              enable = true;
              jdk.package = pkgs.jdk17;
              gradle.enable = true;
              maven.enable = true;
            };
            kotlin = {
              enable = true;
            };
            javascript = {
              enable = true;
              package = pkgs.nodejs_20;
              corepack.enable = true;
            };
          };

          services = {
            postgres = {
              enable = true;
              package = pkgs.postgresql_13;
              listen_addresses = "0.0.0.0";
              initialDatabases = [{
                name = "my_project";
              }];
            };

            redis = {
              enable = true;
              bind = "0.0.0.0";
            };
          };
        };
      };
    };
}
