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

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  programs.bat.enable = true;
  home.shellAliases.cat = "bat";

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./.omp.json));
  };

}
