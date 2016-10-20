FROM alpine:latest

# Useful tips to fiddle with alpine image builds
# http://blog.zot24.com/tips-tricks-with-alpine-docker/

# Make sure the work dir is created and accessible.
WORKDIR /usr/src/app
VOLUME /usr/src/app

# Set the default commands.
ENTRYPOINT [ "cargo" ]
CMD [ "cargo", "build" ]

# This container works when cargo is available
HEALTHCHECK --interval=5m --timeout=3s \
		CMD which cargo || exit 1

# Install packages needed for build
RUN apk --no-cache add --virtual .build-dependencies \
		curl

ENV TOOLCHAIN nightly

# Install rustup with needed arguments
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain $TOOLCHAIN \
		&& RUN rustup component add rust-src

# clean up build dependencies
RUN apk del .build-dependencies

