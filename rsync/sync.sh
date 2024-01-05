#!/bin/bash -

# shellcheck source=../common/init.sh
source "$(dirname "$0")/../common/init.sh"

readonly rsync_config="${HOMELAB_HOME}/rsync/config"

while read -r from to || [ -n "${from}" ]; do
  log_info "Sync from ${from} to ${to}"
  rsync -avzht --progress --delete --exclude=".cache" --bwlimit=60000 \
    "${from}" "${to}" 2>&1 | log_function
done <"${rsync_config}"
