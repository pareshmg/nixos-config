#!/usr/bin/env sh

set -e
set -x

MY_NIX_DIR=~/nixos-config

cd "$MY_NIX_DIR"

SYSTEM="$1"
shift

FLAKE="$2"
shift

bin/build "${SYSTEM}" "${FLAKE}" $@
