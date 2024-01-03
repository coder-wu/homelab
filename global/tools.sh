#!/bin/bash -

function is_mac() {
    if [ "$(uname -s)" == "Darwin" ]; then
        return 0
    fi
    return 1
}

function is_linux() {
    if [ "$(uname -s)" == "Linux" ]; then
       return 0
    fi
    return 1
}