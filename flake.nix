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

    flatpak = {
      url = "github:GermanBread/declarative-flatpak/stable";
    };
  };

  outputs = inputs@{ self, nixpkgs, disko, nur, nixos-generators, home-manager, plasma-manager, sops-nix, flatpak, ... }:
    let
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        inherit plasma-manager;
        inherit flatpak;
      };
    in {
    nixosConfigurations = {
      NixOS-Crafter = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          
          sops-nix.nixosModules.sops
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
        inherit system;

        specialArgs = { 
          inherit inputs;
        };

        modules = [
          ./nixosModules/default.nix
          ./hosts/NixOS-Desktop/default.nix
          sops-nix.nixosModules.sops

          # disko Moule
          disko.nixosModules.disko
          #./system-modules/disko-uefi-lvm-on-luks.nix
          #{
          #  _module.args.disks = [ "/dev/nvme0n1" ];
          #}

          nur.nixosModules.nur
          #flatpak.nixosModules.default
          #plasma-manager.nixosModules.plasma-manager

        ];
      };

      NixOS-Gaming = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = inputs;

        modules = [
          
          
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

      NixOS-ISO = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = inputs;

        modules = [
          ./system-modules/installer.nix
        ];
      };

      NixOS-Laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = inputs;

        modules = [
          

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

