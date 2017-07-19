#!/bin/bash

set -e

MOUNTPOINTS=/tmp/resin-image-flasher-unwrap/mountpoints
RESIN_IMAGE_BOOT_MNT=${MOUNTPOINTS}/resin-boot
RESIN_IMAGE_ROOT_MNT=${MOUNTPOINTS}/resin-root
RESIN_IMAGE_FLASHER_BOOT_MNT=${MOUNTPOINTS}/flash-boot
RESIN_IMAGE_FLASHER_ROOT_MNT=${MOUNTPOINTS}/flash-root

help() {
	cat << EOF
$0 <OPTION>

	Options:
		-f, --resin-image-flasher
			The file to be used as a flasher image.
			This argument is mandatory.
		-o, --output-directory
			By default the unwrapped image will be outputted in the directory
			where this tool resides. Custom location can be specified using
			this flag.
EOF
}

function log {
	case $1 in
		ERROR)
			loglevel=ERROR
			shift
			;;
		WARN)
			loglevel=WARNING
			shift
			;;
		*)
		loglevel=LOG
			;;
	esac
	printf "%s%s\n" "[$loglevel]" "$1"
	if [ "$loglevel" == "ERROR" ]; then
		exit 1
	fi
}

# Parse auguments
while [[ $# -gt 0 ]]; do
	arg="$1"
	case $arg in
		-h|--help)
			help
			exit 0
			;;
		-f|--resin-image-flasher)
			if [ -z "$2" ]; then
				log ERROR "\"$1\" argument needs a value."
			fi
			RESIN_IMAGE_FLASHER=$2
			shift
			;;
		-o|--output-directory)
			if [ -z "$2" ]; then
				log ERROR "\"$1\" argument needs a value."
			fi
			OUTPUT_DIR=$2
			shift
			;;
		*)
			echo "Unrecognized option $1."
			help
			exit 1
			;;
	esac
	shift
done

cleanup () {
	EXIT_CODE=$?
	umount "$RESIN_IMAGE_BOOT_MNT" > /dev/null 2>&1 || true
	umount "$RESIN_IMAGE_ROOT_MNT" > /dev/null 2>&1 || true
	umount "$RESIN_IMAGE_FLASHER_BOOT_MNT" > /dev/null 2>&1 || true
	umount "$RESIN_IMAGE_FLASHER_ROOT_MNT" > /dev/null 2>&1 || true
	losetup -d "$RESIN_IMAGE_LOOP_DEV" "$RESIN_IMAGE_FLASHER_LOOP_DEV" > /dev/null 2>&1 || true
	exit $EXIT_CODE
}
trap cleanup EXIT SIGHUP SIGINT SIGTERM

# Get the absolute script location
pushd "$(dirname "$0")" > /dev/null 2>&1
SCRIPTPATH="$(pwd)"
popd > /dev/null 2>&1

# By default output the image in the same directory as this tool
[ -z "$OUTPUT_DIR" ] && OUTPUT_DIR=$SCRIPTPATH
[ ! -d "$OUTPUT_DIR" ] && log ERROR "Output directory not found."

# Setup mountpoints
rm -rvf $MOUNTPOINTS
mkdir -p \
	$RESIN_IMAGE_BOOT_MNT \
	$RESIN_IMAGE_ROOT_MNT \
	$RESIN_IMAGE_FLASHER_BOOT_MNT \
	$RESIN_IMAGE_FLASHER_ROOT_MNT

[ -z "$RESIN_IMAGE_FLASHER" ] && log ERROR "No resin image flasher available."
log "Unwraping resin image from the provided resin image flasher..."
RESIN_IMAGE_FLASHER_LOOP_DEV="$(losetup -fP --show "$RESIN_IMAGE_FLASHER")"
mount "${RESIN_IMAGE_FLASHER_LOOP_DEV}p1" "$RESIN_IMAGE_FLASHER_BOOT_MNT" > /dev/null 2>&1
mount "${RESIN_IMAGE_FLASHER_LOOP_DEV}p2" "$RESIN_IMAGE_FLASHER_ROOT_MNT" > /dev/null 2>&1
RESIN_IMAGE="$(find "$RESIN_IMAGE_FLASHER_ROOT_MNT/opt" -type f | head -n1)"
[ -z "$RESIN_IMAGE" ] && log ERROR "The resin image flasher doesn't contain a resin image."
cp "$RESIN_IMAGE" "$OUTPUT_DIR/resin-image.img"
RESIN_IMAGE="$OUTPUT_DIR/resin-image.img"

log "Migrating configurationg from resin image flasher to resin-image..."
RESIN_IMAGE_LOOP_DEV="$(losetup -fP --show "$RESIN_IMAGE")"
mount "${RESIN_IMAGE_LOOP_DEV}p1" "$RESIN_IMAGE_BOOT_MNT"
mount "${RESIN_IMAGE_LOOP_DEV}p2" "$RESIN_IMAGE_ROOT_MNT"
cp -r $RESIN_IMAGE_FLASHER_BOOT_MNT/splash/* "$RESIN_IMAGE_BOOT_MNT/splash"
cp "$RESIN_IMAGE_FLASHER_BOOT_MNT/config.json" "$RESIN_IMAGE_BOOT_MNT/config.json"
if [ -d  "$RESIN_IMAGE_FLASHER_BOOT_MNT/system-connections" ]; then
	rm -rf "$RESIN_IMAGE_BOOT_MNT/system-connections"
	cp -r "$RESIN_IMAGE_FLASHER_BOOT_MNT/system-connections" "$RESIN_IMAGE_BOOT_MNT/system-connections"
fi
if [ -d  "$RESIN_IMAGE_FLASHER_BOOT_MNT/system-proxy" ]; then
	rm -rf "$RESIN_IMAGE_BOOT_MNT/system-proxy"
	cp -r "$RESIN_IMAGE_FLASHER_BOOT_MNT/system-proxy" "$RESIN_IMAGE_BOOT_MNT/system-proxy"
fi

log "Done."
