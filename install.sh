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

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # Ansible requires this variable or python fork() will break it on MacOS
        export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
    fi  
    
    ansible-lint ansible/install.yml \
    && ansible-playbook ansible/install.yml \
        -e "project_basepath=$(pwd)"
    popd
}

ensure_dependencies \
&& ansible_install