#!/usr/bin/env bash

/opt/bin/server -audio-port ${FFMPEG_UDP_PORT:-10000} -port ${AUDIO_SERVER:-1699}
