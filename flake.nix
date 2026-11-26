{
  description = "A NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-colors.url = "github:misterio77/nix-colors";

    blocklistproject = {
      url = "github:blocklistproject/Lists";
      flake = false;
    };

    perflyst = {
      url = "github:Perflyst/PiHoleBlocklist";
      flake = false;
    };

    stevenBlack = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };

    # On NixOS-Desktop ~/Documents is a symlink to the data disk.
    private = {
      url = "git+file:///home/jf/Documents/nixos-private";
      flake = false;
    };

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

    catppuccin-heroic = {
      url = "github:catppuccin/heroic";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hytale-launcher = {
      url = "github:JPyke3/hytale-launcher-nix";
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

    # Sources pinned to a release or commit: the version is in the URL, the hash in flake.lock.
    briar-mailbox = {
      url = "git+https://code.briarproject.org/briar/briar-mailbox.git?ref=refs/tags/release-1.0.9";
      flake = false;
    };
    dangerzone = {
      url = "github:freedomofpress/dangerzone/v0.11.0";
      flake = false;
    };
    hyprgrass-src = {
      url = "github:horriblename/hyprgrass/8e605468cbf429791d61ddbfaeb14ff5e08fec3e";
      flake = false;
    };
    # Fabric mods of the Minecraft server (Modrinth, Minecraft 26.3), every input mc-<project>
    # becomes mods/<project>.jar (hosts/NixOS-ServerGaming/minecraft.nix). The newest release each;
    # MezzConfig (needed by JEI) exists only as beta.
    mc-balm = {
      url = "https://cdn.modrinth.com/data/MBAkmtvl/versions/MYj31XNG/balm-fabric-26.3-26.3.0.3.jar";
      flake = false;
    };
    mc-better-craftables = {
      url = "https://cdn.modrinth.com/data/BLG002oq/versions/2UkGDTXL/BetterCraftables_v8.0.0%2Bmod_mc26.3.jar";
      flake = false;
    };
    mc-better-unpackables = {
      url = "https://cdn.modrinth.com/data/bUmlsA7b/versions/viTS04Xz/BetterUnpackables_v5.0.1%2Bmod_mc26.3.jar";
      flake = false;
    };
    mc-bluemap = {
      url = "https://cdn.modrinth.com/data/swbUV1cr/versions/SX74rxzP/bluemap-5.29-fabric.jar";
      flake = false;
    };
    mc-chunky = {
      url = "https://cdn.modrinth.com/data/fALzjamp/versions/86FKD9qx/Chunky-Fabric-1.5.66.jar";
      flake = false;
    };
    mc-fabric-api = {
      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/Zns5SSRA/fabric-api-0.166.2%2B26.3.jar";
      flake = false;
    };
    mc-happy-ghast-stopper = {
      url = "https://cdn.modrinth.com/data/LnG7iWcI/versions/qITVihgn/Happy_Ghast_Stopper_Mod.jar";
      flake = false;
    };
    mc-inventory-essentials = {
      url = "https://cdn.modrinth.com/data/Boon8xwi/versions/yTozEhFD/inventoryessentials-fabric-26.3-26.3.0.5.jar";
      flake = false;
    };
    mc-jei = {
      url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/Zebwcvua/jei-26.3-fabric-31.14.0.72.jar";
      flake = false;
    };
    mc-lithium = {
      url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/Lal8mJGR/lithium-fabric-0.26.4%2Bmc26.3.jar";
      flake = false;
    };
    mc-luckperms = {
      url = "https://cdn.modrinth.com/data/Vebnzrzj/versions/DzQPkkXY/LuckPerms-Fabric-5.5.85.jar";
      flake = false;
    };
    mc-mezzconfig = {
      url = "https://cdn.modrinth.com/data/7tEfOcA7/versions/26GXFp06/mezz_config-26.3-fabric-0.7.1.jar";
      flake = false;
    };
    mc-tabtps = {
      url = "https://cdn.modrinth.com/data/cUhi3iB2/versions/prer9z2m/tabtps-fabric-mc26.3-1.4.3.jar";
      flake = false;
    };
    mc-worldedit = {
      url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/ByRNkO83/worldedit-mod-7.4.6.jar";
      flake = false;
    };
    weishaupt-webif-api-src = {
      url = "https://files.pythonhosted.org/packages/source/w/weishaupt_webif_api/weishaupt_webif_api-0.1.4.tar.gz";
      flake = false;
    };
    wf-touch-src = {
      url = "github:WayfireWM/wf-touch/8974eb0f6a65464b63dd03b842795cb441fb6403";
      flake = false;
    };

    # Grafana dashboards, nix flake update fetches the latest revision.
    grafana-alertmanager = {
      url = "https://grafana.com/api/dashboards/9578/revisions/4/download";
      flake = false;
    };
    grafana-blackbox = {
      url = "https://grafana.com/api/dashboards/7587/revisions/3/download";
      flake = false;
    };
    grafana-nginx = {
      url = "https://grafana.com/api/dashboards/12708/revisions/1/download";
      flake = false;
    };
    grafana-node-exporter-full = {
      url = "https://grafana.com/api/dashboards/1860/revisions/46/download";
      flake = false;
    };
    grafana-pihole = {
      url = "https://grafana.com/api/dashboards/10176/revisions/3/download";
      flake = false;
    };
    grafana-postgresql = {
      url = "https://grafana.com/api/dashboards/9628/revisions/8/download";
      flake = false;
    };
    grafana-smartctl = {
      url = "https://grafana.com/api/dashboards/22604/revisions/4/download";
      flake = false;
    };
    grafana-unbound = {
      url = "https://grafana.com/api/dashboards/11705/revisions/1/download";
      flake = false;
    };
    grafana-zfs = {
      url = "https://grafana.com/api/dashboards/7845/revisions/4/download";
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
      overlay = import ./pkgs inputs;

      mkHost =
        hostName:
        nixpkgs.lib.nixosSystem {
          specialArgs = inputs // {
            inherit inputs;
          };
          modules = [
            {
              nixpkgs.hostPlatform = "x86_64-linux";
              nixpkgs.overlays = [ overlay ];
              system.configurationRevision = self.rev or self.dirtyRev or "unknown";
            }
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
        "NixOS-Portable"
        "NixOS-Server1"
        "NixOS-ServerGaming"
        "NixOS-ServerPublic"
        "NixOS-VMDesktop"
        "NixOS-VMServer1"
        "NixOS-VMServerGaming"
        "NixOS-VMServerPublic"
      ];

      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ overlay ];
      };

    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = mkHost host;
        }) hosts
      );

      packages.x86_64-linux = {
        inherit (pkgs) dangerzone update-images;
      };

      apps.x86_64-linux.update-images = {
        type = "app";
        program = nixpkgs.lib.getExe pkgs.update-images;
      };
    };
}
