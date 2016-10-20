FROM alpine:latest

# Useful tips to fiddle with alpine image builds
# http://blog.zot24.com/tips-tricks-with-alpine-docker/

# Install packages needed for build
RUN apk --no-cache add --virtual .build-dependencies \
		curl

# Download the rustup installer script and make it runnable
RUN curl --output installer.sh https://sh.rustup.rs \
		&& chmod +x ./installer.sh

# This should be either stable, beta, or nightly
ARG CHANNEL

# Install rustup with needed channel and sources
RUN ./installer.sh -y --default-toolchain $CHANNEL \
		&& rustup component add rust-src

# clean up build dependencies
RUN apk del .build-dependencies \
		&& rm -f ./installer.sh

# Make sure the work dir is created and accessible.
WORKDIR /usr/src/app
VOLUME /usr/src/app

# Set the default commands.
ENTRYPOINT [ "cargo" ]
CMD [ "cargo", "build" ]

# This container works when cargo is available
HEALTHCHECK --interval=5m --timeout=3s \
		CMD which cargo || exit 1

