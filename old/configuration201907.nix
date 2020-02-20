# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ];

    hardware = {
        opengl.driSupport32Bit  = true;
        pulseaudio.support32Bit = true;
        bluetooth.enable        = true;
    };

    boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        initrd.luks.devices = [
            {
                name = "root";
                device = "/dev/nvme0n1p2";
                preLVM = true;
            }];
        loader = {
            grub = {
                enable = true;
                device = "/dev/nvme0n1";
                extraConfig = 
                "GRUB_CMDLINE_LINUX_DEFAULT=\"resume=/dev/nvme0n1p2\"";
#               efiSupport = true;
#               forceInstall = true;
            };
#           systemd-boot.enable = true;     # Formerly  gummiboot.enable
#           efi.canTouchEfiVariables = true;
        };
        consoleLogLevel = 5;
        kernelParams = [ "resume=/dev/nvme0n1p2" ];
        blacklistedKernelModules = ["nouveau"];
        initrd.checkJournalingFS = false;
    };

    networking = {
        hostName    = "ghasshee";
        networkmanager.enable = true;
        nameservers = [ "8.8.8.8" "8.8.4.4" ];
        firewall = {
            allowPing = true;
#           allowedTCPPorts = [ 8080 ];
#           allowedUDPPorts = [ ... ];
#           enable = false;
        };
    };

    i18n = {
        consoleFont = "Lat2-Terminus16";
        consoleKeyMap = "us";
        defaultLocale = "en_US.UTF-8";
        inputMethod = {
            enabled = "ibus";
            ibus.engines = with pkgs.ibus-engines; [ anthy m17n ];
            };
    };
    
    time.timeZone = "Asia/Tokyo";
    
    nix.binaryCaches = [http://cache.nixos.org];
    nixpkgs.config = {
        allowUnfree = true;
        allowBroken = true;
        firefox.icedtea = true;
    };

    environment.etc."fuse.conf".text = ''
        user_allow_other
    '';
        
    # List packages installed in system profile. To search by name, run
    # $ nix-env -qaP | grep wget
    environment.systemPackages = 
    let py  = with pkgs.python36Packages; [
            ]; 
        sys = with pkgs; [
            networkmanager
            acpi
    
        # base
            fish zsh 
            vim bvi tmux w3m
            git curl wget gnused xsel
            tree less jq mlocate
            unzip xz
            sl lolcat figlet
            bc          # calculator
            at          # scheduled process execution
            sdcv        # Dictionary  
            man-db      # man
            manpages

        # process managesment
            lsof psutils htop
            psmisc      # killall, pstree, ..etc
            fzf tcpdump
            ## linuxPackages.perf               # for a kernel package
            config.boot.kernelPackages.perf   # for a current kernel package, 
        
        # security 
            openssl.dev openssh gnupg
            sshfs stunnel  

        # network 
            iptables nettools irssi
        
        # X 
            xorg.xmodmap xorg.xlibsWrapper
            xlibs.xmodmap xlibs.xbacklight xterm tty-clock xcalib 
            tk tcl          # tk/tcl 
    
        # Icon
            numix-icon-theme-circle numix-gtk-theme

        # GPU-things
            freeglut

        # Music/Sound/Video
            pulseaudioLight     # pulseaudioFull
            dvdplusrwtools dvdauthor
            espeak              # festival festival-english festival-us
            ffmpeg mplayer sox
            gnome3.totem vlc    # kde4.dragon kde4.kmix 

        # Virtualization and Containers
            docker # python27Packages.docker_compose

        # Browser 
            chromium firefoxWrapper

        # Mail 
            thunderbird

        # PDF
            kdeApplications.okular mupdf evince     

        # Math
            sage 
        # Applications
            # dropbox 
            dropbox-cli  
            xorg.libxshmfence
            # xfce4-12.thunar-dropbox-plugin
            # xfce.thunar-dropbox-plugin
            atom 
            qrencode
            vokoscreen
            maim        ## command-line screenshot
            gimp
            youtube-dl
            gnome3.eog  # image viewer
            tesseract   # OCR
            djvu2pdf
            timidity        # MIDI
            minecraft       # Game

        ###################
        ###  Languages  ###
        ###################
        # systemd.lib systemd.dev libudev
            stdenv  binutils.bintools
            makeWrapper cmake automake autoconf glibc 
            gdb
            nodejs ruby jekyll

        # Python
            python27Full python27Packages.pygments
            (python36.withPackages (x: with x; [
                python pip numpy matplotlib toolz pytest ipython jupyter virtualenvwrapper  
                tk tkinter
                numpy scipy networkx matplotlib 
                toolz
                ]))
            pypyPackages.virtualenv

        # Haskell 
            (pkgs.haskellPackages.ghcWithPackages(p: with p; [
                #cabal-install hoogle 
                #gnuplot GLUT
                #hip hakyll 
                #hmatrix algebra effect-monad 
                #vector-sized
                # megaparsec
                #base58-bytestring secp256k1 vector-sized mwc-random cryptonite ## bitcoin  
                ]))

        # OCaml
            ocaml opam 
            ocamlPackages.utop ocamlPackages.camlp4 
            ocamlPackages.findlib ocamlPackages.batteries

        # coq
            coq coqPackages_8_6.ssreflect

        # Rust with C dependencies 
            rustup cargo 
            binutils gcc gnumake 
            openssl pkgconfig 

    
                ]; in py ++ sys;



        services = {
            
        acpid.enable = true;
        
        redshift = {
            enable = true;
            latitude = "40";
            longitude = "135";
        };
        
        openssh.enable = true;

        xserver = {
            enable = true;
            layout = "us";
            xkbOptions = "eurosign:e";
            videoDrivers = [];

            displayManager.slim.enable = true;
	    displayManager.slim.defaultUser = "ghasshee";
	    displayManager.slim.autoLogin = true;
            desktopManager.xfce.enable = true;
#           desktopManager.kde4.enable = true;
       
            synaptics = {
                enable = true;
#               tapButtons = true;
                twoFingerScroll = true;
                horizontalScroll = true;
                vertEdgeScroll = false;
                accelFactor = "0.015";
                buttonsMap = [1 3 2];
                fingersMap = [1 3 2];

                additionalOptions = ''
                    Option "VertScrollDelta" "50"
                    Option "HorizScrollDelta" "-20"
                '';
            };
        };

        printing = {
            enable = true; # enable CUPS Printing 
            drivers = [pkgs.gutenprint pkgs.hplipWithPlugin ];
        };
      
#       multitouch.enable = true;
#       multitouch.invertScroll = true;
    };

    # Shells
    programs.zsh.enable = true;
    # programs.zsh.promptInit = "";
    # environment.promptInit = "";
    # programs.zsh.interactiveShellInit = "";
    # environment.interactiveShellInit = ""; 
    # User ( Do not forget to set with `passwd`
    users.extraUsers.ghasshee = {
	    isNormalUser    = true;
	    home            = "/home/ghasshee";
	    extraGroups     = ["wheel" "networkmanager"];
      	shell           = "/run/current-system/sw/bin/zsh";
        uid = 1000;
    };

    # system.stateVersion = "18.09";

}



