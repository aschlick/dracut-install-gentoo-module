#!/bin/sh

function make_root_if_not_exists() {
  local DEVICE=nothing
  local TO_FORMAT=nothing
  ROOT_DEVICE=$(blkid /dev/sda1 -p -t PART_ENTRY_TYPE="4f68bce3-e8cd-4db1-96e7-fbcaf984b709" | grep xfs | cut -f1 -d":")
  # $(lsblk -lo NAME,PARTTYPE,FSTYPE | grep 4f68bce3-e8cd-4db1-96e7-fbcaf984b709 | grep xfs | cut -f1 -d" ")
  if [ -z "${ROOT_DEVICE}" ]; then
    if [ -b /dev/nvme0 ]; then
      DEVICE=/dev/nvme0n1
      TO_FORMAT=/dev/nvme0n1p1
    elif [ -b /dev/sda ]; then
      DEVICE=/dev/sda
      TO_FORMAT=/dev/sda1
    fi;
  else
    echo "Using root device ${ROOT_DEVICE}"
    DEVICE=/dev/sda
    TO_FORMAT=/dev/sda1
  fi;

  if [ ! -b ${ROOT_DEVICE} ] || [ ! -z "$(getarg installgentoo.force)" ]; then
    echo "Formatting ${DEVICE}"
    echo 'start=,size=,type=4f68bce3-e8cd-4db1-96e7-fbcaf984b709,name=ROOT' | sfdisk --wipe=always --label=gpt "${DEVICE}"
    partprobe

    echo "Making ${TO_FORMAT} xfs"
    mkfs.xfs -f $TO_FORMAT
    ROOT_DEVICE=$TO_FORMAT
  fi;

  echo "Mounting ${ROOT_DEVICE}"
  mount ${ROOT_DEVICE} /sysroot
}

function copy_stage_4_if_no_portage() {
  # wget schlicknas:/volume3/tftp/boot/stage4-amd64-systemd-local-v1.tar.xz
  if [ ! -f /sysroot/bin/emerge ] || [ ! -z "$(getarg installgentoo.force)" ]; then
    tar xpf /var/tmp/catalyst/builds/default/stage4-*.tar.bz2 --xattrs-include='*.*' --numeric-owner -C /sysroot/
  fi;
}

setup_everything() {
  echo "Starting install-gentoo, force: '$(getarg installgentoo.force)'"
  local ROOT_DEVICE=nothing
  if [ -b /dev/sda ]; then
    make_root_if_not_exists
    copy_stage_4_if_no_portage
  fi;
}

setup_everything
exit 192
