# Copyright (c) Huawei Technologies Co., Ltd. 2019. All rights reserved.
# lxcfs-tools is licensed under the Mulan PSL v2.
# You can use this software according to the terms and conditions of the Mulan PSL v2.
# You may obtain a copy of Mulan PSL v2 at:
#     http://license.coscl.org.cn/MulanPSL
# THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR
# PURPOSE.
# See the Mulan PSL v2 for more details.
# Description: makefile
# Author: zhangsong
# Create: 2019-01-18

COMMIT=$(shell git rev-parse HEAD 2> /dev/null || true)
SOURCES := $(shell find . 2>&1 | grep -E '.*\.(c|h|go)$$')
DEPS_LINK := $(CURDIR)/vendor/
VERSION := $(shell cat ./VERSION)
TAGS="cgo static_build"

BEP_DIR=/tmp/lxcfs-tools-build-bep
BEP_FLAGS=-tmpdir=/tmp/lxcfs-tools-build-bep

GO_LDFLAGS="-w -buildid=IdByiSula -extldflags -static $(BEP_FLAGS) -X main.gitCommit=${COMMIT} -X main.version=${VERSION}"
DEF_GOPATH=${GOPATH}
ifneq ($(GOPATH), )
CUS_GOPATH=${GOPATH}:${PWD}
ENV = GOPATH=${CUS_GOPATH} CGO_ENABLED=1
else
ENV = CGO_ENABLED=1
endif

all: dep toolkit lxcfs-hook
dep:
	mkdir -p $(BEP_DIR)

toolkit:  $(SOURCES) | $(DEPS_LINK)
	@echo "Making lxcfs-tools..."
	${ENV} go build -mod=vendor -tags ${TAGS} -ldflags ${GO_LDFLAGS} -o build/lxcfs-tools .
	@echo "Done!"

lxcfs-hook: $(SOURCES) | $(DEPS_LINK)
	@echo "Making lxcfs-hook..."
	${ENV} go build -mod=vendor -tags ${TAGS} -ldflags ${GO_LDFLAGS} -o build/lxcfs-hook ./hooks/lxcfs-hook
	@echo "Done!"

clean:
	rm -rf build

install:
	cd hakc && ./install.shloacal:
