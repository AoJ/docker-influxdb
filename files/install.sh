#/usr/bin/env sh
set -evx
cd /tmp
export INFLUXDB_GIT_URL=https://github.com/influxdata/influxdb.git
export GO_URL=https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz

# install build deps
apk add --update --virtual .build-deps \
        bash                           \
        ca-certificates                \
        gcc                            \
        musl-dev                       \
        openssl                        \
        git

# download go
wget -q "$GO_URL" -O go.tar.gz
echo "$GOLANG_SHA1  go.tar.gz" | sha1sum -c -
tar -C /usr/local -xzf go.tar.gz
cd /usr/local/go/src
./make.bash

# prepare for download and build
export GOPATH=/go
export GOROOT=/usr/local/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# download influxdb and deps
go get github.com/influxdata/influxdb
cd $GOPATH/src/github.com
ln -s influxdata influxdb #bug with old influxdb name
cd influxdata/influxdb
go get -u -f -t ./...
go clean ./...

# build
git checkout -q --detach "v$INFLUXDB_VERSION"
# use date from last commit in branch instead of current date
date=$(git log -n1 --format="%aI" --date=iso8601-strict)
export LDFLAGS="-X main.version $INFLUXDB_VERSION"
export LDFLAGS="$LDFLAGS -X main.branch master"
export LDFLAGS="$LDFLAGS -X main.commit $(git rev-parse --short HEAD)"
export LDFLAGS="$LDFLAGS -X main.buildTime $date"
go install -ldflags="$LDFLAGS" ./...

# copy final bin
if [[ -z "$KEEP_DEBUG_TOOLS" ]]; then
  files="$GOPATH/bin/influx $GOPATH/bin/influxd"
else
  files=$(ls $GOPATH/bin/*)
fi
cp $files /usr/local/bin/
chown influx:influx $files
chmod 550 $files


# use default config
cp etc/config.sample.toml /etc/influxdb.conf
chown influx:influx /etc/influxdb.conf
chmod 440 /etc/influxdb.conf

# prepare data dir
mkdir -p /var/lib/influxdb
chown -R influx:influx /var/lib/influxdb
chmod -R 772 /var/lib/influxdb

# prepare data dir
mkdir -p /run/influx
chown -R influx:influx /run/influx
chmod -R 770 /run/influx

# clean up
apk del .build-deps
rm -rf /var/cache/apk/* /tmp/* /var/tmp/* $GOROOT $GOPATH

