#!/usr/bin/env bash

envsubst '\$PORT,\$WEBSOCKIFY_PORT,\$AUDIO_SERVER' < /etc/nginx/conf.d/nginx.conf.template > /etc/nginx/conf.d/nginx.conf

sudo nginx -g 'daemon off; master_process on;'
