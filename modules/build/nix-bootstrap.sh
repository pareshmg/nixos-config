#!/usr/bin/env sh


set -e
set -x

MY_NIX_DIR=~/nixos-config
SECRETS_DIR=~/.nix-secrets

GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
CLEAR='\033[0m'
NIXPKGS_ALLOW_UNFREE=1

if [ "$(uname)" == "Darwin" ]; then
    FLAKE="${1:-pmp}"
else
    FLAKE="${1:-vm}"
fi


# Checkout base template
if [ ! -d "$MY_NIX_DIR" ]; then
    cd ~/
    git clone https://github.com/pareshmg/nixos-config.git "$MY_NIX_DIR"
else
    echo "${YELLOW} nixos directory ${MY_NIX_DIR} already exists. Skipping repo clone ${CLEAR}"
fi


if [ ! -d "$SECRETS_DIR" ]; then
    cd "$MY_NIX_DIR"
    DEFAULT_USER=$(whoami)
    read -r -p "What is your laptop username? [default: $DEFAULT_USER] " LAPTOP_USERNAME
    LAPTOP_USERNAME=${LAPTOP_USERNAME:-"${DEFAULT_USER}"}

    DEFAULT_NAME=$(whoami)
    read -r -p "What is your full name? [default: $DEFAULT_NAME] " FULL_NAME
    FULL_NAME=${FULL_USERNAME:-"${DEFAULT_NAME}"}

    DEFAULT_EMAIL="me@$(whoami).com"
    read -r -p "What is your email? [default: $DEFAULT_EMAIL] " LAPTOP_EMAIL
    LAPTOP_EMAIL=${LAPTOP_EMAIL:-"${DEFAULT_EMIAL}"}

    mkdir -p "${SECRETS_DIR}"

    < secrets_example/flake.nix sed "s/yourname/${LAPTOP_USERNAME}/g" | sed "s/Your Name/${FULL_NAME}/g" | sed "s/personal@email.com/${DEFAULT_EMAIL}/g" > "${SECRETS_DIR}/flake.nix"

    cd "${SECRETS_DIR}"
    git init .
    git add .
    git commit -a -m "feat: [BOT] nix initialized flake"

else
    echo "${YELLOW} secrets directory ${SECRETS_DIR} already exists. Skipping init ${CLEAR}"
fi

# install homebrew if it is not installed
if [ "$(uname)" == "Darwin" ]; then
    PATH=$PATH:/opt/homebrew/bin:/System/Volumes/Data/opt/homebrew/bin
    if ! [ -x "$(command -v brew)" ]; then
        echo "Brew not installed. Installing";
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
fi


echo "${GREEN} secrets directory ${SECRETS_DIR} already exists. Skipping init ${CLEAR}"
read -r -p "Please edit your nixos-config and press enter to continue" ENTER_TO_CONTINUE

cd "$MY_NIX_DIR"
nix --extra-experimental-features 'nix-command flakes' run .#nix-rebuild -- "${FLAKE}" $@
