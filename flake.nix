{
  description = "A NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nurpkgs = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    flatpaks = {
      url = "github:GermanBread/declarative-flatpak/stable";
    };
  };

  outputs = inputs@{ self, nixpkgs, disko, nur, nixos-generators, home-manager, plasma-manager, flatpaks, ... }:
    let

    specialArgs = {
      inherit inputs;
      inherit plasma-manager;
      inherit flatpaks;
    };

    in {
    nixosConfigurations = {

        NixOS-Crafter = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = inputs;

          modules = [
            # This is not a complete NixOS configuration and you need to reference
            # your normal configuration here.
            ./system
            ./hosts/NixOS-Crafter

            #./system-modules/fonts.nix
            ./system-modules/hardware-configuration.nix
            ./system-modules/intelcpu.nix
            #./system-modules/intelgpu.nix
            #./system-modules/kdeconnect.nix
            #./system-modules/mullvad.nix
            #./system-modules/nvidiagpu.nix
            #./system-modules/plasma5.nix
            #./system-modules/printing.nix
            #./system-modules/sddm.nix
            #./system-modules/theme.nix
            #./system-modules/theme-latte.nix

            # disko Moule
            disko.nixosModules.disko
            ./system-modules/disko-bios-lvm-on-luks.nix
            {
              _module.args.disks = [ "/dev/sda" ];
            }

            # nur repo
            nur.nixosModules.nur

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.crafter = import ./hosts/NixOS-Crafter/home-crafter;
              };
            }
          ];
        };

        NixOS-Desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = inputs;

          modules = [
            # This is not a complete NixOS configuration and you need to reference
            # your normal configuration here.
            ./system
            ./hosts/NixOS-Desktop

            ./system-modules/amdcpu.nix
            ./system-modules/amdgpu.nix
            ./system-modules/autostart.nix
            #./system-modules/corectrl.nix
            ./system-modules/flatpak.nix
            ./system-modules/fonts.nix
            ./system-modules/gamemode.nix
            #./system-modules/gnome.nix
            #./system-modules/hardware-configuration.nix
            ./system-modules/hyprland.nix
            ./system-modules/kdeconnect.nix
            ./system-modules/mullvad.nix
            #./system-modules/nasmount.nix
            ./system-modules/plasma5.nix
            ./system-modules/printing.nix
            ./system-modules/protonmail-bridge.nix
            #./system-modules/python.nix
            ./system-modules/razer.nix
            ./system-modules/sddm.nix
            ./system-modules/theme.nix
            ./system-modules/theme-mocha.nix
            ./system-modules/virtualisation.nix

            # disko Moule
            disko.nixosModules.disko
            #./system-modules/disko-uefi-lvm-on-luks.nix
            #{
            #  _module.args.disks = [ "/dev/nvme0n1" ];
            #}

            # nur repo
            nur.nixosModules.nur

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.jf = import ./hosts/NixOS-Desktop/home-desktop;
              };
            }
          ];
        };

        NixOS-Gaming = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = inputs;

          modules = [
            # This is not a complete NixOS configuration and you need to reference
            # your normal configuration here.
            ./system
            ./hosts/NixOS-Gaming

            ./system-modules/amdcpu.nix
            #./system-modules/bigscreen.nix
            ./system-modules/corectrl.nix
            ./system-modules/flatpak.nix
            ./system-modules/fonts.nix
            ./system-modules/gamemode.nix
            ./system-modules/hardware-configuration.nix
            ./system-modules/kdeconnect.nix
            ./system-modules/nasmount.nix
            ./system-modules/nvidiagpu.nix
            ./system-modules/plasma5.nix
            ./system-modules/sddm.nix
            ./system-modules/steam.nix
            ./system-modules/theme.nix
            ./system-modules/theme-mocha.nix
            
            # disko Moule
            disko.nixosModules.disko
            ./system-modules/disko-uefi-lvm-on-luks.nix
            {
              _module.args.disks = [ "/dev/nvme0n1" ];
            }

            # nur repo
            nur.nixosModules.nur

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.sirmorton = import ./hosts/NixOS-Gaming/home-gaming;
              };
            }
          ];
        };

        NixOS-Laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = inputs;

          modules = [
            # This is not a complete NixOS configuration and you need to reference
            # your normal configuration here.
            ./system
            ./hosts/NixOS-Laptop

            ./system-modules/amdcpu.nix
            ./system-modules/amdgpu.nix
            ./system-modules/autostart.nix
            ./system-modules/flatpak.nix
            ./system-modules/fonts.nix
            #./system-modules/gdm.nix
            #./system-modules/gnome.nix
            ./system-modules/hardware-configuration.nix
            ./system-modules/hyprland.nix
            ./system-modules/kdeconnect.nix
            ./system-modules/mullvad.nix
            #./system-modules/nasmount.nix
            ./system-modules/plasma5.nix
            ./system-modules/printing.nix
            ./system-modules/protonmail-bridge.nix
            ./system-modules/python.nix
            ./system-modules/sddm.nix
            ./system-modules/theme.nix
            ./system-modules/theme-latte.nix
            #./system-modules/wireguard-client.nix

            # disko Moule
            disko.nixosModules.disko
            ./system-modules/disko-uefi-lvm-on-luks.nix
            {
              _module.args.disks = [ "/dev/nvme0n1" ];
            }

            # nur repo
            nur.nixosModules.nur

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.jf = import ./hosts/NixOS-Laptop/home-laptop;
              };
            }
          ];
        };

        NixOS-Server = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = inputs;

          modules = [
            # This is not a complete NixOS configuration and you need to reference
            # your normal configuration here.
            ./system
            ./hosts/NixOS-Server

            ./system-modules/docker.nix
            ./system-modules/fonts.nix
            ./system-modules/hardware-configuration.nix
            ./system-modules/intelcpu.nix
            #./system-modules/intelgpu.nix
            #./system-modules/nasmount.nix
            #./system-modules/python.nix
            ./system-modules/ssh.nix
            ./system-modules/virtualisation.nix

            # disko Moule
            disko.nixosModules.disko
            ./system-modules/disko-uefi-lvm-on-luks.nix
            {
              _module.args.disks = [ "/dev/sda" "/dev/sdb" ];
            }

            # nur repo
            nur.nixosModules.nur

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.admin = import ./hosts/NixOS-Server/home-server;
              };
            }
          ];
        };

        NixOS-Testing = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = inputs;

          modules = [
            # This is not a complete NixOS configuration and you need to reference
            # your normal configuration here.
            #./system
            ./hosts/NixOS-Testing

            #./system-modules/amdcpu.nix
            #./system-modules/amdgpu.nix
            ./system-modules/autostart.nix
            ./system-modules/flatpak.nix
            ./system-modules/fonts.nix
            #./system-modules/gdm.nix
            #./system-modules/gnome.nix
            ./system-modules/hardware-configuration.nix
            ./system-modules/hyprland.nix
            ./system-modules/kdeconnect.nix
            ./system-modules/mullvad.nix
            #./system-modules/nasmount.nix
            ./system-modules/plasma6.nix
            ./system-modules/printing.nix
            ./system-modules/protonmail-bridge.nix
            ./system-modules/python.nix
            ./system-modules/sddm.nix
            ./system-modules/theme.nix
            ./system-modules/theme-latte.nix
            #./system-modules/wireguard-client.nix

            # disko Moule
            disko.nixosModules.disko
            ./system-modules/disko-uefi-lvm-on-luks.nix
            {
              _module.args.disks = [ "/dev/nvme0n1" ];
            }

            # nur repo
            nur.nixosModules.nur

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                users.jf = import ./hosts/NixOS-Testing/home-testing;
              };
            }
          ];
        };
    };
  };
}

