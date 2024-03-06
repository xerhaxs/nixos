{ mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, plasma-framework
, gst-libav
, mpv
, websockets
, qtwebsockets
, qtwebchannel
, qtdeclarative
, qtx11extras
, shaderc
, glslang
, vulkan-headers
, vulkan-loader
, vulkan-tools
, pkg-config
, lz4
, wayland
, libass
, fribidi
, ffmpeg
, libdvdnav
, libdvdread
, mujs
, lcms
, libarchive
, libplacebo
, libunwind
, libdovi
, libbluray
, lua
, rubberband
, spirv-tools
, SDL2
, libuchardet
, zimg
, alsa-oss
}:

mkDerivation rec {
  pname = "wallpaper-engine-kde-plugin";
  version = "0.5.4";

  cmakeFlags = [ "-DUSE_PLASMAPKG=ON" ];
  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config spirv-tools ];
  buildInputs = [ 
    plasma-framework mpv qtwebsockets websockets qtwebchannel
    qtdeclarative qtx11extras lz4
    vulkan-headers vulkan-tools vulkan-loader shaderc glslang wayland zimg libuchardet alsa-oss SDL2 spirv-tools rubberband libbluray lua libass fribidi libdovi libplacebo libunwind libarchive ffmpeg mujs lcms libdvdnav libdvdread
  ];

  postPatch = ''
    rmdir src/backend_scene/third_party/glslang
    ln -s ${glslang.src} src/backend_scene/third_party/glslang
  '';

  src = fetchFromGitHub {
    owner = "catsout";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-a0iwxu/V6vNWftfjQE/mY0wO0lEtVIkQVNZypUT/fdI=";
  };
}