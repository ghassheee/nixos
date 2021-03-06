{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [ vim zsh ruby pstree rename 
    
    ## PYTHON 
    (python37.withPackages (x: with x; [
        python pynvim pip 
        numpy scipy networkx matplotlib toolz pytest 
        ipython jupyter virtualenvwrapper tkinter ]))
    
    ## OCAML 
    opam 

    ## HASKELL
    (ghc.withPackages (p: with p; [
    cabal-install hoogle hakyll hmatrix megaparsec Agda 
    ] ))


    

    ] ;

  nixpkgs.config = {
      allowBroken = true; 
      allowUnfree = true;
      allowUnsupportedSystem = true;
  };
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.bash.enable = true;
  programs.zsh.enable = true;
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 1;
  nix.buildCores = 1;
}
