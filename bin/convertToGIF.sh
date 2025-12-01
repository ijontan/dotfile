#!/bin/bash

START_TIME=${3:-0}
DURATION=${4:-5}
FPS=30
SCALE=720
INFILE=$1
OUTFILE=${2:-output.gif}

echo $INFILE
ffmpeg -ss ${START_TIME} -t ${DURATION} -i "${INFILE}" \
    -vf "fps=${FPS},scale=-1:${SCALE}:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
    -loop 0 "${OUTFILE}"

