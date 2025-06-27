#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="kyos"
iso_label="ARCH_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="KyOS <https://kyos.dev>"
iso_application="KyOS Live/Rescue DVD"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito'
           'uefi-ia32.systemd-boot.esp' 'uefi-x64.systemd-boot.esp'
           'uefi-ia32.systemd-boot.eltorito' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/doas.conf"]="0:0:400"
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:0400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/local/bin/kyosinstall"]="0:0:755"
  ["/usr/local/bin/kyos-welcome"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
  ["/usr/local/bin/auto-login-live"]="0:0:755"
  ["/usr/local/bin/start-qtile-live"]="0:0:755"
  ["/usr/local/bin/live-session-start"]="0:0:755"
  ["/usr/local/bin/kyosinstall-auto"]="0:0:755"
  ["/usr/local/bin/kyosinstall-tui"]="0:0:755"
  ["/usr/local/bin/installer"]="0:0:755"
)
