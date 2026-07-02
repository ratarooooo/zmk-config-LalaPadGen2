#!/bin/sh

set -eu

BOARD=seeeduino_xiao_ble
ZMK_CONFIG=/workspace/config
BUILD_ROOT=/workspace/.build-local
OUTPUT=/workspace/output

build_firmware() {
    name=$1
    shields=$2
    snippet=${3:-}
    build_dir="$BUILD_ROOT/$name"

    echo "start build $name ($shields)"

    if [ -n "$snippet" ]; then
        west build -p always -s /workspace/zmk/app -d "$build_dir" -b "$BOARD" -- \
            "-DZMK_CONFIG=$ZMK_CONFIG" \
            "-DSHIELD=$shields" \
            "-DSNIPPET=$snippet"
    else
        west build -p always -s /workspace/zmk/app -d "$build_dir" -b "$BOARD" -- \
            "-DZMK_CONFIG=$ZMK_CONFIG" \
            "-DSHIELD=$shields"
    fi

    cp "$build_dir/zephyr/zmk.uf2" "$OUTPUT/$name.uf2"
    echo "end build $name"
}

mkdir -p "$OUTPUT"

build_firmware lalapadgen2_right "lalapadgen2_right rgbled_adapter" studio-rpc-usb-uart
build_firmware lalapadgen2_left "lalapadgen2_left rgbled_adapter"
build_firmware settings_reset settings_reset
