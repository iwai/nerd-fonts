MAKEFLAGS    += --warn-undefined-variables
SHELL        := /bin/bash
.SHELLFLAGS  := -eu -o pipefail -c
INSTALL_DATA  = /usr/bin/install -m644

TAG        = 1.0
TARGETDIRS = ${wildcard target/*}


.PHONY: all
all: clean source build

define MAKER
	make -C $(1) $(2)

endef

.PHONY: clean
clean:
	$(foreach TARGET, $(TARGETDIRS), $(call MAKER,$(TARGET),$@))
	-docker rmi iwai/nerd-fontpatcher

.PHONY: source
source:
	$(foreach TARGET, $(TARGETDIRS), $(call MAKER,$(TARGET),$@))

.PHONY: build
build:
	$(foreach TARGET, $(TARGETDIRS), $(call MAKER,$(TARGET),$@))

.PHONY: install
install:
	$(foreach TARGET, $(TARGETDIRS), $(call MAKER,$(TARGET),$@))

.PHONY: release
release:
	$(foreach TARGET, $(TARGETDIRS), $(call MAKER,$(TARGET),$@))
