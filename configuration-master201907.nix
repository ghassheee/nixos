# HELP          =>  $ man configuration.nix  
# SEARCH PKGs   =>  $ nix-env -qaP | grep wget

{ config, pkgs, ... }:
{
    imports             =   [ ./hardware-configuration.nix ];
    hardware            =   {
        opengl.driSupport32Bit  = true;
        pulseaudio.support32Bit = true;
        bluetooth.enable        = true; };
    boot                =   {
        kernelPackages      = pkgs.linuxPackages_latest;
        consoleLogLevel     = 5 ;
        kernelParams        = ["resume=/dev/nvme0n1p2" ];
        blacklistedKernelModules = ["nouveau"];
        initrd              = {
            checkJournalingFS   = false;   
            luks.devices        = [{
                name                = "root";
                device              = "/dev/nvme0n1p2";
                preLVM              = true;  }]; };
        loader              = {
            grub                = {
                enable              = true;
                device              = "/dev/nvme0n1";
                extraConfig         = "GRUB_CMDLINE_LINUX_DEFAULT=\"resume=/dev/nvme0n1p2\""; 
                };};
    };
    time.timeZone       =   "Asia/Tokyo";
    networking          =   {
        hostName            = "ghasshee";
        networkmanager      = {
            enable              = true;};
        nameservers         = [ "8.8.8.8" "8.8.4.4" ];
        firewall            = {
            enable              = false;
            allowPing           = true;
            allowedTCPPorts     = [ 8080 ];
            allowedUDPPorts     = [ ]; };
    };
    i18n                =   {
        consoleFont         = "Lat2-Terminus16";
        consoleKeyMap       = "us";
        defaultLocale       = "en_US.UTF-8";
        inputMethod         = {
            enabled             = "ibus";
            ibus.engines        = with pkgs.ibus-engines; [ anthy m17n ]; };
    };
    nix                 =   {
        binaryCaches        = [http://cache.nixos.org];
        package            = pkgs.nix1;  ## this updates to 19.03
    };
    nixpkgs.config      = {
        allowUnfree         = true;
        allowBroken         = true;
        firefox.icedtea     = true;
    };

    environment         =   {
#       promptInit = "";
#       interactiveShellInit = ""; 
        etc."fuse.conf".text = ''user_allow_other'';
        systemPackages = with pkgs; 
            let 
                patched-ghc     = haskellPackages.override (old:{
                        overrides = self: super: {
                            Euterpea    = self.callHackage "Euterpea" "2.0.6" {};
                            PortMidi    = self.callHackage "PortMidi" "0.1.6.1" {};
                            heap        = pkgs.haskell.lib.dontCheck super.heap;
                            };});
                py              = [
                    python27Full python27Packages.pygments pypyPackages.virtualenv
                    (python36.withPackages (x: with x; [
                        python pip numpy scipy networkx matplotlib toolz pytest 
                        ipython jupyter virtualenvwrapper tkinter #tk
                        ]))];
                hs              = [ 
                    (patched-ghc.ghcWithPackages (p: with p; [
                        cabal-install hoogle hakyll effect-monad hmatrix megaparsec
                        gnuplot GLUT Euterpea
                        # algebra 
                        base58-bytestring vector-sized mwc-random 
                        cryptonite secp256k1-haskell # secp256k1 
                        ]))];
                ml              = with ocamlPackages; [
                    ocaml opam labltk
                    utop camlp4 findlib batteries ]; 

                sys             = [

                    acpi zsh vim bvi tmux w3m git curl wget gnused xsel rename 
                    tree less jq mlocate unzip xz sl lolcat figlet man-db manpages sdcv bc 
                    openssl.dev openssh gnupg sshfs stunnel         ## Security                 
                    networkmanager iptables nettools irssi tcpdump  ## Network 
                
                # Process / Memory 
                    at                                      # scheduled process execution
                    lsof psutils htop fzf 
                    psmisc                                  # killall, pstree, ..etc
                    config.boot.kernelPackages.perf         ## linuxPackages.perf 
                
                # X 
                    xorg.xlibsWrapper xlibs.xmodmap acpilight xterm tty-clock xcalib tk tcl          
                    numix-icon-theme-circle numix-gtk-theme
                    freeglut  ## For GLUT GPU culculation 
                
                # Music/Video
                    pulseaudioLight ## pulseaudioFull     
                    dvdplusrwtools dvdauthor
                    espeak ffmpeg mplayer sox timidity 
                    gnome3.totem vlc    # kde4.dragon kde4.kmix 
                
                # Applications
                    chromium firefoxWrapper thunderbird kdeApplications.okular mupdf evince vivaldi
                    sage            # Mathematica Alternative 
                    android-file-transfer
                    dropbox-cli xorg.libxshmfence atom djvu2pdf qrencode vokoscreen docker gimp youtube-dl
                    maim            # command-line screenshot
                    gnome3.eog      # image viewer
                    tesseract       # OCR
                    timidity        # MIDI
                    minecraft       # Game
                
                # Languages  
                    stdenv  binutils.bintools makeWrapper cmake automake autoconf glibc gdb 
                    binutils gcc gnumake openssl pkgconfig rlwrap
                    nodejs ruby jekyll              ## Ruby / Nodejs
                    idris vimPlugins.idris-vim      ## Idris
                    coq coqPackages_8_6.ssreflect   ## Coq
                    rustup cargo                    ## RUST 
        
            ]; in sys ++ hs ++ py ++ ml ;
    };
    

    services            = {
        acpid.enable        = true;
        redshift            = {
            enable              = true;
            latitude            = "40";
            longitude           = "135";    };
        openssh.enable      = true;
        xserver             = {
            enable              = true;
            layout              = "us";
            xkbOptions          = "eurosign:e";
            displayManager.slim = {
                enable              = true;
                defaultUser         = "ghasshee";
                autoLogin           = true;     };
            desktopManager.xfce.enable = true;
#           desktopManager.kde4.enable = true;
            synaptics           = {
                enable              = true;
#               tapButtons          = true;
                twoFingerScroll     = true;
                horizontalScroll    = true;
                vertEdgeScroll      = false;
                accelFactor         = "0.015";
                buttonsMap          = [1 3 2];
                fingersMap          = [1 3 2];
                additionalOptions   = ''
                    Option "VertScrollDelta" "50"
                    Option "HorizScrollDelta" "-20"
                ''; };};
        printing            = {
            enable              = true; # enable CUPS Printing 
            drivers             = with pkgs; [ gutenprint hplipWithPlugin cups-bjnp cups-dymo ];};
    };

    # Shells
    programs.zsh            = {
        enable                  = true;
        promptInit              = "";
        interactiveShellInit    = ""; };
    
#########  User ( Do not forget to set with `passwd` ) 
    users               = {
        users               = {};
        extraUsers          = {
            ghasshee            = {
	            isNormalUser        = true;
	            home                = "/home/ghasshee";
	            extraGroups         = ["wheel" "networkmanager" "adbusers"];
      	        shell               = "/run/current-system/sw/bin/zsh";
                uid                 = 1000;     };};
    };
    system.stateVersion = "19.03";
}

