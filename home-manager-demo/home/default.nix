{ pkgs, features, username, ... }: 

let
  inherit (builtins) map pathExists filter;
in {
  imports = filter pathExists (map (feature: ./${feature}) features);

  home = {
    inherit username;

    homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}";
    stateVersion = "23.05";
  };
}
