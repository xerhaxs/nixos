{
  description = "A NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-colors.url = "github:misterio77/nix-colors";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    weishaupt-modbus = {
      url = "github:OStrama/weishaupt_modbus";
      flake = false;
    };

    adobe = {
      url = "https://blocklistproject.github.io/Lists/adobe.txt";
      flake = false;
    };
    ads = {
      url = "https://blocklistproject.github.io/Lists/ads.txt";
      flake = false;
    };
    amazonFireTV = {
      url = "https://perflyst.github.io/PiHoleBlocklist/AmazonFireTV.txt";
      flake = false;
    };
    malware = {
      url = "https://blocklistproject.github.io/Lists/malware.txt";
      flake = false;
    };
    oisd-big = {
      url = "https://big.oisd.nl/";
      flake = false;
    };
    oisd-small = {
      url = "https://small.oisd.nl/";
      flake = false;
    };
    phishing = {
      url = "https://blocklistproject.github.io/Lists/phishing.txt";
      flake = false;
    };
    ransomware = {
      url = "https://blocklistproject.github.io/Lists/ransomware.txt";
      flake = false;
    };
    redirect = {
      url = "https://blocklistproject.github.io/Lists/redirect.txt";
      flake = false;
    };
    scam = {
      url = "https://blocklistproject.github.io/Lists/scam.txt";
      flake = false;
    };
    smart-tv = {
      url = "https://blocklistproject.github.io/Lists/smart-tv.txt";
      flake = false;
    };
    stevenBlack = {
      url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
      flake = false;
    };
    tiktok = {
      url = "https://blocklistproject.github.io/Lists/tiktok.txt";
      flake = false;
    };
    tracking = {
      url = "https://blocklistproject.github.io/Lists/tracking.txt";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      catppuccin,
      ...
    }:
    let
      system = "x86_64-linux";

      mkHost =
        hostName:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs // {
            inherit inputs;
          };
          modules = [
            catppuccin.nixosModules.catppuccin
            ./nixosModules/default.nix
            ./hosts/${hostName}/default.nix
            ./homeModules/homemanager.nix
          ];
        };

      hosts = [
        "NixOS-Convertible"
        "NixOS-Desktop"
        "NixOS-Framework"
        "NixOS-Server1"
        "NixOS-Server2"
        "NixOS-Server3"
        "NixOS-ServerPublic"
        "NixOS-VMDesktop"
        "NixOS-VMServer"
      ];

    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = mkHost host;
        }) hosts
      );
    };
}
