{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    vimAlias = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file.".config/nvim".recursive = true;
  home.file.".config/nvim".source = pkgs.fetchFromGitHub {
    owner = "AstroNvim";
    repo = "AstroNvim";
    rev = "v3.23.1";
    sha256 = "sha256-7od4BIubFTTe0qWOEH9V/2DuhD3ntBJmjicQMEH2TBI=";
  };
}
