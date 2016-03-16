# Influxdb in container

- only 35mb size!
- default config
- based on alpine linux
- run under user influx (1301)
- with tini supervizor for proper manager SIG*
- data dir is in `/var/lib/influxdb`
- config in `/etc/influxdb.conf`

## Usage
```
docker run -p 8083:8083 -p 8086:8086 -d aooj/influxdb:latest
```

## Build
```
make VERSION=0.10.3 build