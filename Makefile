NAME ?= aooj/influxdb
VERSION ?= 0.10.3

build:
	docker build --build-arg VERSION=${VERSION} --rm -t ${NAME}:${VERSION} .

debug: build
	docker run -p 8083 -p 8086 -p 8099 -p 8090 -t -i ${NAME}:${VERSION} sh

deploy: clean build
	git checkout -b tmp
	sed -i -re "s/^(ARG VERSION=)[a-z.0-9]+/\1${VERSION}/" Dockerfile
	-git commit -m "influxdb ${VERSION}" -a 2>/dev/null
	git tag ${VERSION}
	git checkout master
	git branch -D tmp
	git push origin ${VERSION}

clean:
	[[ -z $$(git status -s) ]] || (echo there is uncommited changes && exit 1)
	-git checkout master 2>/dev/null
	-git branch -D tmp 2>/dev/null
	-git tag -d $(VERSION) 2>/dev/null

.PHONY: build debug deploy clean
