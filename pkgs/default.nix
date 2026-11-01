inputs: final: prev: {
  dangerzone = final.callPackage ./dangerzone/package.nix { src = inputs.dangerzone; };

  hyprgrass = final.callPackage ./hyprgrass/package.nix {
    inherit (inputs) hyprgrass-src wf-touch-src;
  };

  update-images = final.callPackage ./update-images.nix { };
}
