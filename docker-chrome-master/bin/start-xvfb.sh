#!/usr/bin/env bash

export GEOMETRY="${SCREEN_WIDTH}""x""${SCREEN_HEIGHT}""x""${SCREEN_DEPTH}"

Xvfb $DISPLAY -screen 0 ${GEOMETRY} -fbdir /var/tmp -dpi ${SCREEN_DPI} -listen tcp -noreset -ac +extension RANDR