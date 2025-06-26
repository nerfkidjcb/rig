#!/bin/bash
nohup ngrok http 127.0.0.1:3000 > nohup.out 2>&1 &
sleep 15
./rig/Scripts/updateDNSForNgrok.sh "http://127.0.0.1:4040/api/tunnels"
