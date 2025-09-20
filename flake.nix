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

    catppuccin = {
      url = "github:catppuccin/nix";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    flatpaks = {
      url = "github:GermanBread/declarative-flatpak/dev";
    };
  };

  outputs = inputs@{ self, nixpkgs, catppuccin, nur, nixos-generators, ... }:
    let

      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };
      
    in {
    nixosConfigurations = {
      NixOS-Convertible = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          nur.modules.nixos.default
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Convertible/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-Crafter = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          nur.modules.nixos.default
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Crafter/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-Desktop = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          nur.modules.nixos.default
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Desktop/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-ISO = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          ./system-modules/installer.nix
        ];
      };

      NixOS-Framework = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          nur.modules.nixos.default
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Framework/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-Laptop = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          nur.modules.nixos.default
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Laptop/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-Live = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          nur.modules.nixos.default
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Live/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-Server1 = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          nur.modules.nixos.default
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Server1/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-Server2 = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          nur.modules.nixos.default
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Server2/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-Server3 = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          nur.modules.nixos.default
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Server3/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-Test = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          nur.modules.nixos.default
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Test/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-Workshop = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          nur.modules.nixos.default
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Workshop/default.nix
          ./homeModules/homemanager.nix
        ];
      };
    };
  };
}

