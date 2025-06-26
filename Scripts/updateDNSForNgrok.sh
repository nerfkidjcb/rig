#!/bin/bash

# Ensure that all required arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <NGROK_API_URL>"
    exit 1
fi

# Assign command line parameter to variable
NGROK_API_URL="$1"       # ngrok API URL (e.g., http://127.0.0.1:4040/api/tunnels)

# Fetch the current ngrok URL (using the provided ngrok API URL)
NGROK_URL=$(curl -s $NGROK_API_URL)

# Check if we got the ngrok URL
if [[ -z "$NGROK_URL" ]]; then
    echo "Could not fetch ngrok URL. Ensure ngrok is running and API URL is correct."
    exit 1
fi

# Extract the ngrok public URL domain (e.g., app.ngrok.io) using grep and sed
NGROK_HOSTNAME=$(echo $NGROK_URL | grep -oP '"public_url":"\K[^"]+' | sed 's/^https\?:\/\///')

# Check if the extraction was successful
if [[ -z "$NGROK_HOSTNAME" ]]; then
    echo "Error extracting ngrok URL."
    exit 1
fi

echo "Current ngrok URL: https://$NGROK_HOSTNAME"

# Construct the redirect URL for the GET request
REDIRECT_URL="https://ai.joebroughton.tech/submit.php?redirect=$NGROK_HOSTNAME" # The https is done on my server

# Send the GET request with the ngrok URL as the redirect parameter
curl -s "$REDIRECT_URL"

# Inform the user that the request was sent
echo "GET request sent to: $REDIRECT_URL"

