#!/bin/sh
set -e

# Start the LiveKit server in foreground so Railway can see logs
/livekit-server --config /config.yaml

