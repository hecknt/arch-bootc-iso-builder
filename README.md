# ISO Builder for Arch-bootc Systems

This repository contains a script and a GitHub Action to build a bootable live ISO from any Arch Linux image. The resulting ISO uses a SquashFS filesystem for the root partition, created directly from the container image layers.

>[!IMPORTANT]
>
>Note: If the image that you use does not come with a linux kernel pre-installed, you will have to install one yourself by modifying the custom_pre_hooks() function inside of `start.sh`. 
>
>There is an example within the custom_pre_hooks() function if you get lost.

## Usage

You can use this tool either as a GitHub Action in your CI/CD pipeline or as a standalone script on your local machine.

### As a GitHub Action

This repository provides a composite action that you can use in your GitHub Workflows.

**Example Workflow:**

Create a file like `.github/workflows/build-iso.yml` with the following content:

```yaml
name: Build My Custom ISO

on: push

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Check out repository where this action is defined
        uses: actions/checkout@v4

      - name: Build ISO using cuckoo-iso-builder
        uses: hecknt/arch-bootc-iso-builder@main # Remember to pin by commit hash
        with:
          container-image: 'ghcr.io/bootcrew/arch-bootc:latest'
          iso-path: './iso/archlinux.iso'
```

**Action Inputs:**

- `container-image` (required): The full name of the container image to use as the base for the ISO's root filesystem (e.g., `ubuntu:latest`).
- `iso-path` (required): The directory path where the final ISO file will be moved after being built.

### As a Standalone Script

You can also run the build process locally.

**Prerequisites:**

- `podman` must be installed and running on your system.
- `rsync` must be installed on your system.
- `bash` must be installed on your system.

**Steps:**

1.  Clone this repository:
    ```bash
    git clone https://github.com/hecknt/arch-bootc-iso-builder.git
    cd arch-bootc-iso-builder
    ```

2.  Set your image by modifying `config.sh`
    ```bash
    # The OCI image that the ISO will be based upon.
    SQUASHFS_CTR_IMG="ghcr.io/bootcrew/arch-bootc:latest"
    ```

3.  Run the `start.sh` script with the `SQUASHFS_CTR_IMG` environment variable within config.sh set to your desired container image. (must be ran as root)
    ```bash
    ./start.sh
    ```

4.  The resulting ISO file will be located in the `out/` directory.

## How it Works

The `start.sh` script uses Podman to perform the build. It creates a container of the image specified in the `SQUASHFS_CTR_IMG` variable, and then modifies it directly within the `start.sh` script, installing necessary packages and building an initramfs for the ISO to use. Then, it starts a Fedora container and mounts the necessary build scripts (`grub.cfg`, `build_iso.sh`).

The `build_iso.sh` script (running inside the Fedora container) then creates a SquashFS filesystem from `/rootfs`, prepares a bootable ISO structure with GRUB, and places the final ISO into the `/out` directory, which is a volume mounted from the host.
