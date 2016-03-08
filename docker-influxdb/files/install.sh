#/usr/bin/env sh
set -ev

export DEV_PACKAGES="build-base make git go@edge"

# install dev packages
echo @edge http://dl-3.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
apk add --update $DEV_PACKAGES

# make working dir
export GOPATH=/tmp/infuxdb
mkdir -p $GOPATH/src/github.com/influxdb
cd $GOPATH/src/github.com/influxdb

# download and clone influxdb
git clone --branch ${INFLUXDB_VERSION} https://github.com/influxdb/influxdb.git

exit 0

go get -u -f -t ./...
go build -ldflags="-X main.version=${INFLUXDB_VERSION} -X main.branch=master -X main.commit=`cd influxdb && git rev-parse HEAD`" ./...
go install ./...
cp $GOPATH/bin/* /usr/local/bin/

# prepare dir structure and place-in configs
mkdir -p /etc/influxdb
mkdir -p /data/influxdb
mv /tmp/collectd.types.db /usr/share/collectd/types.db
mv /tmp/config.toml /etc/influxdb/config.toml

# clean up
apk del $DEV_PACKAGES
rm -rf /tmp/

influxd version
