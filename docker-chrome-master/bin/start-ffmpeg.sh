#!/usr/bin/env bash

ffmpeg -f alsa -i pulse -f mpegts -codec:a mp2 -ar 44100 -ac 2 -b:a 128k udp://localhost:10000
