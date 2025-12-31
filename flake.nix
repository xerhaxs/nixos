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

    impermanence = {
      url = "github:nix-community/impermanence";
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
  };

  outputs = inputs@{ self, nixpkgs, catppuccin, nixos-generators, ... }:
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
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Convertible/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-Desktop = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Desktop/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-Framework = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Framework/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-Server1 = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
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
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-Server3/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-ServerPublic = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-ServerPublic/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-VMDesktop = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-VMDesktop/default.nix
          ./homeModules/homemanager.nix
        ];
      };

      NixOS-VMServer = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = inputs;

        modules = [
          catppuccin.nixosModules.catppuccin
          ./nixosModules/default.nix
          ./hosts/NixOS-VMServer/default.nix
          ./homeModules/homemanager.nix
        ];
      };
    };
  };
}

