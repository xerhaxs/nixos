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

    nix-colors = {
      url = "github:misterio77/nix-colors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

  outputs = inputs@{ self, nixpkgs, nur, nixos-generators, ... }:
    let

      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };
      
    in {
    nixosConfigurations = {
      NixOS-Crafter = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # disko Moule
          #disko.nixosModules.disko
          #./system-modules/disko-bios-lvm-on-luks.nix
          #{
          #  _module.args.disks = [ "/dev/sda" ];
          #}

          # nur repo
          nur.nixosModules.nur
        ];
      };

      NixOS-Desktop = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          ./nixosModules/default.nix
          ./hosts/NixOS-Desktop/default.nix
          ./homeModules/default.nix
          
          # disko Moule
          #disko.nixosModules.disko
          #./system-modules/disko-uefi-lvm-on-luks.nix
          #{
          #  _module.args.disks = [ "/dev/nvme0n1" ];
          #}

          nur.nixosModules.nur
        ];
      };

      NixOS-Gaming = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = inputs;

        modules = [
          
          
          # disko Moule
          #disko.nixosModules.disko
          #./system-modules/disko-uefi-lvm-on-luks.nix
          #{
          #  _module.args.disks = [ "/dev/nvme0n1" ];
          #}

          # nur repo
          nur.nixosModules.nur
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
          #disko.nixosModules.disko
          #./system-modules/disko-uefi-lvm-on-luks.nix
          #{
          #  _module.args.disks = [ "/dev/nvme0n1" ];
          #}

          # nur repo
          nur.nixosModules.nur
        ];
      };

      NixOS-Server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = inputs;

        modules = [
          
          # disko Moule
          #disko.nixosModules.disko
          #./system-modules/disko-uefi-lvm-on-luks.nix
          #{
          #  _module.args.disks = [ "/dev/sda" "/dev/sdb" ];
          #}

          # nur repo
          nur.nixosModules.nur
        ];
      };

      NixOS-Testing = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = inputs;

        modules = [
          

          # disko Moule
          #disko.nixosModules.disko
          #./system-modules/disko-uefi-lvm-on-luks.nix
          #{
          #  _module.args.disks = [ "/dev/nvme0n1" ];
          #}

          # nur repo
          nur.nixosModules.nur
        ];
      };
    };
  };
}

