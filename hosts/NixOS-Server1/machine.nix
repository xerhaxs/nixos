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
    intelgpu.enable = true;
  };

  nixos.system.initrdssh = {
    enable = true;
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyndaaCmTLHdA5+sLBbxgSZNC6KXKtZkKiMK6AAY8Rt jf@NixOS-Desktop"
    ];
    kernelModules = [ "r8169" ];
  };

  nixos.system.secureboot.enable = true;
  nixos.disko.disko-luks-btrfs-tmpfs.tpm2 = true;

  nixos.server.dataDir = "/pool01/applications";
  nixos.server.fileshare.share.path = "/pool01/shares";

  nixos.system.clamav = {
    extraScanDirectories = [ "/pool01/shares" ];
    excludePaths = [ "^/pool01/shares/video" ];
    # Checked 10.11.2026 (TODO 13.24): Win10XPE build project, a joke program from a floppy disk and
    # a 2003 mail in old mail copies, all kept on purpose.
    acknowledged =
      let
        papa = "/pool01/shares/document/Papa File Share";
      in
      [
        {
          path = "${papa}/Backup/ctnotwin/*";
          signature = "Win.*";
        }
        {
          path = "/pool01/shares/document/Disketten_Digitalisierung/Have-Fun/have_fun.zip";
          signature = "Win.Joke.*";
        }
        {
          path = "${papa}/Outlook Export/*";
          signature = "*Phishing*";
        }
        {
          path = "${papa}/*/Thunderbird/Profiles/*";
          signature = "*Phishing*";
        }
        {
          path = "/pool01/shares/jf/Dokumente/Wichtige Datein/Mail/*";
          signature = "*Phishing*";
        }
      ];
  };
}
