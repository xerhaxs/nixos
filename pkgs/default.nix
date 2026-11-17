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
  # upload hangs and the restic backup to Proton Drive stalls. Remove once upstream fixes
  # uploadAndCollectBlockData (docs/workarounds.md).
  rclone = prev.rclone.overrideAttrs (old: {
    postConfigure = (old.postConfigure or "") + ''
      chmod -R u+w vendor/github.com/rclone/Proton-API-Bridge
      patch -p1 -d vendor/github.com/rclone/Proton-API-Bridge < ${./rclone/proton-upload-deadlock.patch}
    '';
  });

  # nixpkgs ships typepy 2, sqliteschema and SimpleSQLite still pin typepy < 2 (sbomnix needs them).
  # Remove once nixpkgs relaxes the pins itself (TODO 13.21).
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pyFinal: pyPrev: {
      simplesqlite = pyPrev.simplesqlite.overridePythonAttrs (old: {
        pythonRelaxDeps = (old.pythonRelaxDeps or [ ]) ++ [ "typepy" ];
      });
      sqliteschema = pyPrev.sqliteschema.overridePythonAttrs (old: {
        pythonRelaxDeps = (old.pythonRelaxDeps or [ ]) ++ [ "typepy" ];
      });
    })
  ];

  update-images = final.callPackage ./update-images.nix { };
}
