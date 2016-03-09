#/usr/bin/env sh
set -evx
cd /tmp
export INFLUXDB_GIT_URL=https://github.com/influxdata/influxdb.git
export GOLANG_URL=https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz

# install build deps
apk add --update --virtual .build-deps \
        bash                           \
        ca-certificates                \
        gcc                            \
        musl-dev                       \
        openssl                        \
        git

# download go
wget -q "$GOLANG_URL" -O golang.tar.gz
echo "$GOLANG_SHA1  golang.tar.gz" | sha1sum -c -
tar -C /usr/local -xzf golang.tar.gz
cd /usr/local/go/src && ./make.bash

# download influxdb
export GOPATH=/tmp
export GOROOT=/usr/local/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

mkdir -p $GOPATH/src/github.com/influxdata
cd $GOPATH/src/github.com/influxdata
git clone --depth=1 -q --branch $INFLUXDB_VERSION $INFLUXDB_GIT_URL
cd $GOPATH/src/github.com/influxdata/influxdb

# build
go get -u -f -t ./...
go clean ./...
date=$(git log -n1 --format="%aI" --date=iso8601-strict)
LDFLAGS="-X main.version $INFLUXDB_VERSION"                      \
LDFLAGS="$LDFLAGS -X main.branch master"                         \
LDFLAGS="$LDFLAGS -X main.commit $(git rev-parse --short HEAD)"  \
LDFLAGS="$LDFLAGS -X main.buildTime $date"                       \
        go install -ldflags="$LDFLAGS" ./...
cp $GOPATH/bin/influx* /usr/bin/

# clean up
apk del .build-deps
rm -rf /var/cache/apk/* /tmp/* /var/tmp/* $GOROOT $GOPATH

# download and clone influxdb
# git clone --branch ${INFLUXDB_VERSION} https://github.com/influxdb/influxdb.git

