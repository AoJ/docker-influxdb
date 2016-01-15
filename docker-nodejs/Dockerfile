FROM alpine:3.2
MAINTAINER AooJ <aooj@n13.cz>

ENV DEV_PACKAGES="build-base make libuv-dev"
ENV NODE_VERSION=4.1.1

RUN 	apk add --update openssl libssl1.0 libuv zlib libstdc++ libcrypto1.0 libgcc musl $DEV_PACKAGES && \
	cd /tmp && \
	wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.tar.gz && \
	tar -xzf node-v${NODE_VERSION}.tar.gz && \
	cd node-v${NODE_VERSION} 


# ENTRYPOINT [ "/usr/sbin/tinc" ]
# CMD [ "start", "-D", "-U", "nobody" ]
