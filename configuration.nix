# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let 
	dev 	    = "/dev/sda"; 
	dev1	 	= "${dev}1";
    dev2	 	= "${dev}2";
	p		    = (import ./packages.nix) pkgs;
in
with pkgs; 
{
    imports                     =   [ ./hardware-configuration.nix ];
    hardware                    =   {
        opengl.driSupport32Bit      = true;
        pulseaudio.enable           = true;
        bluetooth.enable            = true; 
        };
    boot                        =   {
        kernelPackages              = linuxPackages_latest;
        consoleLogLevel             = 5 ;
        kernelParams                = ["resume=${dev2}" ];
        blacklistedKernelModules    = ["nouveau"];
        initrd                      = {
            checkJournalingFS   = false;   
            luks.devices        = [{
                name                = "root";
                device              = "${dev2}";
                preLVM              = true;  }]; };
        loader                  = {
            grub                    = {
                enable                  = true;
                device                  = dev;
                extraConfig             = "GRUB_CMDLINE_LINUX_DEFAULT=\"resume=${dev2}\""; };};
        };
    time.timeZone               =   "Asia/Tokyo";
    networking                  =   {
        hostName                    = "ghasshee";
        networkmanager.enable       = true;
        nameservers             = [ "8.8.8.8" "8.8.4.4" ];
        firewall                = {
            enable                  = false;
            allowPing               = false;
            allowedTCPPorts         = [ 8080 ];
            allowedUDPPorts         = [ ]; };
        };
    i18n                        =   {
        consoleFont                 = "Lat2-Terminus16";
        consoleKeyMap               = "us";
        defaultLocale               = "en_US.UTF-8";
        inputMethod                 = {
            enabled                     = "ibus";
            ibus.engines                = with ibus-engines; [ anthy m17n ]; };
        };
    nix.binaryCaches            = [http://cache.nixos.org];
    nixpkgs.config              = {
        allowUnfree                 = true;
        allowBroken                 = true;
        firefox.icedtea             = true;
        };
    environment                 =   {
        etc."fuse.conf".text = ''user_allow_other'';
            systemPackages = [
                zsh vim bvi tmux w3m git curl wget gnused xsel rename tree less rlwrap
                jq mlocate unzip xz sl lolcat figlet man-db manpages sdcv bc acpi
                openssl.dev openssh gnupg sshfs stunnel 
                networkmanager iptables nettools irssi tcpdump

                at lsof psutils htop fzf psmisc 
                config.boot.kernelPackages.perf         ## linuxPackages.perf

                xorg.xlibsWrapper xlibs.xmodmap  xterm tty-clock xcalib tk tcl freeglut
		##acpilight
                numix-icon-theme-circle numix-gtk-theme
                
                abcde
                pulseaudioLight 
                dvdplusrwtools dvdauthor 
                espeak ffmpeg-full mplayer sox timidity 
                gnome3.totem vlc

                chromium firefoxWrapper thunderbird kdeApplications.okular mupdf evince vivaldi
            ] ++ p;
        };
    services            = {
        acpid.enable            = true;
        redshift                = {
            enable                  = true;
            latitude                = "40";
            longitude               = "135";    };
        openssh.enable          = true;
        xserver                 = {
            enable                  = true;
            layout                  = "us";
            xkbOptions              = "eurosign:e";
            videoDrivers            = [ "nvidia" ];
            displayManager.slim     = {
                enable                  = true;
                defaultUser             = "ghasshee";
                autoLogin               = true;     };
            desktopManager.xfce.enable = true;
            synaptics               = {
                enable                  = true;
                tapButtons              = false;
                twoFingerScroll         = true;
                horizontalScroll        = true;
                vertEdgeScroll          = false;
                accelFactor             = "0.015";
                buttonsMap              = [1 3 2];
                fingersMap              = [1 3 2];
                additionalOptions       = ''
                    Option "VertScrollDelta" "50"
                    Option "HorizScrollDelta" "-20"
                ''; };  };
        printing                = {
            enable                  = true; # enable CUPS Printing 
            drivers                 = [gutenprint cups-bjnp cups-dymo];};
	cron 			= {
	    enable 		    = true;
	    systemCronJobs      = [ 
		"* * * * * ghasshee . /etc/profile; espeak 'Another minute has passed in your life'"
				];};
        };

    # Shells
    programs.zsh            = {
        enable                  = true;
        promptInit              = "";
        interactiveShellInit    = ""; 
        };
    virtualisation.docker.enable = true;
#########  User ( Do not forget to set with `passwd` ) 
    users                   = {
        users               = {};
        extraUsers          = {
            ghasshee            = {
	            isNormalUser        = true;
	            home                = "/home/ghasshee";
	            extraGroups         = ["wheel" "networkmanager" "adbusers" "docker"];
      	        shell               = "/run/current-system/sw/bin/zsh";
                uid                 = 1000;     };};
        };
    system.stateVersion = "19.03";
}



