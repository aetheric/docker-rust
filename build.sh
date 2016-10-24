#!/bin/sh -e

CHANNEL=${1}

docker build \
	--build-arg http_proxy \
	--build-arg https_proxy \
	--build-arg no_proxy \
	--build-arg channel=${CHANNEL} \
	--tag aetheric/rust:${CHANNEL} \
	.
