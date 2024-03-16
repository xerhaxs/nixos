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
, vulkan-headers
, vulkan-loader
, vulkan-tools
, pkg-config
, lz4
}:
let
  glslang-submodule = mkDerivation {
    name = "glslang";
    installPhase = ''
      mkdir -p $out
    '';
    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "glslang";
      rev = "c34bb3b6c55f6ab084124ad964be95a699700d34";
      sha256 = "IMROcny+b5CpmzEfvKBYDB0QYYvqC5bq3n1S4EQ6sXc=";
    };
  };
in

mkDerivation rec {
  pname = "wallpaper-engine-kde-plugin";
  version = "0.5.4";

  cmakeFlags = [ "-DUSE_PLASMAPKG=ON" "-DCMAKE_C_COMPILER=gcc" "-DCMAKE_CXX_COMPILER=g++" ];
  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config glslang-submodule ];
  buildInputs = [ 
    plasma-framework mpv qtwebsockets websockets qtwebchannel
    qtdeclarative qtx11extras lz4
    vulkan-headers vulkan-tools vulkan-loader
  ];

  postPatch = ''
    rm -rf src/backend_scene/third_party/glslang
    ln -s ${glslang-submodule.src} src/backend_scene/third_party/glslang
  '';

  src = fetchFromGitHub {
    owner = "catsout";
    repo = pname;
    rev = "f972b2a24c9c3cc2d3e4f41d2ebd14f1473cebdf";
    fetchSubmodules = true;
    sha256 = "BVtTnJA1RLUU/Tj7WI/80ja4pI8NezHCjKvB72VjrZk=";
  };
}