{ config, pkgs, ... }:

{
  services.flatpak = {
    enable = true;
  };

  services.accounts-daemon.enable = true;

  system.activationScripts = {
    flatpak-installer-updater.sh = ''
      # List of desired Flatpak programs
      PROGRAM_LIST=(
        "com.github.tchx84.Flatseal"
        "com.discordapp.Discord"
        "com.valvesoftware.Steam"
        "com.heroicgameslauncher.hgl"
        "org.prismlauncher.PrismLauncher"
        "net.lutris.Lutris"
        "org.freedesktop.Platform.VulkanLayer.MangoHud"
      )

      # Additional commands after installing specific programs
      EXTRA_COMMANDS=(
        "com.valvesoftware.Steam:flatpak override --user --filesystem=/mount/Games/Spiele/Steam/ com.valvesoftware.Steam"
      )

      # Check if the Flathub repository is installed and add it if not
      if ! flatpak remote-list | grep -q "flathub"; then
          echo "Adding Flathub repository..."
          if ! flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; then
              echo "Error adding Flathub repository."
              exit 1
          fi
      fi

      # Function to install or update a Flatpak program
      install_or_update() {
          local PROGRAM="$1"
          local EXTRA_COMMAND="$2"

          # Check if the program is installed as a Flatpak
          if flatpak list | grep -q "$PROGRAM"; then
              echo "$PROGRAM is already installed."

              # Check for updates and update if available
              if flatpak update --appstream --assumeyes "$PROGRAM"; then
                  echo "$PROGRAM has been successfully updated."
              else
                  echo "Error updating $PROGRAM."
              fi
          else
              echo "$PROGRAM is not installed. Installation will begin..."

              # Install the program as a Flatpak
              if flatpak install --assumeyes flathub "$PROGRAM"; then
                  echo "$PROGRAM has been successfully installed."

                  # Execute additional commands if specified
                  if [ -n "$EXTRA_COMMAND" ]; then
                      local COMMANDS=($EXTRA_COMMAND)
                      local PROGRAM_NAME="${COMMANDS[0]}"
                      unset COMMANDS[0]
                      #echo "Executing additional commands for $PROGRAM_NAME: ${COMMANDS[*]}"
                      "${COMMANDS[@]}"
                  fi
              else
                  echo "Error installing $PROGRAM."
                  exit 1
              fi
          fi
      }

      # Iterate over the list of programs and perform installation/updating
      for PROGRAM in "${PROGRAM_LIST[@]}"; do
          EXTRA_COMMAND=""
          # Check if there are additional commands for the current program
          for CMD in "${EXTRA_COMMANDS[@]}"; do
              if [[ "$CMD" == "$PROGRAM"* ]]; then
                  EXTRA_COMMAND="${CMD#*:}"
                  break
              fi
          done
          install_or_update "$PROGRAM" "$EXTRA_COMMAND"
      done

      exit 0
    '';
  };
}
