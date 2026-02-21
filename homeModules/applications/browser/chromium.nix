{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.homeManager = {
    applications.browser.chromium = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable Chromium browser.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.browser.chromium.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      dictionaries = with pkgs; [
        hunspellDictsChromium.de_DE
        hunspellDictsChromium.en_US
      ];
      # Extensions need to be added to an automated script in ungoogled chromium
      # https://github.com/NeverDecaf/chromium-web-store/releases
      # https://chromewebstore.google.com/detail/ublock-origin-lite/ddkjiahejlhfcafbddmgiahcphecmpfh
      # https://chromewebstore.google.com/detail/keepassxc-browser/oboonakemofpalcgghocfoadofidjkkk
      # https://chromewebstore.google.com/detail/simplelogin-by-proton-sec/dphilobhebphkdjbpfohgikllaljmgbn
      # https://chromewebstore.google.com/detail/plasma-integration/cimiefiiaegbelhefglklhhakcgmhkai
      # https://chromewebstore.google.com/detail/cookie-autodelete/fhcgjolkccmbidfldomjliifgaodjagh
      # https://chromewebstore.google.com/detail/snowflake/mafpmfcccpbjnhfhjnllmmalhifmlcie
      extensions = [
        { id = "fhcgjolkccmbidfldomjliifgaodjagh"; } # Cookie Autodelete
        { id = "edibdbjcniadpccecjdfdjjppcpchdlm"; } # I still don't care about cookies
        { id = "oboonakemofpalcgghocfoadofidjkkk"; } # KeePassXC
        { id = "dphilobhebphkdjbpfohgikllaljmgbn"; } # SimpleLogin
        { id = "mafpmfcccpbjnhfhjnllmmalhifmlcie"; } # Snowflake
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin
        { id = "cimiefiiaegbelhefglklhhakcgmhkai"; } # Plasma Browser Integration
      ];
    };
  };
}
