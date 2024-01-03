#!/bin/bash -

log_dir="${HOMELAB_LOG_DIR}"

# generate log file for every day, name like yymmdd.log
log_file="${log_dir}/$(date +"%y%m%d").log"

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

function log_function() {
    eval "$*" 2>&1 | while read -r line; do
        log "${line}"
    done
}
