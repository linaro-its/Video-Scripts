#!/bin/bash
# 2019-10-16: use ffmpeg to downscale Demo Friday videos to 1080p
# Author: Ciaran Moran <25228551+morancj@users.noreply.github.com>

# Command run for test file:
# Downscale to 1080p, approx 3.5× realtime on hackbox2:
# /usr/bin/time ffmpeg -i 015G0486.MOV -vf scale=1920:1080 015G0486_1080p_ffmpeg.MOV
# Transcode x.264 2160p25 to x.264 1080p25, approx 0.6× realtime on hackbox2:
# /usr/bin/time ffmpeg -i 015G0486.MOV -c:v libx265 -crf 28 -c:a aac -b:a 128k 015G0486_2160p_^Cmpeg_x265.MOV

# VARIABLES
SHORT_OPTIONS=+hi:
LONG_OPTIONS=help,input-file:
NICE_PATH="/usr/bin/nice"
TIME_PATH="/usr/bin/time"
FFMPEG_PATH="/usr/bin/ffmpeg"
# Run at lowest priority
NICE_VALUE="19"
# 1080p downscaling
FFMPEG_SCALE="scale=1920:1080"
# Supported file extensions
INPUT_FILE_EXTENSION="(mpg|mpeg|mp4|mov)"
INPUT_FILE_EXTENSION_PATTERN=".*\.$INPUT_FILE_EXTENSION"

# FUNCTIONS
# HELP
usage() {
cat << EOF 1>&2
Usage: $0 [option]... -i filename.$INPUT_FILE_EXTENSION
Downscale filename.$INPUT_FILE_EXTENSION to 1080p, make no other changes

OPTIONS:
  [ -h | --help ]                   : Print this help text

Usage: $0   -i | --input-file filename.$INPUT_FILE_EXTENSION
EOF
  exit 1
}

# Read and parse options
parse_options() {
  getopt --options "$SHORT_OPTIONS" --longoptions "$LONG_OPTIONS" -- "$@" >/dev/null || exit 11
  OPTIONS=$(getopt --options "$SHORT_OPTIONS" --longoptions "$LONG_OPTIONS" -- "$@")
  eval " set --$OPTIONS"

echo "$OPTIONS"

  while [[ $# -gt 0 ]] ; do
    case "$1" in
      -h|--help)
        usage
        exit 0
        ;;
      -i|--input-file)
        INPUT_FILE="$2"
        shift 2
        ;;
      --)
        shift
        break
        ;;
      *) echo "Unable to parse options" ; break ; exit 12 ;;
    esac
  done

  # Ignore case in file extension pattern
  shopt -s nocasematch
  if ! [[ "$INPUT_FILE" =~ $INPUT_FILE_EXTENSION_PATTERN ]] ; then
    echo "Invalid video file name specified!"
    usage
  fi
}

# Split filename into parts before and after the prefix
parse_input_filename() {
  INPUT_FILE_FIRST_ELEMENT=$(echo "$INPUT_FILE" | nawk -F\. 'BEGIN{FS=OFS="."}{NF--; print}')
  INPUT_FILE_EXTENSION=$(echo "$INPUT_FILE" | nawk -F\. '{print $NF}')
}

downscale_to_1080p() {
  echo "$TIME_PATH" "$NICE_PATH" -n "$NICE_VALUE" \
  "$FFMPEG_PATH" -i "$INPUT_FILE" -vf "$FFMPEG_SCALE" -map_metadata 0 "$INPUT_FILE_FIRST_ELEMENT"_1080p."$INPUT_FILE_EXTENSION"
  "$TIME_PATH" "$NICE_PATH" -n "$NICE_VALUE" \
  "$FFMPEG_PATH" -i "$INPUT_FILE" -vf "$FFMPEG_SCALE" -map_metadata 0 "$INPUT_FILE_FIRST_ELEMENT"_1080p."$INPUT_FILE_EXTENSION"
}

# EXECUTION
## If called with no options, print help
if [[ $# -eq 0 ]] ; then
  usage
fi
parse_options "$@"
parse_input_filename
downscale_to_1080p
