# The hyprgrass of nixpkgs does not build against Hyprland 0.56.2. This is the commit upstream pins for
# Hyprland v0.56.2 (hyprpm.toml) with the wf-touch revision it was developed against. Remove after a
# nixpkgs update ships a working hyprgrass.
{
  fetchFromGitHub,
  hyprlandPlugins,
  wf-touch,
}:

(hyprlandPlugins.hyprgrass.override {
  wf-touch = wf-touch.overrideAttrs {
    version = "0-unstable-2021-03-19";
    src = fetchFromGitHub {
      owner = "WayfireWM";
      repo = "wf-touch";
      rev = "8974eb0f6a65464b63dd03b842795cb441fb6403";
      hash = "sha256-MjsYeKWL16vMKETtKM5xWXszlYUOEk3ghwYI85Lv4SE=";
    };
  };
}).overrideAttrs
  {
    version = "0.8.2-unstable-2026-08-11";
    src = fetchFromGitHub {
      owner = "horriblename";
      repo = "hyprgrass";
      rev = "8e605468cbf429791d61ddbfaeb14ff5e08fec3e";
      hash = "sha256-0nXTqzvZQSoTbpKcDmc4kciHmlIXfMZfLk5E1Ax9CP0=";
    };
  }
