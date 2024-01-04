#!/bin/bash -

HOMELAB_HOME="$(cd "$(dirname "$0")"/../ && pwd)"
export HOMELAB_HOME

# shellcheck source=./config.sh
source "${HOMELAB_HOME}/common/config.sh"
# shellcheck source=./log.sh
source "${HOMELAB_HOME}/common/log.sh"
# shellcheck source=./tools.sh
source "${HOMELAB_HOME}/common/tools.sh"


