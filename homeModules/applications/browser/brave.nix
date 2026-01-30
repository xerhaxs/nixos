{ config, lib, pkgs, ... }:

{
  options.homeManager = {
    applications.browser.brave = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable brave browser.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.browser.brave.enable {
    programs.brave = {
      enable = true;
      package = pkgs.brave;
      dictionaries = with pkgs; [
        hunspellDictsChromium.de_DE
        hunspellDictsChromium.en_US
      ];
      # Extensions need to be added to an automated script in brave
      # https://github.com/NeverDecaf/brave-web-store/releases
      # https://chromewebstore.google.com/detail/ublock-origin-lite/ddkjiahejlhfcafbddmgiahcphecmpfh
      # https://chromewebstore.google.com/detail/keepassxc-browser/oboonakemofpalcgghocfoadofidjkkk
      # https://chromewebstore.google.com/detail/simplelogin-by-proton-sec/dphilobhebphkdjbpfohgikllaljmgbn
      # https://chromewebstore.google.com/detail/plasma-integration/cimiefiiaegbelhefglklhhakcgmhkai
      # https://chromewebstore.google.com/detail/cookie-autodelete/fhcgjolkccmbidfldomjliifgaodjagh
      # https://chromewebstore.google.com/detail/snowflake/mafpmfcccpbjnhfhjnllmmalhifmlcie
      extensions = [
        #{ id = "fhcgjolkccmbidfldomjliifgaodjagh"; } # Cookie Autodelete
        { id = "edibdbjcniadpccecjdfdjjppcpchdlm"; } # I still don't care about cookies
        { id = "oboonakemofpalcgghocfoadofidjkkk"; } # KeePassXC
        { id = "dphilobhebphkdjbpfohgikllaljmgbn"; } # SimpleLogin
        { id = "mafpmfcccpbjnhfhjnllmmalhifmlcie"; } # Snowflake
        #{ id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin
        { id = "cimiefiiaegbelhefglklhhakcgmhkai"; } # Plasma Browser Integration
      ];
      commandLineArgs = [
        "--disable-features=AutofillSavePaymentMethods"
      ];
    };

    home.file."brave/policies.json".text = ''
      {
        "BraveAIChatEnabled": false,
        "BraveRewardsDisabled": true,
        "BraveWalletDisabled": true,
        "BraveVPNDisabled": true,
        "TorDisabled": true,
        "BraveP3AEnabled": false,
        "BraveStatsPingEnabled": false,
        "BraveWebDiscoveryEnabled": false,
        "BraveNewsDisabled": true,
        "BraveTalkDisabled": true,
        "BraveSpeedreaderEnabled": false,
        "BraveWaybackMachineEnabled": false,
        "BravePlaylistEnabled": false,
        "SyncDisabled": false,
        "PasswordManagerEnabled": false,
        "AutofillAddressEnabled": false,
        "AutofillCreditCardEnabled": false,
        "TranslateEnabled": false,
        "DnsOverHttpsMode": "secure",
        "DnsOverHttpsTemplates": "https://dns.adguard-dns.com/dns-query"
      }
    '';
  };
}