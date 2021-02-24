#!/usr/bin/env bash

function ensure_dependencies () {
    # install dependency packages here
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install ansible ansible-lint gdisk qemu # osxfuse ntfs-3g coreutils

    elif [[ "$OSTYPE" == "linux"* ]]; then
        # todo
        # sudo apt-get update
        # sudo apt-get install ansible ansible-lint qemu
        echo "Sorry, the packer config for linux isn't complete yet! Please use macOS."
        exit -1
    fi

    git submodule update --recursive
}

function ansible_install () {
    pushd $(dirname "$0")
    ansible-lint ansible/install.yml \
    && ansible-playbook ansible/install.yml \
        -e "project_basepath=$(pwd)"
    popd
}

ensure_dependencies \
&& ansible_install