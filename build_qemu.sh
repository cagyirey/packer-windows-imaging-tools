#!/usr/bin/env bash
all_args=("$@")

if [[ "$OSTYPE" == "darwin"* ]]; then
    # Ansible requires this variable or python fork() will break it on MacOS
    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
fi

packer build --only=qemu -var "iso_url=$1" ./qemu_template_efi.json "${all_args[@]:2}"

