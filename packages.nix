{config, pkgs, ... }:
with pkgs;
let 
    patched-ghc     = haskellPackages.override (old:{
        overrides = self: super: {
            Euterpea    = self.callHackage "Euterpea" "2.0.6" {};
            PortMidi    = self.callHackage "PortMidi" "0.1.6.1" {};
            heap        = pkgs.haskell.lib.dontCheck super.heap;
                            };}
        );
    py              = [
        python27Full python27Packages.pygments pypyPackages.virtualenv
        (python36.withPackages (x: with x; [
            python pip numpy scipy networkx matplotlib toolz pytest 
            ipython jupyter virtualenvwrapper tkinter #tk
            ])) 
        ];
    hs              = [ 
        (patched-ghc.ghcWithPackages (p: with p; [
            cabal-install hoogle hakyll effect-monad hmatrix megaparsec gnuplot GLUT 
            Euterpea HSoM 
            base58-bytestring vector-sized mwc-random cryptonite secp256k1-haskell # secp256k1 
            # algebra
            ])) 
        ];
    ml              = with ocamlPackages; [
        ocaml opam utop camlp4 findlib batteries 
        ]; 
    sys             = [
                 
   # Applications
        sage            # Mathematica Alternative 
        android-file-transfer
        dropbox-cli xorg.libxshmfence atom djvu2pdf qrencode vokoscreen docker gimp youtube-dl
        maim            # command-line screenshot
        gnome3.eog      # image viewer
        tesseract       # OCR
        timidity        # MIDI
        minecraft       # Game
        ltris
        texlive.combined.scheme-full
                
   # Languages  
        stdenv  binutils.bintools makeWrapper cmake automake autoconf glibc gdb 
        binutils gcc gnumake openssl pkgconfig 
        nodejs ruby jekyll              ## Ruby / Nodejs
        idris vimPlugins.idris-vim      ## Idris
        coq coqPackages_8_6.ssreflect   ## Coq
        rustup cargo                    ## RUST 
];
in sys ++ hs ++ py ++ ml 
