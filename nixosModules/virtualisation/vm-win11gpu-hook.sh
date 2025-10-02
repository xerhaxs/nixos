#!/run/current-system/sw/bin/bash

readonly GUEST_NAME="$1"
readonly HOOK_NAME="$2"
readonly STATE_NAME="$3"

function start_hook() {
  # Stops GUI
  systemctl isolate multi-user.target

  # Avoids race condition
  sleep 2

  # Unloads the NVIDIA drivers
  modprobe -r amdgpu

  # Other code you might want to run
}

function revert_hook() {
  # Other stuff you might want to revert

  # Loads the NVIDIA drivers
  modprobe amdgpu

  # Starts the UI again
  systemctl isolate graphical.target
}

# I am not using the script from Passthrough-Post
# because hooks option saves it to /var/lib/libvirt/hooks/qemu.d.
# It's simpler to just rewrite it for NixOS.
if [[ "$GUEST_NAME" != "win11gpu" ]]; then
  exit 0
fi

if [[ "$HOOK_NAME" == "prepare" && "$STATE_NAME" == "begin" ]]; then
  start_hook
elif [[ "$HOOK_NAME" == "release" && "$STATE_NAME" == "end" ]]; then
  revert_hook
fi