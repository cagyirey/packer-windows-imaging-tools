### EFI Firmware

This folder houses the [OVMF firmware](https://www.kraxel.org/repos/) from the [EDK2 project](https://github.com/tianocore/edk2), an open source port of Intel's Tianocore EFI firmware. QEMU uses this firmware for UEFI boot; this folder should not be deleted, and the appropriate firmware will be downloaded and extracted here by `install.sh`