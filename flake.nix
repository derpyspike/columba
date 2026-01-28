{
  description = "Columba Android Dev Environment (FHS compliant)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      fhs = pkgs.buildFHSEnv {
        name = "columba-env";
        
        targetPkgs = pkgs: with pkgs; [
          # Android & Build Tools
          android-studio
          git
          gnumake
          
          # Java 17 (Required for modern Android/Columba [1])
          jdk17
          
          # Python 3.11 (Required for Chaquopy [2])
          python311
          
          # System Libraries
          zlib
          glibc
          ncurses5
          
          # FIX: This replaces 'stdcxx' to provide libstdc++
          stdenv.cc.cc.lib 
          
          openssl
          expat
          xorg.libX11
          xorg.libXext
          xorg.libXrender
          xorg.libXtst
          xorg.libXi
        ];

        profile = ''
          export JAVA_HOME=${pkgs.jdk17}
          export CHAQUOPY_PYTHON=${pkgs.python311}/bin/python3.11
          
          echo "✨ Columba Dev Environment Ready (FHS) ✨"
          echo "Run 'android-studio .' to open the IDE."
        '';

        runScript = "bash";
      };
    in
    {
      devShells.${system}.default = fhs.env;
    };
}
