# resin-image-flasher-unwrap

This small tool provides the ability to get the embedded resin image in a resin image flasher and configures it accordingly.

## How to use

This tool can be easily ran by either using the prebuilt docker image or running the `resin-image-flasher-unwrap` script directly. We strongly encourage using the prebuilt docker image (i.e `docker-run` method) to make sure that the script dependency requirements are met.

### Run it with docker

Run `docker-run` or adapt it based on your needs. It takes one argument (the
absolute path of the flasher image) and outputs, in the `output` directory, the
resin image.

### Run the script directly

The script needs to be ran as root because it creates loop devices and mounts
them afterwards. For more information about all the arguments supported, run
the main script (`resin-image-flasher-unwrap`) with `--help`.

## Contributions
Want to contribute? Great! Throw pull requests at us.
