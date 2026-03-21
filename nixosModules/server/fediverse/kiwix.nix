{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.nixos = {
    server.fediverse.kiwix = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable kiwix server.";
      };
    };
  };

  config = lib.mkIf config.nixos.server.fediverse.kiwix.enable {
    systemd.services.kiwix-serve.serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "kiwix";
      Group = "kiwix";
    };

    services.kiwix-serve = {
      enable = true;
      openFirewall = false;
      address = "all";
      port = 2793;
      libraryPath = "/pool01/applications/kiwix/data";
      library = {
        #"nhs.uk_en_medicines_2025-12" = "/pool01/applications/kiwix/data/nhs.uk_en_medicines_2025-12.zim";
        /*
          wikipedia_de_all_maxi_2026-01 = pkgs.fetchurl {
            url = "https://download.kiwix.org/zim/wikipedia/wikipedia_de_all_maxi_2026-01.zim";
            hash = "sha256:fe33a239b4cde6b83a5e0d5f005962f8e51595d62d9ca7e08401434c57d67f61";
          };
          wiktionary_de_all_nopic_2026-01 = pkgs.fetchurl {
            url = "https://download.kiwix.org/zim/wiktionary/wiktionary_de_all_nopic_2026-01.zim";
            hash = "sha256:18e80a0bf32ecfc38d4926e729102173b614abb418b9eff3ec78afce9da60482";
          };
          ifixit_de_all_2025-06 = pkgs.fetchurl {
            url = "https://download.kiwix.org/zim/ifixit/ifixit_de_all_2025-06.zim";
            hash = "sha256:c69395f4bbfb0a6584d754829d638266ef1da3940af05a072b574dea5c18e105";
          };
          wikivoyage_de_all_maxi_2026-01 = pkgs.fetchurl {
            url = "https://download.kiwix.org/zim/wikivoyage/wikivoyage_de_all_maxi_2026-01.zim";
            hash = "sha256:865e01feec69b764c2f680280a978c178abd6691f74df59841c488f297f11a90";
          };
          gutenberg_de_all_2026-01 = pkgs.fetchurl {
            url = "https://download.kiwix.org/zim/gutenberg/gutenberg_de_all_2026-01.zim";
            hash = "sha256:9bd31418e9b056b1d3bc4c3892cdcb55ea71b530d93a9f177a5f034ff7aedc0b";
          };
          #gutenberg_mul_all_2025-11 = pkgs.fetchurl {
          #  url = "https://download.kiwix.org/zim/gutenberg/gutenberg_mul_all_2025-11.zim";
          #  hash = "sha256:5c6b8415c68027d19022b2024b6c4b3b195ac11228c75e6a649b869b535d5d17";
          #};
          wikipedia_en_all_maxi_2026-02 = pkgs.fetchurl {
            url = "https://download.kiwix.org/zim/wikipedia/wikipedia_en_all_maxi_2026-02.zim";
            hash = "sha256:bf0853bf94ed8c53524e5ee67288bc4898819bc9d496af2b3f852b6588abdd27";
          };
          wiktionary_en_all_nopic_2026-02 = pkgs.fetchurl {
            url = "https://download.kiwix.org/zim/wiktionary/wiktionary_en_all_nopic_2026-02.zim";
            hash = "sha256:9825fce692e3de441c433faa58e1817e782232ebd7dc802e812d4c72d9e94abf";
          };
          fas-military-medicine_en_2025-06 = pkgs.fetchurl {
            url = "https://download.kiwix.org/zim/zimit/fas-military-medicine_en_2025-06.zim";
            hash = "sha256:d33d6fa16b809f7d2bb91c00cb8e8d8bb31c674ff5a5eea574ba430f4245b785";
          };
          survivorlibrary.com_en_all_2025-12 = pkgs.fetchurl {
            url = "https://download.kiwix.org/zim/zimit/survivorlibrary.com_en_all_2025-12.zim";
            hash = "sha256:c812c4ba3b9bcf7b77864cc965d526336d487e1b9ddc9364bad68fc55d2862e3";
          };
          nhs.uk_en_medicines_2025-12 = pkgs.fetchurl {
            url = "https://download.kiwix.org/zim/zimit/nhs.uk_en_medicines_2025-12.zim";
            hash = "sha256:7dfa9bffa286e1ed4442536e746109a58d678bc6681af0b9881e07b7ef3dae28";
          };
        */
      };
      extraArgs = [ ];
    };

    services.nginx = {
      virtualHosts = {
        "kiwix.${config.nixos.server.network.nginx.domain}" = {
          forceSSL = true;
          enableACME = true;
          acmeRoot = null;
          kTLS = true;
          http2 = false;
          locations."/" = {
            proxyPass = "http://localhost:64738";
          };
        };
      };
    };
  };
}
