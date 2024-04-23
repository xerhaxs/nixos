{ config, lib, pkgs, ... }:

{
  options.nixos = {
    theme.dracula = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable catppuccin theme.";
      };
    };
  };

  config = lib.mkIf config.nixos.theme.dracula.enable {
    environment.systemPackages = with pkgs; [
      papirus-icon-theme

      (catppuccin.override {
        accent = [ "mauve" ];
        variant = [ "mocha" ];
        themeList = [
          "bat"
          "bottom"
          "btop"
          "hyprland"
          "k9s"
          "kvantum"
          "lazygit"
          "plymouth"
          "refind"
          "rofi"
          "waybar"
        ];
      })

      (catppuccin-kde.override {
        accents = ${config.nixos.theme.theme.catppuccin.accent};
        flavour = ${config.nixos.theme.theme.catppuccin.flavor};
        winDecStyles = ${config.nixos.theme.theme.catppuccin.winDecStyles};
      })

      (catppuccin-gtk.override {
        accents = ${config.nixos.theme.theme.catppuccin.accent};
        size = ${config.nixos.theme.theme.catppuccin.size};
        tweaks = ${config.nixos.theme.theme.catppuccin.tweaks};
        variant = ${config.nixos.theme.theme.catppuccin.flavor};
      })

      (catppuccin-cursors.override {
        dimensions.color = ${config.nixos.theme.theme.catppuccin.accent};
        dimensions.palette = ${config.nixos.theme.theme.catppuccin.flavor};
      })

      (catppuccin-papirus-folders.override {
        accent = ${config.nixos.theme.theme.catppuccin.accent};
        flavor = ${config.nixos.theme.theme.catppuccin.flavor};
      })

      (catppuccin-plymouth.override {
        variant = ${config.nixos.theme.theme.catppuccin.flavor};
      })

      (catppuccin-kvantum.override {
        accent = ${config.nixos.theme.theme.catppuccin.accent};
        variant = ${config.nixos.theme.theme.catppuccin.flavor};
      })
    ];

    boot.plymouth = {
      font = "${pkgs.dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf";
      themePackages = with pkgs; [
          (catppuccin-plymouth.override {variant = "${config.nixos.theme.theme.catppuccin.flavor}";})
        ];
      theme = "catppccin-"${config.nixos.theme.theme.catppuccin.flavor};
    };

    boot.loader.grub.theme = ${config.nixos.theme.theme.catppccin.grub};

    services.xserver.displayManager.sddm.theme = "${config.nixos.theme.theme.catppuccin.sddm}";
  };
}