inputs: final: prev: {
  dangerzone = final.callPackage ./dangerzone/package.nix { src = inputs.dangerzone; };

  hyprgrass = final.callPackage ./hyprgrass/package.nix {
    inherit (inputs) hyprgrass-src wf-touch-src;
  };

  # The GUI looks for p2pool next to its own binary and downloads it there otherwise, which fails in
  # the store. Use p2pool from nixpkgs and keep its working directory (stats, cache) in the home.
  monero-gui = prev.monero-gui.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace src/p2pool/P2PoolManager.cpp \
        --replace-fail 'm_p2poolPath = QApplication::applicationDirPath();' \
          'm_p2poolPath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + "/p2pool"; QDir().mkpath(m_p2poolPath);' \
        --replace-fail 'm_p2pool = m_p2poolPath + "/p2pool";' 'm_p2pool = "${final.p2pool}/bin/p2pool";'
    '';
  });

  # Proton-API-Bridge (vendored in rclone) blocks on an unbuffered channel after a failed block
  # upload (e.g. a 502 from Proton) and never releases its semaphore slot; after a few failures every
  # upload hangs and the restic backup to Proton Drive stalls. A separate package, so restic and other
  # packages with rclone stay in the binary cache. Remove once upstream fixes
  # uploadAndCollectBlockData (docs/workarounds.md).
  rclone-proton = prev.rclone.overrideAttrs (old: {
    postConfigure = (old.postConfigure or "") + ''
      chmod -R u+w vendor/github.com/rclone/Proton-API-Bridge
      patch -p1 -d vendor/github.com/rclone/Proton-API-Bridge < ${./rclone/proton-upload-deadlock.patch}
    '';
  });

  # nixpkgs ships typepy 2, sqliteschema and SimpleSQLite still pin typepy < 2 (sbomnix needs them).
  # Remove once nixpkgs relaxes the pins itself.
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (_pyFinal: pyPrev: {
      simplesqlite = pyPrev.simplesqlite.overridePythonAttrs (old: {
        pythonRelaxDeps = (old.pythonRelaxDeps or [ ]) ++ [ "typepy" ];
      });
      sqliteschema = pyPrev.sqliteschema.overridePythonAttrs (old: {
        pythonRelaxDeps = (old.pythonRelaxDeps or [ ]) ++ [ "typepy" ];
      });
    })
  ];

  # nixpkgs links stalwart 0.15 against the system jemalloc (rust-jemalloc-sys-unprefixed) since
  # 11/2026, the binary then crashes at start (SIGSEGV in _rjem_je_arena_dalloc_small, also with
  # --version). Back to the bundled jemalloc, as nixpkgs does for 0.16 and 1.0 ("Using
  # rust-jemalloc-sys causes segmentation faults on x86_64"). Remove once nixpkgs reverts it.
  stalwart_0_15 =
    let
      feature = "jemallocator/unprefixed_malloc_on_supported_platforms";
    in
    prev.stalwart_0_15.overrideAttrs (old: {
      buildInputs = final.lib.remove final.rust-jemalloc-sys-unprefixed old.buildInputs;
      cargoBuildFeatures = final.lib.remove feature old.cargoBuildFeatures;
      cargoCheckFeatures = final.lib.remove feature old.cargoCheckFeatures;
      # The cargo setup hook points JEMALLOC_OVERRIDE to a missing path to force the system library.
      preBuild = (old.preBuild or "") + ''
        unset JEMALLOC_OVERRIDE
      '';
      # LTO optimizes the whole program in the last rustc step, fat and thin need more memory than
      # NixOS-ServerPublic has next to its services, the kernel kills rustc. Without LTO that step
      # only links.
      env = old.env // {
        CARGO_PROFILE_RELEASE_LTO = "false";
        CARGO_PROFILE_RELEASE_CODEGEN_UNITS = "16";
      };
    });

  update-images = final.callPackage ./update-images.nix { };
}
