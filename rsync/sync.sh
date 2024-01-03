#!/bin/bash -

rsync_config="${HOMELAB_HOME}/rsync/config"

main() {
	while read -r from to || [ -n "${from}" ]; do
		log_info "Sync from ${from} to ${to}"
		log_function rsync -avzht --progress --delete --exclude=".cache" --bwlimit=60000 \
		  "${from}" "${to}"
	done < "${rsync_config}"
}

