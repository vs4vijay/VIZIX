PROJECT 	:= "vizix"
VERSION 	:= 0.0.0

GIT_COMMIT 	:= `git rev-parse HEAD`
GIT_SHA 	:= `git rev-parse --short HEAD`
GIT_TAG 	:= `git describe --tags --abbrev=0 --exact-match 2>/dev/null || echo "canary"`
BUILD_TIME  := `date -u +"%Y-%m-%dT%H:%M:%SZ"`

LDFLAGS := ""
LDFLAGS += -X=github.com/vs4vijay/vizix/pkg/version.SemVer=$(GIT_TAG)
LDFLAGS += -X=github.com/vs4vijay/vizix/pkg/version.GitCommit=$(GIT_COMMIT)
LDFLAGS += -X=github.com/vs4vijay/vizix/pkg/version.BuildTime=$(BUILD_TIME)

OS 			:= `uname | tr '[:upper:]' '[:lower:]'`
OS_LIST		:= darwin linux windows

ARCH 		:= `uname -m`
ARCH_LIST	:= 386 amd64


print-%:
	@echo $* = $($*)


.PHONY: tools
tools:
	go get -u golang.org/x/tools/cmd/goimports
	go get -u golang.org/x/lint/golint


.PHONY: info
info:
	@echo "info..."
	@echo "Version:       		${GIT_TAG}"
	@echo "Git Commit:       	${GIT_COMMIT}"
	@echo "Git SHA:       		${GIT_SHA}"
	@echo "Build Time:       	${BUILD_TIME}"
	@echo ""


.PHONY: format
format:
#	gofmt -l -w .
	goimports -l -w .


.PHONY: lint
format:
	golint .


.PHONY: test
test:
	@echo "TODO"


.PHONY: build
build: info
	GOOS="${OS}" GOARCH="${ARCH}" go build -v -ldflags "$(LDFLAGS)"


.PHONY: build-all
build-all:
	@for os in ${OS_LIST}; do \
		for arch in ${ARCH_LIST}; do \
			echo "Building for OS($${os}) and Arch($${arch})"; \
			GOOS=$${os} GOARCH=$${arch} go build -v -ldflags "$(LDFLAGS)" -o "bin/$(PROJECT)_$${os}_$${arch}"; \
		done \
	done


.PHONY: release-dry-run
release-dry-run:
	goreleaser --snapshot --skip-publish --rm-dist


.PHONY: release-using-gorelease
release-using-gorelease:
	goreleaser --rm-dist


.PHONY: clean
clean:
	@echo "cleaning..."
	rm -rf bin dist
