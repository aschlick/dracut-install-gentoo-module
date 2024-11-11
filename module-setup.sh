#!/bin/bash

check() {
  require_binaries wget || return 1
  require_binaries tar || return 1
  return 0
}

depends() {
  echo bash
  return 0
}

install() {
  inst /usr/bin/wget
  inst /usr/bin/tar
  inst_hook pre-mount 91 "$moddir/install-gentoo.sh"
}
