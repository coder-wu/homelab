#!/bin/bash -

HOMELAB_HOME="$(cd "$(dirname "$0")"/../ && pwd)"

# log is saved under this directory.
HOMELAB_LOG_DIR="/tmp/homelab/log"

# shellcheck source=./log.sh
source "${HOMELAB_HOME}/common/log.sh"
# shellcheck source=./tools.sh
source "${HOMELAB_HOME}/common/tools.sh"


