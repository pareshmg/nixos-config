#!/usr/bin/env sh
# shellcheck disable=all

set -e
set -x

MY_NIX_DIR=~/nixos-config
SECRETS_DIR=~/.nix-secrets

GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
CLEAR='\033[0m'
export NIXPKGS_ALLOW_UNFREE=1

if [ "$(uname)" == "Darwin" ]; then
    FLAKE="${1:-pmp}"
    shift
else
    FLAKE="${1:-vm}"
    shift
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
    LAPTOP_EMAIL=${LAPTOP_EMAIL:-"${DEFAULT_EMAIL}"}

    mkdir -p "${SECRETS_DIR}"

    if [ ! -e "secrets_example/flake.nix" ]; then
        echo "${RED}secrets flake template not found!!${CLEAR}"
    fi

    < secrets_example/flake.nix sed "s/yourname/${LAPTOP_USERNAME}/g" | sed "s/Your Name/${FULL_NAME}/g" | sed "s/personal@email.com/${LAPTOP_EMAIL}/g" > "${SECRETS_DIR}/flake.nix"

    cd "${SECRETS_DIR}"
    git init .
    git add .
    git config user.email "${LAPTOP_EMAIL}"
    git config user.name "${FULL_NAME}"
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

read -r -p "${GREEN} Going to build flake ${FLAKE}. Enter to continue. X to abort? ${CLEAR}" UINPUT
if [[ "$UINPUT" =~ ^[xX]$ ]]
then
    return
fi

read -r -p "${GREEN} Please edit your nixos-config in ${MY_NIX_DIR}/flake.nix. Enter to continue. X to abort ${CLEAR}" UINPUT
if [[ "$UINPUT" =~ ^[xX]$ ]]
then
    return
fi

read -r -p "${GREEN} Please edit your profile in ${SECRETS_DIR}. Enter to continue. X to abort ${CLEAR}" UINPUT
if [[ "$UINPUT" =~ ^[xX]$ ]]
then
    return
fi


cd "$MY_NIX_DIR"
nix --extra-experimental-features 'nix-command flakes' run .#rebuild -- "${FLAKE}" "$@"
