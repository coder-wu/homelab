#!/bin/bash -
# shellcheck disable=SC2034

# ------------------------------------------------------------------------------
# V2ray software
# ------------------------------------------------------------------------------
# Where v2ray is located. Make sure v2ray_home/xray or v2ray_home/v2ray exists
# and has correct right.
readonly v2ray_home=""
readonly v2ray_exec="${v2ray_home}/v2ray"
readonly conf_dir="${v2ray_home}/confs"

# The proxy url is http(s)://local_listen_ip:local_http_port
# or socks://local_listen_ip:local_socks_port.
# shellcheck disable=SC2034
# Local listens address
readonly local_listen_ip="127.0.0.1"
# Local port
readonly local_http_port="1087"
readonly local_socks_port="1081"

# ------------------------------------------------------------------------------
# Routing
# ------------------------------------------------------------------------------
# Requests are routed according geo data, 
readonly geoip_url="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
readonly geosite_url="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"

readonly geoip_filepath="${v2ray_home}/geoip.dat"
readonly geosite_filepath="${v2ray_home}/geosite.dat"

# These specified IP/domain will be connected in specified mode. Value should be 
# like '1.1.1.1,1.1.1.0' or 'example1.com,example2.com', each item is separated 
# by `,`, with no spaces.
readonly proxy_ip=""
readonly proxy_domain=""

readonly direct_ip=""
readonly direct_domain=""

# ------------------------------------------------------------------------------
# Proxy protocol
# ------------------------------------------------------------------------------
readonly subscribe_url=""

# vmess
# `none`: no security, `tls`: enable TLS
readonly vmess_security_mode="none"

# Address is separated by `,`, with no spaces.
readonly vmess_server_address=""
readonly vmess_server_port=20000
readonly vmess_server_uuid=""
readonly vmess_server_security="aes-128-gcm"

# shadowsocks
# Address is separated by `,`, with no spaces.
readonly shadowsocks_server_address=""
readonly shadowsocks_server_port=20000
readonly shadowsocks_server_password=""
readonly shadowsocks_server_security="aes-256-gcm"