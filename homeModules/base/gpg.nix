{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  options.homeManager = {
    base.gpg = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable GnuPG with gpg-agent (keys are looked up by WKD first, the own public key is imported).";
      };
    };
  };

  config = lib.mkIf config.homeManager.base.gpg.enable {
    programs.gpg = {
      enable = true;
      settings = {
        default-key = lib.mkIf (
          osConfig.nixos.site.pgpFingerprint != null
        ) osConfig.nixos.site.pgpFingerprint;
        auto-key-locate = "local,wkd,keyserver";
        keyserver = "hkps://keys.openpgp.org";
        auto-key-retrieve = true;
        with-fingerprint = true;
        keyid-format = "0xlong";
        no-emit-version = true;
        no-comments = true;
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        cert-digest-algo = "SHA512";
      };
      publicKeys = lib.optional (osConfig.nixos.site.pgpPublicKey != null) {
        source = osConfig.nixos.site.pgpPublicKey;
        trust = 5;
      };
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 600;
      maxCacheTtl = 3600;
      pinentry.package = if osConfig.nixos.desktop.enable then pkgs.pinentry-qt else pkgs.pinentry-curses;
    };
  };
}
