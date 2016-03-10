NAME ?= aooj/influxdb
VERSION ?= 0.10.2

build:
	sed -i -e "s/^ENV INFLUXDB_VERSION .*/ENV INFLUXDB_VERSION $(VERSION)/g" Dockerfile
	docker build --rm -t $(NAME):$(VERSION) .

run:
	docker run -p 8083:8083 -p 8086:8086 -p 8099:8099 -p 8090:8090 -t -i $(NAME):$(VERSION)


debug: build
	docker run -p 8083 -p 8086 -p 8099 -p 8090 -t -i $(NAME):$(VERSION) sh

deploy: clean build
	git checkout -b tmp
	-git commit -m "influxdb $(VERSION)" -a 2>/dev/null
	git tag $(VERSION)
	git checkout master
	git branch -D tmp
	git push origin $(VERSION)

clean:
	[[ -z $$(git status -s) ]] || (echo there is uncommited changes && exit 1)
	-git checkout master 2>/dev/null
	-git branch -D tmp 2>/dev/null
	-git tag -d $(VERSION) 2>/dev/null

.PHONY: build run debug deploy clean
