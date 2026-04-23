#!/usr/bin/env sh

set -e
set -x

MY_NIX_DIR=~/.config/nixos-config

cd "$MY_NIX_DIR"

SYSTEM=""

FLAKE="$1"
shift
STARTTIME="$(date)"
bin/build "${SYSTEM}" "${FLAKE}" "$@"

git commit -a -m "successful nix build for ${SYSTEM} #${FLAKE} at ${STARTTIME}"
