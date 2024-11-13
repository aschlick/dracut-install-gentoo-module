#!/bin/bash

check() {
  require_binaries wget || return 1
  require_binaries tar || return 1
  require_binaries sfdisk || return 1
  require_binaries lsblk || return 1
  require_binaries cut || return 1
  require_binaries grep || return 1
  require_binaries mkfs.xfs || return 1
  return 0
}

depends() {
  echo bash network
  return 0
}

install() {
  inst /usr/bin/wget
  inst /usr/bin/tar
  inst /usr/bin/sfdisk
  inst /usr/bin/lsblk
  inst /usr/bin/cut
  inst /usr/bin/mkfs.xfs

  inst_hook pre-trigger 91 "$moddir/install-gentoo.sh"
}
