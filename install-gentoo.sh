#!/bin/sh

function make_root_if_not_exists() {
  local DEVICE=nothing
  local TO_FORMAT=nothing
  ROOT_DEVICE=$(lsblk -lo NAME,PARTTYPE,FSTYPE | grep 4f68bce3-e8cd-4db1-96e7-fbcaf984b709 | grep xfs | cut -f1 -d" ")
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
  fi;

  if ! [ -b /dev/${ROOT_DEVICE} ]; then
    echo "Formatting ${DEVICE}"
    sfdisk "${DEVICE}" << EOF
label: gpt
start=,size=,type=4f68bce3-e8cd-4db1-96e7-fbcaf984b709,name=ROOT
EOF
    echo "Making ${TO_FORMAT} xfs"
    mkfs.xfs $TO_FORMAT

    ROOT_DEVICE=$TO_FORMAT
  fi;

  echo "Mounting ${ROOT_DEVICE}"
  mkdir -p /mnt/gentoo
  mount ${ROOT_DEVICE} /mnt/gentoo
}

function copy_stage_4_if_no_portage() {
  wget schlicknas:/volume3/tftp/boot/stage4-amd64-systemd-local-v1.tar.xz
  tar xpvf stage4-*.tar.xz --xattrs-include='*.*' --numeric-owner -C /mnt/gentoo
  umount /mnt/gentoo
}

setup_everything() {
  echo "Starting install-gentoo"
  local ROOT_DEVICE=nothing
  make_root_if_not_exists
  copy_stage_4_if_no_portage
}

setup_everything
