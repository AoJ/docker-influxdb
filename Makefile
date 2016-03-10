NAME ?= aooj/influxdb
VERSION ?= v0.10.2

build:
	docker build --rm -t $(NAME):$(VERSION) .

run:
	docker run -p 8083:8083 -p 8086:8086 -p 8099:8099 -p 8090:8090 -t -i $(NAME):$(VERSION)


debug: build
	docker run -p 8083 -p 8086 -p 8099 -p 8090 -t -i $(NAME):$(VERSION) sh


.PHONY: build run debug
