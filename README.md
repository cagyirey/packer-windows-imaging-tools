## Packer Windows Imaging Tools

This repo contains Packer templates for generating Windows images usable with [MAAS](https://maas.io/), a bare-metal hardware provisioning tool. Currently, it supports QEMU on MacOS but Linux and VirtualBox support is planned. For now, this is just a quick install guide for those who wish to experiment with the alpha version.


### Installing

1. `git clone https://github.com/cagyirey/packer-windows-imaging-tools.git`
2. Run `install.sh`. This will `brew install` the relevant system dependencies and pull down drivers and an EFI firmware for QEMU.
3. Download a Windows ISO from [Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2019) or elsewhere (remember to verify your hashes!)
4. Double-check the parameters at the top of `qemu_template_efi.json`. By default it expects that you have at least 4 CPU cores and hyperthreading (`threads_per_core`).
5. Run `build.sh <path/to/windows.iso>`. This process takes about ~15 minutes.
6. Check the output folder for `windows-server-dd.gz` or the filename you defined in the Packer template. This image is ready to deploy with MAAS or another tool, such as `dd`.
7. Please open an issue or let me know when something inevitably breaks.
