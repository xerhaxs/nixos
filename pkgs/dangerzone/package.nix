{
  lib,
  python3Packages,
  fetchFromGitHub,
  cosign,
  tesseract,
  qt6,
  ocrLanguages ? [
    "eng"
    "deu"
  ],
}:

let
  tesseractWithLanguages = tesseract.override { enableLanguages = ocrLanguages; };
in

python3Packages.buildPythonApplication rec {
  pname = "dangerzone";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "freedomofpress";
    repo = "dangerzone";
    tag = "v${version}";
    hash = "sha256-K2v0u1BEqnf1skshw0SrkHcuIeYph9QhbggV3N52Qq0=";
  };

  # Resources are looked up below sys.prefix (the Python interpreter in Nix) and
  # tessdata only in FHS paths, point both to this package.
  postPatch = ''
    substituteInPlace dangerzone/util.py \
      --replace-fail 'Path(sys.prefix) / "share" / "dangerzone"' "Path(\"$out/share/dangerzone\")" \
      --replace-fail 'Path("/usr/share/tessdata/"),' 'Path("${tesseractWithLanguages}/share/tessdata/"),'
  '';

  build-system = with python3Packages; [ poetry-core ];

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
  ];

  dependencies = with python3Packages; [
    click
    colorama
    markdown
    packaging
    platformdirs
    pymupdf
    pyside6
    pyxdg
    requests
    shiboken6
  ];

  pythonRelaxDeps = true;

  postInstall = ''
    install -d $out/share/dangerzone/vendor
    find share -maxdepth 1 -type f -exec install -m 0644 -t $out/share/dangerzone {} +
    ln -s ${lib.getExe cosign} $out/share/dangerzone/vendor/cosign
    install -Dm 0644 install/linux/press.freedom.dangerzone.desktop -t $out/share/applications
    install -Dm 0644 install/linux/press.freedom.dangerzone.png -t $out/share/icons/hicolor/64x64/apps
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  # The tests need podman and the container image.
  doCheck = false;

  pythonImportsCheck = [ "dangerzone" ];

  meta = {
    description = "Convert potentially dangerous PDFs, office documents and images to safe PDFs";
    homepage = "https://dangerzone.rocks";
    license = lib.licenses.agpl3Only;
    mainProgram = "dangerzone";
    platforms = lib.platforms.linux;
  };
}
