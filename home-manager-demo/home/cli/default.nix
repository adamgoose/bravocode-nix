{ pkgs, ... }: {

  imports = [
    ./zsh.nix
  ];
  
  home.packages = with pkgs; [
    jq
    htop
    wget
    xplr
    doggo
    rclone
  ];

}
