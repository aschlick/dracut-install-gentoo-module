#!/bin/bash

check() {
  require_binaries \
    wget \
    tar \
    sfdisk \
    lsblk \
    cut \
    grep \
    mkfs.xfs \
    bzip2 \
    partprobe \
    || return 1
  return 0
}

depends() {
  echo bash
  return 0
}

install() {
  inst /usr/bin/wget
  inst /usr/bin/tar
  inst /usr/bin/sfdisk
  inst /usr/bin/lsblk
  inst /usr/bin/cut
  inst /usr/bin/mkfs.xfs
  inst /usr/bin/bzip2
  inst /usr/bin/passwd
  inst /usr/bin/partprobe
  inst /var/tmp/catalyst/builds/default/stage4-amd64-systemd-local-v1.tar.bz2

  inst_hook pre-udev 91 "$moddir/install-gentoo.sh"
}
