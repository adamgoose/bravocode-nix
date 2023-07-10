# Home Manager Demo

In this example, you'll use Nix and Home Manager to configure your dotfiles and
shell environment.

These instructions expect you to be on a fresh Ubuntu VM, but could easily be
tweaked to work on your machine!

```bash
# Install Nix
sh <(curl -L https://nixos.org/nix/install) --daemon
sudo sh -c 'echo "extra-experimental-features = nix-command flakes" >> /etc/nix/nix.conf'
sudo mkdir -p /nix/var/nix/profiles/per-user/adam

# Enter the project sub-shell
nix develop

# Build your derivation
home-manager build --flake .#adam@linux

# Inspect the result
xplr ./result

# Activate your Profile
home-manager switch --flake .#adam@linux
# Now, open a new terminal window
```

Once you've got this up and running, try creating a new "feature" which installs
all of your Cloud Development tools, such as the AWS CLI or K9S.
