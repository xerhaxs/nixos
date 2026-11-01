final: prev: {
  dangerzone = final.callPackage ./dangerzone/package.nix { };

  hyprgrass = final.callPackage ./hyprgrass/package.nix { };
}
