#!/bin/bash

if [ -z "$1" ]; then
	echo "First argument needs to be the path to the flasher image."
	exit 1
fi
RESIN_IMAGE_FLASHER=$1
if [[ "$RESIN_IMAGE_FLASHER" != /* ]]; then
	echo "Image argument needs to be an absolute path."
	exit 1
fi
if [ ! -f "$RESIN_IMAGE_FLASHER" ]; then
	echo "Image argument not found."
	exit 1
fi

# Get the absolute script location
pushd "$(dirname "$0")" > /dev/null 2>&1
SCRIPTPATH="$(pwd)"
popd > /dev/null 2>&1

docker run --privileged --rm \
	-v /dev:/dev \
	-v "$SCRIPTPATH/output":/output \
	-v "$RESIN_IMAGE_FLASHER":/resin-image-flasher.img \
	agherzan/resin-image-flasher-unwrap:latest \
	resin-image-flasher-unwrap.sh --resin-image-flasher /resin-image-flasher.img --output-directory /output
