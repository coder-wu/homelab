#!/bin/bash

# shellcheck source=../common/init.sh
source "$(dirname "$0")/../common/init.sh"
# shellcheck source=./config.sh
source "${HOMELAB_HOME}/ray/config.sh"

readonly ray_log_dir="${HOMELAB_LOG_DIR}/ray"

# Check log directory and ray executable file
function check_env() {
  if [ ! -d "${ray_log_dir}" ]; then
    log_info "create ray log directory: ${ray_log_dir}"
    mkdir -p "${ray_log_dir}" 2>&1 | log_function || {
      log_error "create ray log directory: ${ray_log_dir} failed."
      exit 1
    }
  fi

  if ! type "${ray_exec}" >/dev/null 2>&1; then
    log_error "ray executable file: ${ray_exec} does not exist" \
      "or has no right to execute."
    exit 1
  fi
}

# Generate configuration files under ${ray_home}/conf.
function update_config() {
  local proxy_protocol="$1"

  if [ "${proxy_protocol}" == "ss" ]; then
    proxy_protocol="SHADOWSOCKS-PROXY"
    log_info "use shadowsocks protocol"
  else
    proxy_protocol="VMESS-PROXY"
    log_info "use vmess protocol"
  fi

  if [ -d "${conf_dir}" ]; then
    rm -rf "${conf_dir}" 2>&1 | log_function || {
      log_error "delete ray conf directory: ${conf_dir} failed."
      exit 1
    }
  fi

  mkdir -p "${conf_dir}" 2>&1 | log_function || {
    log_error "create ray conf directory: ${conf_dir} failed."
    exit 1
  }

  readonly ray_conf_template_dir="${HOMELAB_HOME}/ray/conf_template"
  for template_file in "${ray_conf_template_dir}"/*.json; do
    local template_content
    template_content=$(<"${template_file}")
    # Replace placeholders with variable values
    # 00_log.json
    template_content="${template_content//#ray_log_dir#/${ray_log_dir}}"

    # 03_routing.json
    local format_result
    format_result="$(to_json_string_array "${proxy_ip}")"
    template_content="${template_content//#proxy_ip#/${format_result}}"
    format_result="$(to_json_string_array "${proxy_domain}")"
    template_content="${template_content//#proxy_domain#/${format_result}}"
    format_result="$(to_json_string_array "${direct_ip}")"
    template_content="${template_content//#direct_ip#/${format_result}}"
    format_result="$(to_json_string_array "${direct_domain}")"
    template_content="${template_content//#direct_domain#/${format_result}}"

    template_content="${template_content//#proxy_protocol#/${proxy_protocol}}"

    # 05_inbounds.json
    template_content="${template_content//#local_listen_ip#/${local_listen_ip}}"
    template_content="${template_content//#local_http_port#/${local_http_port}}"
    template_content="${template_content//#local_socks_port#/${local_socks_port}}"

    # 06_outbounds.json
    # generate vmess configuraions
    local vmess_configs=""
    IFS=','
    for server_address in ${vmess_server_address}; do
      local vmess_config=$"
        {
          \"address\": \"${server_address}\",
          \"port\": ${vmess_server_port},
          \"users\": [
              {
                \"id\": \"${vmess_server_uuid}\",
                \"security\": \"${vmess_server_security}\"
              }
          ]
        },"
      vmess_configs="${vmess_configs}${vmess_config}"
    done
    vmess_configs="${vmess_configs%,}"
    template_content="${template_content//#vmess_configs#/${vmess_configs}}"
    template_content="${template_content//#vmess_security_mode#/${vmess_security_mode}}"

    # generate shadowsocks configuraions
    local ss_configs=""
    for server_address in ${shadowsocks_server_address}; do
      local ss_config=$"
        {
          \"address\": \"${server_address}\",
          \"port\": ${shadowsocks_server_port},
          \"method\": \"${shadowsocks_server_security}\",
          \"password\": \"${shadowsocks_server_password}\",
          \"uot\": true,
          \"UoTVersion\": 2
        },"
      ss_configs="${ss_configs}${ss_config}"
    done
    ss_configs="${ss_configs%,}"
    template_content="${template_content//#ss_configs#/${ss_configs}}"

    # Reset IFS to its default value
    IFS=' '

    local conf_filename
    conf_filename=$(basename "${template_file}")
    echo "${template_content}" >"${conf_dir}/${conf_filename}"
  done
}

function start_ray() {
  "${ray_exec}" -confdir "${conf_dir}" 2>&1 | log_function &
}

function stop_ray() {
  local ray_service_name
  ray_service_name=$(basename "${ray_exec}")
  for thread_num in $(pgrep "${ray_service_name}"); do
    log_info "stop ray process ${thread_num}."
    kill -9 "${thread_num}" | log_function
  done
}

function update_rules_data() {
  local http_code
  http_code=$(curl -Ls "${geoip_url}" -o "${geoip_filepath}" -w "%{http_code}")
  if [ "${http_code}" != "200" ]; then
    log_error "download geoip data failed."
  fi

  http_code=$(curl -Ls "${geosite_url}" -o "${geosite_filepath}" -w "%{http_code}")
  if [ "${http_code}" != "200" ]; then
    log_error "download geosite data failed"
  fi
}

function detect_network() {
  local in_wall_response
  in_wall_response=$(curl -s -m 3 --noproxy '*' "https://www.baidu.com" \
    -o /dev/null -w "%{http_code}")
  if [ "${in_wall_response}" != "200" ]; then
    log_error ":( NETOWRK DOWN ):"
    exit 0
  fi

  local over_wall_response
  over_wall_response=$(curl -s -m 5 \
    --proxy "http://${local_listen_ip}:${local_http_port}" \
    "https://www.google.com" -o /dev/null -w "%{http_code}")
  if [ "${over_wall_response}" == "200" ]; then
    log_info ">>> Hello World! <<<"
  else
    log_info "#_#_# STAY IN WALL #_#_#"
  fi
}

function query_subscribe_info() {
  local subscribe_content
  subscribe_content="$(curl -s -m 5 \
    --proxy "http://${local_listen_ip}:${local_http_port}" \
    "${subscribe_url}")"

  if [ "${subscribe_content}" == "" ]; then
    log_error "subscribe content is empty."
    exit 1
  fi

  for url in $(echo "${subscribe_content}" | base64 -d); do
    local connect_info_text="${url#*//}"
    connect_info_text="${connect_info_text%%#*}"
    connect_info_text=$(echo "$connect_info_text" | base64 -d 2>/dev/null)
    echo "${connect_info_text}"
  done
}

# Convert IP/domain in config.sh to json array format
function to_json_string_array() {
  local input="$1"
  local format_result=""
  if [ -n "${input}" ]; then
    format_result="\"${input}\""
    format_result="${format_result//,/","}"
    format_result="${format_result},"
  fi

  echo "${format_result}"
}

main() {
  local option="$1"
  local protocol="$2"

  check_env

  case "${option}" in
  load)
    stop_ray
    update_config "${protocol}"
    start_ray
    ;;

  stop)
    stop_ray
    ;;

  urd)
    update_rules_data
    ;;

  detect)
    detect_network
    ;;

  info)
    query_subscribe_info
    ;;

  *)
    log_error "Unknown option: ${option}."
    ;;
  esac
}

main "$@"
