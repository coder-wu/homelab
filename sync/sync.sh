#!/bin/bash -

# shellcheck source=../common/init.sh
source "$(dirname "$0")/../common/init.sh"

readonly sync_config="${HOMELAB_HOME}/sync/config"

from_paths=()
to_paths=()
while read -r from to || [ -n "${from}" ]; do
  from_paths+=("${from}")
  to_paths+=("${to}")
done <"${sync_config}"

for i in "${!from_paths[@]}"; do 
  from="${from_paths[$i]}"
  to="${to_paths[$i]}"
  log_info "sync from ${from} to ${to}"
  rclone sync --interactive --copy-links \
    "${from}" "${to}" 2>&1 | log_function
done
