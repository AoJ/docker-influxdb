FROM alpine:3.3
MAINTAINER AooJ <aooj@n13.cz>

ENV INFLUXDB_VERSION=v0.10.1

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
