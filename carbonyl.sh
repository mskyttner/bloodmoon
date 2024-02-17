#!/bin/bash

URL_DEFAULT="https://brutalist.report"
URL="${1:-$URL_DEFAULT}"

echo "$URL"

#printf -v ENTRYPOINT '["/app/bin/browsh", "--startup-url", "%s"]' "$URL"
COLORTERM=24bit

podman run -ti --rm --env COLORTERM=24bit docker.io/fathyb/carbonyl $URL
