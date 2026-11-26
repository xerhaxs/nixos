{
  config,
  lib,
  pkgs,
  ...
}:

{
  system.stateVersion = "25.11";

  nixos.hardware = {
    amdcpu.enable = true;
    amdgpu.enable = true;
  };

  nixos.system.clamav = {
    extraScanDirectories = [ "/mount/Data/Datein" ];
    # Checked 10.11.2026: a 2003 mail in the 1&1 account and in old mail copies.
    acknowledged = [
      {
        path = "/mount/Data/Datein/Dokumente/Wichtige Datein/*";
        signature = "*Phishing*";
      }
      {
        path = "/home/*/.thunderbird/*/ImapMail/*/TF-Mails.sbd/PC-Infos";
        signature = "Email.Phishing.VOF1-*";
      }
      # 32-bit d3d11.dll of DXVK (Heroic, winetricks cache, Wine prefixes), 2 of 70 engines on
      # VirusTotal, the same file from independent sources.
      {
        path = "*/d3d11.dll";
        signature = "Win.Trojan.Virut-248*";
      }
      {
        path = "*/winetricks/dxvk/*";
        signature = "Win.Trojan.Virut-248*";
      }
    ];
  };

  nixos.system.secureboot.enable = true;
  nixos.disko.disko-luks-btrfs-tmpfs.tpm2 = true;
}
