#!/bin/sh

set -eu

EXE_BASENAME=axolotlsay-js
NODE_VERSION=node18

npm install

args=

# If we're building for cargo-dist, specify which target to build and what the
# filename should be. cargo-dist will expect one output with a known filename.
if [ -n "${CARGO_DIST_TARGET:-}" ]; then
    case "${CARGO_DIST_TARGET}" in
        x86_64-pc-windows-msvc)
            args="--targets ${NODE_VERSION}-win-x86_64 --output ${EXE_BASENAME}.exe"
            ;;
        aarch64-apple-darwin)
            args="--targets ${NODE_VERSION}-darwin-arm64 --output ${EXE_BASENAME}"
            ;;
        x86_64-apple-darwin)
            args="--targets ${NODE_VERSION}-darwin-x86_64 --output ${EXE_BASENAME}"
            ;;
        aarch64-unknown-linux-gnu)
            args="--targets ${NODE_VERSION}-linux-arm64 --output ${EXE_BASENAME}"
            ;;
        x86_64-unknown-linux-gnu)
            args="--targets ${NODE_VERSION}-linux-x86_64 --output ${EXE_BASENAME}"
            ;;
        *)
            echo "Platform not supported: ${CARGO_DIST_TARGET}"
            exit 1
        esac
fi

npm run package -- $args
