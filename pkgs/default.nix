inputs: final: prev: {
  dangerzone = final.callPackage ./dangerzone/package.nix { src = inputs.dangerzone; };

  hyprgrass = final.callPackage ./hyprgrass/package.nix {
    inherit (inputs) hyprgrass-src wf-touch-src;
  };

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
