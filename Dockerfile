FROM aooj/base:slim
MAINTAINER AooJ <aooj@n13.cz>

ENV INFLUXDB_VERSION 0.10.2
ENV GOLANG_VERSION 1.4.3
ENV GOLANG_SHA1 486db10dc571a55c8d795365070f66d343458c48

# you can inherit and change it
# ENV KEEP_DEBUG_TOOLS 1

RUN addgroup -g 1301 -S influx \
    && adduser -S -D -H -u 1301 -G influx influx

ADD files/install.sh /tmp/install.sh
RUN /tmp/install.sh


USER influx
VOLUME /var/lib/influxdb

#      webui  http api  proto cluster   raft cluster
EXPOSE 8083   8086      8088            8091

CMD ["/usr/local/bin/influxd", "-config", "/etc/influxdb.conf", "-pidfile", "/run/influx/influx.pid"]
