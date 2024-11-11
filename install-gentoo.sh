#!/bin/sh

function make_root_if_not_exists() {
  ROOT_DEVICE=$(lsblk -lo NAME,PARTTYPE,FSTYPE | grep 4f68bce3-e8cd-4db1-96e7-fbcaf984b709 | grep xfs | cut -f1 -d" ")

  if ! [ -b /dev/${ROOT_DEVICE} ]; then
    sfdisk /dev/nvme0 << EOF
,,L
EOF
    mkfs.xfs /dev/nvme0n1
  fi;

  mount ${ROOT_DEVICE} /
}

function copy_stage_4_if_no_portage() {
  wget schlicknas:/volume3/tftp/boot/stage4-amd64-systemd-local-v1.tar.xz
  tar xpvf stage4-*.tar.xz --xattrs-include='*.*' --numeric-owner -C /
}

setup_everything() {
  local ROOT_DEVICE=nothing
  make_root_if_not_exists
  copy_stage_4_if_no_portage
}

setup_everything
