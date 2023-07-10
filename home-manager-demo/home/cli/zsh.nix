{ pkgs, name, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;

    zplug.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "direnv" "fzf" "git" "vi-mode" ]
        ++ lib.lists.optional (pkgs.stdenv.isDarwin) "macos";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.bat.enable = true;
  home.shellAliases.cat = "bat";
}
