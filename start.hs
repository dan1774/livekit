#!/bin/sh
/livekit-server --config /config.yaml
# keep it alive after running
tail -f /dev/null
