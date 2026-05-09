{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  options.homeManager = {
    applications.office.financial = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Enable financial tools.";
      };
    };
  };

  config = lib.mkIf config.homeManager.applications.office.financial.enable {
    home.packages = with pkgs; [
      bisq2
      monero-gui
      p2pool
      xmrig
    ];

    home.activation.moneroConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        CONFIG="$HOME/.config/monero-project/monero-gui.conf"
        mkdir -p "$(dirname "$CONFIG")"
        if [ ! -f "$CONFIG" ]; then
          cat > "$CONFIG" << EOF
      [General]
      account_name=
      allowRemoteNodeMining=false
      allow_background_mining=false
      allow_p2pool_mining=false
      askDesktopShortcut=false
      askPasswordBeforeSending=true
      askStopLocalNode=true
      autosave=true
      autosaveMinutes=10
      blackTheme=true
      blockchainDataDir=/mount/Data/Datein/Monero
      bootstrapNodeAddress=
      chainDropdownSelected=0
      checkForUpdates=false
      customDecorations=true
      daemonFlags=
      daemonPassword=
      daemonUsername=
      displayWalletNameInTitleBar=true
      fiatPriceCurrency=xmreur
      fiatPriceEnabled=true
      fiatPriceProvider=kraken
      fiatPriceToggle=false
      hideBalance=false
      historyHumanDates=true
      historyShowAdvanced=false
      is_recovering=false
      is_recovering_from_device=false
      is_trusted_daemon=false
      kdfRounds=1
      keyReuseMitigation2=true
      language=English (US)
      language_wallet=English
      locale=en_US
      lockOnUserInActivity=true
      lockOnUserInActivityInterval=10
      logCategories=
      logLevel=0
      miningIgnoreBattery=true
      miningModeSelected=0
      nettype=0
      p2poolFlags=
      proxyAddress=127.0.0.1:9050
      proxyEnabled=false
      pruneBlockchain=true
      receiveShowAdvanced=false
      remoteNodeAddress=
      remoteNodesSerialized="{\"selected\":0,\"nodes\":[]}"
      restore_height=2318014
      segregatePreForkOutputs=true
      segregationHeight=0
      transferShowAdvanced=false
      useRemoteNode=false
      walletMode=2
      wallet_path=${config.xdg.userDirs.documents}/Wichtige Datein/Wallet/Monero/xerhaxs_monero/xerhaxs_monero.keys

      [QQControlsFileDialog]
      favoriteFolders=@Invalid()
      height=0
      sidebarSplit=125.55000000000001
      sidebarVisible=true
      sidebarWidth=80
      width=0
      EOF
        fi
    '';

    home.persistence."/persistent" = lib.mkIf osConfig.nixos.disko.disko-luks-btrfs-tmpfs.enable {
      directories = [
        ".config/monero-project"
        ".local/share/Bisq2"
      ];
    };
  };
}
