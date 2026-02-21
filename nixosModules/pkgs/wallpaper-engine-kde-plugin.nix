{
  config,
  lib,
  pkgs,
  ...
}:

let
  # References: https://github.com/xerhaxs/nixos/blob/main/nixosModules/pkgs/wallpaper-engine-kde-plugin.nix and https://discourse.nixos.org/t/wallpaper-engine-on-nixos-wallpaper-engine-kde-plugin/19744/25
  glslang-submodule =
    with pkgs;
    stdenv.mkDerivation {
      name = "glslang";
      installPhase = ''
        mkdir -p $out
      '';
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "glslang";
        rev = "b5782e52ee2f7b3e40bb9c80d15b47016e008bc9";
        sha256 = "sha256-cEREniYgSd62mnvKaQkgs69ETL5pLl5Gyv3hKOtSv3w=";
      };
    };

  wallpaper-engine-kde-plugin =
    with pkgs;
    stdenv.mkDerivation rec {
      pname = "wallpaperEngineKde";
      version = "f1b86e1ca7982b5b9f47d21ac2cb5c2adfb45902";
      src = fetchFromGitHub {
        owner = "catsout";
        repo = "wallpaper-engine-kde-plugin";
        rev = version;
        hash = "sha256-otdfGa63w1TfMhYFBauJvxV90OqLqJSEvWB2j0W0E5g=";
        fetchSubmodules = true;
      };

      nativeBuildInputs = [
        cmake
        kdePackages.extra-cmake-modules
        glslang-submodule
        pkg-config
        gst_all_1.gst-libav
        shaderc
        ninja
        makeWrapper
        (python3.withPackages (ps: with ps; [ websockets ]))
      ];

      buildInputs = [
        mpv
        libass
        lz4
        vulkan-headers
        vulkan-tools
        vulkan-loader
      ]
      ++ (with kdePackages; [
        qtbase
        qtsvg
        qtwayland
        qtdeclarative
        qttools
        qtwebsockets
        qtwebengine
        qtwebchannel
        qtmultimedia
        kpackage
        kdeclarative
        libplasma
      ])
      ++ [ (python3.withPackages (python-pkgs: [ python-pkgs.websockets ])) ];

      cmakeFlags = [
        "-DUSE_PLASMAPKG=OFF"
        "-DQt6_DIR=${qt6Packages.qtbase}/lib/cmake/Qt6"
        "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
      ];
      dontWrapQtApps = true;

      postPatch = ''
        rm -rf src/backend_scene/third_party/glslang
        ln -s ${glslang-submodule.src} src/backend_scene/third_party/glslang
      '';

      postInstall = ''
        chmod +x $out/share/plasma/wallpapers/com.github.catsout.wallpaperEngineKde/contents/pyext.py
        patchShebangs --build $out/share/plasma/wallpapers/com.github.catsout.wallpaperEngineKde/contents/pyext.py
      '';

      #Optional informations
      meta = with lib; {
        description = "Wallpaper Engine KDE plasma plugin";
        homepage = "https://github.com/Jelgnum/wallpaper-engine-kde-plugin";
        license = licenses.gpl2Plus;
        platforms = platforms.linux;
      };
    };
in

{
  options.nixos = {
    pkgs.wallpaper-engine-kde-plugin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable wallpaper-engine-kde-plugin.";
      };
    };
  };

  config = lib.mkIf (config.nixos.pkgs.wallpaper-engine-kde-plugin.enable) {
    environment.systemPackages = with pkgs; [
      wallpaper-engine-kde-plugin
      kdePackages.qtwebsockets
      kdePackages.qtwebchannel
      (python3.withPackages (python-pkgs: [ python-pkgs.websockets ]))
    ];

    environment.sessionVariables = {
      PYTHONPATH = "${
        pkgs.python3.withPackages (p: [ p.websockets ])
      }/${pkgs.python3.sitePackages}:$PYTHONPATH";
    };

    system.activationScripts = {
      wallpaper-engine-kde-plugin.text = ''
        wallpaperenginetarget=/share/plasma/wallpapers/com.github.catsout.wallpaperEngineKde
        mkdir -p /home/${builtins.head (builtins.attrNames config.users.users)}/.local/share/plasma/wallpapers
        chown -R ${builtins.head (builtins.attrNames config.users.users)}:users /home/${builtins.head (builtins.attrNames config.users.users)}/.local/share/plasma
        if [ ! -e /home/${builtins.head (builtins.attrNames config.users.users)}/.local$wallpaperenginetarget ]; then
          ln -sf ${wallpaper-engine-kde-plugin}$wallpaperenginetarget /home/${builtins.head (builtins.attrNames config.users.users)}/.local$wallpaperenginetarget
        fi;
      '';
    };
  };
}
