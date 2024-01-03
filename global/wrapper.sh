#!/bin/bash -

current_dir=$(dirname "$0")
target_script_name="$1"
. "${current_dir}/config"

global_dir="${HOMELAB_HOME}/global"
. "${global_dir}/log.sh"
. "${global_dir}/tools.sh"


keys=(
    "v2ray" 
    "rsync"
)

values=(
    "${HOMELAB_HOME}/v2ray/v2ray.sh"
    "${HOMELAB_HOME}/rsync/sync.sh"
)

# get value by key
function get_value() {
    local key=$1
    for ((i=0; i<${#keys[@]}; i++)); do
        if [[ "${keys[$i]}" = "${key}" ]]; then
            echo "${values[$i]}"
            return
        fi
    done
}

if [ ! -d "${HOMELAB_HOME}" ]; then
    log_error "Homelab home: ${HOMELAB_HOME} is not a valid directory."
    exit 1
fi

target_script=$(get_value "${target_script_name}")
if [ "${target_script}" = "" ]; then
    log_error "Can't find script for: ${target_script_name}."
    exit 1
fi

if [ ! -f "${target_script}" ]; then
    log_error "Script: ${target_script} is not exist"
    exit 1
fi

log_info "Running script: ${target_script}"

# load target script
. "${target_script}"

# main function is defined in every target script, like a interface.
# the other parameters are directly sent to target script.
main "${@:2}"