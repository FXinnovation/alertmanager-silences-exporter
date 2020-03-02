GO    	 := GO111MODULE=on go
PROMU := $(GOPATH)/bin/promu
pkgs      = $(shell $(GO) list ./... | grep -v /vendor/)

PREFIX                  ?= $(shell pwd)
BIN_DIR                 ?= $(shell pwd)
DOCKER_REPO             ?= fxinnovation
DOCKER_IMAGE_NAME       ?= alertmanager-silences-exporter
DOCKER_IMAGE_TAG        ?= $(subst /,-,$(shell git rev-parse --abbrev-ref HEAD))

all: vet format build test

test: build
	@echo ">> running tests"
	@$(GO) test -short $(pkgs)

style:
	@echo ">> checking code style"
	@! gofmt -d $(shell find . -path ./vendor -prune -o -name '*.go' -print) | grep '^'

format:
	@echo ">> formatting code"
	@$(GO) fmt $(pkgs)

vet:
	@echo ">> vetting code"
	@$(GO) vet $(pkgs)

build:
	@echo ">> building binaries"
	@$(PROMU) build --prefix $(PREFIX)

tarball: promu
	@echo ">> building release tarball"
	@$(PROMU) tarball --prefix $(PREFIX) $(BIN_DIR)

docker:
	@echo ">> building docker image"
	@docker build -t "$(DOCKER_REPO)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)" .

golint: ## downloads golint
	@go get -u golang.org/x/lint/golint

getpromu:
	@GOOS=$(shell uname -s | tr A-Z a-z) \
		GOARCH=$(subst x86_64,amd64,$(patsubst i%86,386,$(shell uname -m))) \
		$(GO) get github.com/prometheus/promu

.PHONY: all style format build test vet tarball getpromu docker
