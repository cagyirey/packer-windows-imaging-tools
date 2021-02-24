#!/usr/bin/env bash

function write_host() {
    echo `tput setaf 2`$1`tput sgr0`
}

function write_err() {
    echo `tput setaf 1`$1`tput sgr0`   
}

function resize_qemu_image () {
    if [ -z ${QEMU_OUTPUT_PATH} ]; then
       echo "QEMU_OUTPUT_PATH environment variable is not defined. This script should only be used from the Packer template."
       return -1
    fi

    LAST_SECTOR=$(gdisk -l ${QEMU_OUTPUT_PATH} | awk '/Basic data partition/{print $3}')
    if [ -z "${LAST_SECTOR}" ]; then
        "Unable to obtain partition data using gdisk. Exiting."
        return -1
    fi

    # Shrink the virtual disk by cutting it off at (${LAST_SECTOR} + 100) * 512
    # This will work as long as the disk sector size is the default of 512.
    # We leave 100 sectors of slack room for the mirrored GPT header at the end
    IMAGE_SIZE=$(((${LAST_SECTOR} + 100) * 512))
    qemu-img resize --shrink ${QEMU_OUTPUT_PATH} ${IMAGE_SIZE}
    if [[ $? != 0 ]]; then
        write_err "[-] Failed to shrink disk image. Exiting."
        return -1
    fi
    write_host "[+] Image resized."
    

    # Repair GPT headers
    sgdisk -C -e ${QEMU_OUTPUT_PATH}
    if [[ $? != 0 ]]; then
        write_err "[-] Failed to repair GPT. Exiting."
        return -1
    fi
    write_host "[+] GUID partition table repaired."
    write_host "[+] All operations completed successfully."
    return 0
    # # Clear NTFS dirty bit (which prevents ubuntu/curtin from mounting the image as r+w)
    # PART_DATA=$(sudo hdiutil attach -imagekey diskimage-class=CRawDiskImage -noverify -nomount ${QEMU_OUTPUT_PATH})
    # MOUNT_DEVICE=$(${PART_DATA} | awk '/Microsoft Basic/{print $1}')

    # if [[ $? == 0  ]] && [[ -n ${MOUNT_DEVICE} ]]; then
    #     sudo ntfsfix --clear-dirty ${MOUNT_DEVICE}

    #     if [[ $? != 0 ]]; then
    #         write_err "[-] Failded to clear NTFS dirty bit. Exiting."
    #         sudo umount ${MOUNT_DEVICE}
    #         return -1
    #     fi
    #     write_host "[+] NTFS data partition repaired."

    #     sudo umount ${MOUNT_DEVICE}
    #     write_host "[+] All operations completed successfully."
    #     return 0
    # else
    #     write_err "[-] Failed to mount disk image. Exiting."
    #     return -1  
    # fi
}

resize_qemu_image
exit $?
