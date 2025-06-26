#!/bin/bash

sudo /mnt/p/home/Dev/ComfyUI-Installer/launch.sh --listen 10.16.1.34 --port 81
docker start open-webui
ngrok http 127.0.0.1:3000
