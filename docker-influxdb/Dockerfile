FROM alpine:3.2
MAINTAINER AooJ <aooj@n13.cz>

ENV DEV_PACKAGES="build-base make git go"
ENV INFLUXDB_VERSION=0.9.4.1

RUN     echo @edge http://dl-3.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories                        && \
        apk add --update $DEV_PACKAGES go@edge                                                                  && \
        export GOPATH=/tmp/infuxdb                                                                              && \
        mkdir -p $GOPATH/src/github.com/influxdb                                                                && \
        cd $GOPATH/src/github.com/influxdb                                                                      && \
        git clone --branch v${INFLUXDB_VERSION} https://github.com/influxdb/influxdb.git                        && \
        go get -u -f -t ./...                                                                                   && \
        go build -ldflags="-X main.version=v${INFLUXDB_VERSION} -X main.branch=master -X main.commit=`cd influxdb && git rev-parse HEAD`" ./... && \
        go install ./...                                                                                        && \
        cp $GOPATH/bin/* /usr/local/bin/                                                                        && \
        apk del $DEV_PACKAGES                                                                                   && \
        rm -rf /tmp/                                                                                            && \
        influxd version


RUN mkdir -p /etc/influxdb
ADD types.db /usr/share/collectd/types.db
ADD config.toml /etc/influxdb/config.toml

# Admin WebUI
EXPOSE 8083

# HTTP API
EXPOSE 8086

# protobuf clustering
EXPOSE 8099

# Raft clustering
EXPOSE 8090

VOLUME ["/data"]

CMD ["/opt/run.sh"]
