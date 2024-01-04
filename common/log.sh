#!/bin/bash -

readonly log_dir="${HOMELAB_LOG_DIR}"

# generate log file for every day, name like script_name.yymmdd.log
log_file="${log_dir}/$(basename "$0").$(date +"%y%m%d").log"
readonly log_file

if [ ! -d "${log_dir}" ]; then
    mkdir -p "${log_dir}" ||
        echo "Can't create log directory: ${log_dir}, please check the permission." ||
        exit 1
fi

function log() {
    printf "$(date +"%D %T") %s \n" "$*" | tee -a "${log_file}"
}

function log_info() {
    log "[INFO] " "$*"
}

function log_error() {
    log "[ERROR] " "$*"
}

# runnig a command or function, record log.
function log_function() {
    while read -r line; do
        log "${line}"
    done
}
