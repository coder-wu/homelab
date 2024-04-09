#!/bin/bash -

# shellcheck source=../common/init.sh
source "$(dirname "$0")/../common/init.sh"

readonly sync_config="${HOMELAB_HOME}/sync/config"

while read -r from to || [ -n "${from}" ]; do
  log_info "sync from ${from} to ${to}"
  rclone sync --interactive --copy-links \
    "${from}" "${to}" 2>&1 | log_function
done <"${sync_config}"
