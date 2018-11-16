#!/bin/sh

if [ "$#" -lt 3 ]; then
	echo "usage: $0 <flac_file> <cue_file> <oggenc_quality>"
fi

FLAC_FILE="$1"
CUE_FILE="$2"
QUALITY="$3"

ENCODER_PARAM="cust ext=ogg oggenc -q$QUALITY -o %f -"
FILENAME_FMT="%n-%t"

shnsplit -f "$CUE_FILE" "$FLAC_FILE" -o "$ENCODER_PARAM" -t "$FILENAME_FMT"
