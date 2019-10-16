#!/bin/bash
# 2019-10-16: use ffmpeg to downscale Demo Friday videos to 1080p
# Author: Ciaran Moran <25228551+morancj@users.noreply.github.com>

# Command run for test file:
# Downscale to 1080p, approx 3.5× realtime on hackbox2:
# /usr/bin/time ffmpeg -i 015G0486.MOV -vf scale=1920:1080 015G0486_1080p_ffmpeg.MOV
# Transcode x.264 2160p25 to x.264 1080p25, approx 0.6× realtime on hackbox2:
# /usr/bin/time ffmpeg -i 015G0486.MOV -c:v libx265 -crf 28 -c:a aac -b:a 128k 015G0486_2160p_^Cmpeg_x265.MOV

# VARIABLES

# FUNCTIONS

# EXECUTION
