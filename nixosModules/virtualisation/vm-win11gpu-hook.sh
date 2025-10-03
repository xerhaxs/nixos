# Thanks to:
# https://gitlab.com/risingprismtv/single-gpu-passthrough/
# https://github.com/QaidVoid/Complete-Single-GPU-Passthrough
# https://www.reddit.com/r/VFIO/comments/p4kmxr/tips_for_single_gpu_passthrough_on_nixos/

#!/run/current-system/sw/bin/bash

readonly GUEST_NAME="$1"
readonly HOOK_NAME="$2"
readonly STATE_NAME="$3"
VIRSH_GPU_VIDEO="0b:00.0"
VIRSH_GPU_AUDIO="0b:00.1"
VIRSH_GPU_VIDEO_IOMMU="pci_0000_0b_00_0"
VIRSH_GPU_AUDIO_IOMMU="pci_0000_0b_00_1"

function start_hook() {
  # Helpful to read output when debugging
  exec 19>/home/jf/Desktop/startlogfile.log
  BASH_XTRACEFD=19
  set -x

  # Stop display manager (KDE specific)
  systemctl stop display-manager
  killall pipewire
  killall pipewire-pulse

  # Unbind VTconsoles
  echo 0 > /sys/class/vtconsole/vtcon0/bind
  echo 0 > /sys/class/vtconsole/vtcon1/bind

  # Unbind EFI-Framebuffer
  echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

  # Avoid a race condition
  sleep 15

  # Unload all AMD drivers
  modprobe -r drm_kms_helper
  modprobe -r amdgpu
  modprobe -r radeon
  modprobe -r drm

  # Unbind the GPU from display driver
  virsh nodedev-detach $VIRSH_GPU_VIDEO_IOMMU
  virsh nodedev-detach $VIRSH_GPU_AUDIO_IOMMU

  # Load VFIO kernel module
  modprobe vfio
  modprobe vfio_pci
  modprobe vfio_iommu_type1
}

function revert_hook() {
  # Helpful to read output when debugging
  exec 19>/home/jf/Desktop/stoplogfile.log
  BASH_XTRACEFD=19
  set -x
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