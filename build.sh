#!/bin/sh -e

CHANNEL=${1}

docker build \
	--build-arg http_proxy \
	--build-arg https_proxy \
	--build-arg no_proxy \
	--build-arg RUST_CHANNEL=${CHANNEL} \
	--tag aetheric/rust:${CHANNEL} \
	.
