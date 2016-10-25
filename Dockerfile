FROM alpine:latest

# Useful tips to fiddle with alpine image builds
# http://blog.zot24.com/tips-tricks-with-alpine-docker/

# Install packages needed for build
RUN apk --no-cache add --virtual .build-dependencies \
		ca-certificates \
		curl \
		gcc

# This should be either stable, beta, or nightly
ARG RUST_CHANNEL

ARG RUST_DIST_URL=https://static.rust-lang.org/dist
ARG RUST_NAME_SUFFIX=x86_64-unknown-linux-gnu
ARG RUST_NAME_BIN=rust-${RUST_CHANNEL}-${RUST_NAME_SUFFIX}
ARG RUST_NAME_SRC=rustc-${RUST_CHANNEL}-src
ARG RUST_NAME_INT=rust-std-${RUST_NAME_SUFFIX}

WORKDIR ~

# Download, verify, unpack, remove, position, and install the channel.
RUN pwd \
	&& curl -fO ${RUST_DIST_URL}/${RUST_NAME_BIN}.tar.gz \
	&& curl -fO ${RUST_DIST_URL}/${RUST_NAME_SRC}.tar.gz \
	&& curl -fs ${RUST_DIST_URL}/${RUST_NAME_BIN}.tar.gz.sha256 | sha256sum -c - \
	&& curl -fs ${RUST_DIST_URL}/${RUST_NAME_SRC}.tar.gz.sha256 | sha256sum -c - \
	&& tar -xzf ${RUST_NAME_BIN}.tar.gz \
	&& tar -xzf ${RUST_NAME_SRC}.tar.gz \
	&& rm -f ${RUST_NAME_BIN}.tar.gz \
	&& rm -f ${RUST_NAME_SRC}.tar.gz \
	&& mv ${RUST_NAME_BIN}/ /rust \
	&& mv rustc-${RUST_CHANNEL}/ /rust/${RUST_NAME_INT}/lib/rustlib/${RUST_NAME_SUFFIX}/src \
	&& /rust/install.sh

# clean up build dependencies
RUN apk del .build-dependencies

# Make sure the work dir is created and accessible.
WORKDIR /usr/work
VOLUME /usr/work

# Set the default commands.
CMD [ "cargo", "build" ]
ENTRYPOINT [ "cargo" ]

# This container works when cargo is available
HEALTHCHECK --interval=5m --timeout=3s \
		CMD which cargo || exit 1

