# This file contains a few environment variables that are essential to the function of the script. 
# These environment variables will override any that are manually set by the shell, so please comment them out if you'd prefer to use the shell to set an environment variable.
# Please uncomment any environment variables that you may be using.

# The OCI image that the ISO will be based upon.
#SQUASHFS_CTR_IMG="ghcr.io/bootcrew/arch-bootc:latest"

# Determines whether the OCI image specified in $SQUASHFS_CTR_IMG will be included as an image in the final ISO's podman storage.
# Valid values are "yes" and "no"
INCLUDE_CONTAINER_IN_ISO=yes
