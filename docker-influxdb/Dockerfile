FROM alpine:3.3
MAINTAINER AooJ <aooj@n13.cz>

ENV INFLUXDB_VERSION=v0.10.2
ENV GOLANG_VERSION 1.4.3
ENV GOLANG_SHA1 486db10dc571a55c8d795365070f66d343458c48

ADD files/ /tmp/
RUN /tmp/install.sh

# Admin WebUI
EXPOSE 8083

# HTTP API
EXPOSE 8086

# protobuf clustering
EXPOSE 8099

# Raft clustering
EXPOSE 8090

# udp
EXPOSE 44444

VOLUME ["/data"]

CMD ["/usr/local/bin/influxd"]
