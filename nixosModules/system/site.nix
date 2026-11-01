{
  config,
  lib,
  private,
  ...
}:

let
  site = import "${private}/site.nix";

  mkSiteOption =
    type: name: description:
    lib.mkOption {
      inherit type description;
      default = site.${name};
      defaultText = lib.literalExpression "private site.nix (${name})";
    };
in

{
  options.nixos = {
    site = {
      domain = mkSiteOption lib.types.str "domain" "Main public domain (public services).";
      homeDomain = mkSiteOption lib.types.str "homeDomain" "Domain of the services in the home network.";
      mailDomain =
        mkSiteOption lib.types.str "mailDomain"
          "Domain of the mail addresses and the mail server.";
      acmeEmail = mkSiteOption lib.types.str "acmeEmail" "Contact address for ACME (Let's Encrypt).";
      alertEmail = mkSiteOption lib.types.str "alertEmail" "Recipient of system alerts.";
      mailAddress = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = site.mailAddress or null;
        defaultText = lib.literalExpression "private site.nix (mailAddress)";
        description = "Own mail address on the mail server (Thunderbird account).";
      };
      mailRealName = lib.mkOption {
        type = lib.types.str;
        default = site.mailRealName or "";
        defaultText = lib.literalExpression "private site.nix (mailRealName)";
        description = "Display name of the own mail address.";
      };
      pgpFingerprint = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = site.pgpFingerprint or null;
        defaultText = lib.literalExpression "private site.nix (pgpFingerprint)";
        description = "Fingerprint of the own OpenPGP key (Thunderbird identity, GnuPG default key).";
      };
      pgpPublicKey = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default =
          if builtins.pathExists "${private}/pgp/public.asc" then "${private}/pgp/public.asc" else null;
        defaultText = lib.literalExpression "private pgp/public.asc if it exists";
        description = "Own OpenPGP public key (ASCII armored), published by WKD on the mail server and imported into GnuPG.";
      };
      initialHashedPasswords = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = site.initialHashedPasswords or { };
        defaultText = lib.literalExpression "private site.nix (initialHashedPasswords)";
        description = "Initial password hash of the user per host (lowercase hostname), used until user.passwordFromSops is enabled.";
      };
      serverPublic =
        mkSiteOption (lib.types.attrsOf lib.types.anything) "serverPublic"
          "Network data of NixOS-ServerPublic.";
    };
  };
}
