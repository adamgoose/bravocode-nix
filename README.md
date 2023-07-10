# Bravocode: All about Nix

I'll talk a bit about how I use Nix, and show you how you can use it too!

## Following Along

Make sure you're connected to Tailscale!

Follow along in your browser:
> http://adame.tailae01d.ts.net:7681

Access the slides in your terminal:
> `ssh adame.tailae01d.ts.net -p 53531`

## Running the Slides

You'll need to have Nix installed. If you don't have `direnv` configured in your
shell, run `nix develop` to enter a project shell.

You can run the slides locally by running `start`.

You can run the remote servers by running `serve`. The `ttyd` server expects you
to have a tmux session open named `Bravocode`.

## Running the Demos

Look at the README files in both the `flake-demo` and `home-manager-demo`
directories for more details.
