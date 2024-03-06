#!/usr/bin/env bash

# Add remote repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install Flatpaks
flatpak install flathub com.github.tchx84.Flatseal
flatpak install flathub com.discordapp.Discord
flatpak install flathub com.valvesoftware.Steam
flatpak install flathub com.heroicgameslauncher.hgl
flatpak install flathub org.prismlauncher.PrismLauncher
flatpak install flathub net.lutris.Lutris
#flatpak install flathub info.cemu.Cemu
#flatpak install flathub io.itch.itch
flatpak install flathub org.freedesktop.Platform.VulkanLayer.MangoHud
flatpak install org.freedesktop.Sdk.Extension.openjdk
#flatpak install org.freedesktop.Sdk.Extension.openjdk11
#flatpak install org.freedesktop.Sdk.Extension.openjdk8
flatpak install flathub me.hyliu.fluentreader

# Override Flatpak permissions
flatpak override --user --filesystem=/mount/Games/Spiele/Steam/ com.valvesoftware.Steam
