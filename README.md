# Cuckoo ISO Builder

This repository contains a script and a GitHub Action to build a bootable live ISO from any container image. The resulting ISO uses a SquashFS filesystem for the root partition, created directly from the container image layers.

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
        uses: zeglius/cuckoo-iso-builder@main # Remember to pin by commit hash
        with:
          container-image: 'quay.io/fedora/fedora:42'
          iso-path: './iso/fedora-42.iso'
```

**Action Inputs:**

- `container-image` (required): The full name of the container image to use as the base for the ISO's root filesystem (e.g., `ubuntu:latest`).
- `iso-path` (required): The directory path where the final ISO file will be moved after being built.

### As a Standalone Script

You can also run the build process locally.

**Prerequisites:**

- `podman` must be installed and running on your system.

**Steps:**

1.  Clone this repository:
    ```bash
    git clone https://github.com/zeglius/cuckoo-iso-builder.git
    cd cuckoo-iso-builder
    ```

2.  Run the `start.sh` script with the `SQUASHFS_CTR_IMG` environment variable set to your desired container image.
    ```bash
    export SQUASHFS_CTR_IMG="quay.io/fedora/fedora:42"
    ./start.sh
    ```

3.  The resulting ISO file will be located in the `out/` directory.

## How it Works

The `start.sh` script uses Podman to perform the build. It starts a Fedora container and mounts the necessary build scripts (`grub.cfg`, `build_iso.sh`). Crucially, it uses Podman's `--mount type=image` feature to mount the target container image's filesystem at `/rootfs` inside the build container.

The `build_iso.sh` script (running inside the container) then creates a SquashFS filesystem from `/rootfs`, prepares a bootable ISO structure with GRUB, and places the final ISO into the `/out` directory, which is a volume mounted from the host.
