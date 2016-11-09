#!/bin/sh -e

CHANNEL=${1}

if [ -z "${CHANNEL}" ]; then
	echo >&2 "You have to specify a rust channel"
	exit 1
fi

# Make sure gorgeous is installed
which gorgeous \
	|| sudo gem install gorgeous

if [ ! -f "packer.yml" ]; then
	echo >&2 "You need a packer yml file to run this."
	exit 1
fi

# Convert the packer yml config to json
gorgeous -F yaml -T json \
	-o packer.json \
	packer.yml


if [ -f "build-env.yml" ]; then
	gorgeous -F yaml -T json \
		-o build-env.json \
		build-env.yml
else
	echo "{}" > build-env.json 
fi

packer build \
	-var "http_proxy=${http_proxy}" \
	-var "https_proxy=${https_proxy}" \
	-var "no_proxy=${no_proxy}" \
	-var "CHANNEL=${CHANNEL}" \
	-var-file=build-env.json \
	packer.json

