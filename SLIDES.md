---
theme: ./macchiato.json
author: Adam Engebretson
date: MMMM dd, YYYY
paging: Slide %d / %d
---

# A Nix Overview

Make sure you're connected to Tailscale!

Follow along in your browser:
> http://adame.tailae01d.ts.net:7681

Access the slides in your terminal:
> `ssh adame.tailae01d.ts.net -p 53531`

---

# What is Nix?

https://nixos.org

- Package Manager
- Linux Distribution
- Programming Language
- Build Tool
- CI Tool

---

# Install the Package Manager

`sh <(curl -L https://nixos.org/nix/install)`

On Mac, this will create an APFS Volume called the "Nix Store" at `/nix`.

---

# Installing Packages

More than 80,000 packages are available at https://search.nixos.org/packages.

All packages are installed into the Nix Store at `/nix`.

Run a shell with the package temporarily installed:
>`nix shell nixpkgs#youtube-dl`

Install a package globally:
> `nix profile install nixpkgs#youtube-dl`

List installed packages:
> `nix profile list`

---

# Working with Flakes

Specify your `inputs` and `outputs` in a `flake.nix`.

Think of `package.json` or `Gemfile`.

```nix
{
    description = "My First Flake";

    inputs = {};

    outputs = { self }: {};
}
```

---

# Working with Flakes
## Pinning Nixpkgs

[Nixpkgs](https://github.com/NixOS/nixpkgs) is released twice a year. Let's grab the latest stable release.
```
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.05";
  };
```

Now, run `nix flake update`. This will pin the Nixpkgs version in a `flake.lock` file.

```json
    "nixpkgs": {
      "locked": {
        "lastModified": 1685566663,
        "narHash": "sha256-btHN1czJ6rzteeCuE/PNrdssqYD2nIA4w48miQAFloM=",
        "owner": "NixOS",
        "repo": "nixpkgs",
        "rev": "4ecab3273592f27479a583fb6d975d4aba3486fe",
        "type": "github"
      },
    },
```

---

# Working with Flakes
## Making things easier with Flake Parts

[Flake Parts](https://flake.parts) will make it easier for us to build for multiple systems.
```
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
```

We'll unpack the `flake-parts` input, and call its `mkFlake` function.
```
  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

      ...
    };
```
---

# Working with Flakes
## One more tool: Devenv

[Devenv](https://devenv.sh) enables Fast, Declarative, Reproducible, and Composable Developer Environments using Nix
```
  inputs = {
    devenv.url = "github:cachix/devenv/latest";
  };
```

Here, we'll install the Devenv module.
```
  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {

      imports = [
        inputs.devenv.flakeModule
      ];

    };
```

---

# Configuring a Devenv
## Setup

We can now create a default Devenv for our project.

```nix
outputs = inputs@{ flake-parts, ... }:
  flake-parts.lib.mkFlake { inherit inputs; } {
    perSystem = { config, self', inputs', pkgs, system, ... }: {

      devenv.shells.default = {
        # Configure our Devenv
      };

    };
  };
```

---

# Configuring a Devenv
## Shell Environment

Here, we can install Packages, set Environment Variables, configure Shell Aliases, and more...
```nix
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
};
```

---

# Configuring a Devenv
## Language Specifics

Devenv can install and configure your programming language(s).
```
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
```

---

# Configuring a Devenv
## Running Dependencies

Here are just a few examples of services that can be enabled.
```nix
services.mailhog.enable = true;
services.minio.enable = true;
services.nginx.enable = true;
services.postgres.enable = true;
services.redis.enable = true;
services.vault.enable = true;
```

---

# Configuring a Devenv
## Running Dependencies

A more realistic example:
```
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
```

---

# Configuring a Devenv
## Running Dependencies

Just run `devenv up`.

- Postgres v13 is available on `0.0.0.0:5432`
- Redis is available on `0.0.0.0:6379`

---

# Configuring a Devenv
## Examples

- https://github.com/get-bridge/get_smart/pull/3077
- https://github.com/get-bridge/bridge-tagging-service/pull/28
- https://github.com/get-bridge/authmonger/blob/master/devenv.nix

---

# Building a Project

```nix
buildGoModule rec {
  pname = "truss-cli";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "get-bridge";
    repo = "truss-cli";
    rev = "v${version}";
    sha256 = "sha256-GNs+CGcXcoImYQM3mMfwuATUn4A0gziy7DKtF08krb8=";
  };
  vendorSha256 = "sha256-9hV4gh6RHsPff9XsFyVybMc5QSe54ZPZjIrPL+HFVBs=";
  doCheck = false;
  nativeBuildInputs = [ installShellFiles ];
  ldflags = [ "-s -w -X github.com/get-bridge/truss-cli/cmd.Version=${version}" ];

  postInstall = ''
    mv $out/bin/truss-cli $out/bin/truss
    installShellCompletion --cmd truss --bash <($out/bin/truss completion bash) --fish <($out/bin/truss completion fish) --zsh <($out/bin/truss completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/get-bridge/truss-cli";
    description = "CLI to help you manage many k8s clusters";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
```

---

# Home Manager
## Managing your Dotfiles with Nix

Let's just take a look...

---

# What else...
## NixOS

NixOS is a Linux Distribution entirely managed by Nix. You can extend your
Flake to expose NixOS configurations which can work in tandem with your Home
Manager configurations.

---

# What else...
## Nix-Darwin

Nix-Darwin lets you take full control of your Mac, all with Nix.
