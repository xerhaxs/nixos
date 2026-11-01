# The hyprgrass of nixpkgs does not build against Hyprland 0.56.2. This is the commit upstream pins for
# Hyprland v0.56.2 (hyprpm.toml) with the wf-touch revision it was developed against. Remove after a
# nixpkgs update ships a working hyprgrass.
{
  hyprgrass-src,
  hyprlandPlugins,
  lib,
  wf-touch,
  wf-touch-src,
}:

let
  unstableVersion = input: "0-unstable-${lib.substring 0 8 input.lastModifiedDate}";
in

(hyprlandPlugins.hyprgrass.override {
  wf-touch = wf-touch.overrideAttrs {
    version = unstableVersion wf-touch-src;
    src = wf-touch-src;
  };
}).overrideAttrs
  {
    version = unstableVersion hyprgrass-src;
    src = hyprgrass-src;
  }
