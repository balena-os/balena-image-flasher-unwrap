# balena-image-flasher-unwrap

BalenaOS distinguishes between devices that can boot directly a raw image programmed into a SD card or USB disk, and those that boot a flasher image from SD card or USB which then programs the image it encloses into some internal storage like a eMMC.

The second is referred to as a balena-image flasher and contains a balena-image.

This small tool provides the ability to get the embedded balena image in a balena image flasher and configures it accordingly.

## How to use

This tool can be easily ran by either using the prebuilt docker image or running the `balena-image-flasher-unwrap` script directly. We strongly encourage using the prebuilt docker image (i.e `docker-run` method) to make sure that the script dependency requirements are met.

### Run it with docker

Run `docker-run` or adapt it based on your needs. It takes one argument (the
absolute path of the flasher image) and outputs, in the `output` directory, the
balena image.

#### Usage examples

Balena device types can either boot a balena-image directly, or boot a flasher
image that on boot flashes the balena-image it contains.

To unwrap the balena image from a balena image flasher image:

 ./docker-run /path/to/balena.img

This action results in an image in the output directory that can be directly
flashed using Etcher.

To convert it into a different format to use in emulators, specify the image
format as extra arguments:

 ./docker-run /path/to/balena.img -F vmdk

 You can optionally set the image size to a new value in bytes (see qemu-img man page for details):


 ./docker-run /path/to/balena.img -F vmdk -s <bytes>

### Run the script directly

The script needs to be ran as root because it creates loop devices and mounts
them afterwards. For more information about all the arguments supported, run
the main script (`balena-image-flasher-unwrap`) with `--help`.

## Contributions
Want to contribute? Great! Throw pull requests at us.
