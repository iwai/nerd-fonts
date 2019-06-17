MAKEFLAGS    += --warn-undefined-variables
SHELL        := /bin/bash
.SHELLFLAGS  := -eu -o pipefail -c
INSTALL_DATA  = /usr/bin/install -m644

TAG        = 1.0
VERSION    = 4.1.1
SRCDIR     = source
PATCHEDDIR = patched

RD_SOURCE_FILES  = ${wildcard $(SRCDIR)/RictyDiminished-*.ttf}
RDD_SOURCE_FILES = ${wildcard $(SRCDIR)/RictyDiminishedDiscord-*.ttf}

RD_CMP_FILES       = $(RD_SOURCE_FILES:$(SRCDIR)/RictyDiminished-%.ttf=$(PATCHEDDIR)/Ricty\ Diminished\ %\ Nerd\ Font\ Complete.ttf)
RD_CMP_MONO_FILES  = $(RD_SOURCE_FILES:$(SRCDIR)/RictyDiminished-%.ttf=$(PATCHEDDIR)/Ricty\ Diminished\ %\ Nerd\ Font\ Complete\ Mono.ttf)
RDD_CMP_FILES      = $(RDD_SOURCE_FILES:$(SRCDIR)/RictyDiminishedDiscord-%.ttf=$(PATCHEDDIR)/Ricty\ Diminished\ Discord\ %\ Nerd\ Font\ Complete.ttf)
RDD_CMP_MONO_FILES = $(RDD_SOURCE_FILES:$(SRCDIR)/RictyDiminishedDiscord-%.ttf=$(PATCHEDDIR)/Ricty\ Diminished\ Discord\ %\ Nerd\ Font\ Complete\ Mono.ttf)

DESTDIR = $(HOME)/Library/Fonts


.PHONY: all
all: clean source build

$(SRCDIR)/ricty_diminished-$(VERSION).tar.gz:
	curl -sSfL https://www.rs.tus.ac.jp/yyusa/ricty_diminished/ricty_diminished-$(VERSION).tar.gz -o $@

.PHONY: source
source: $(SRCDIR)/ricty_diminished-$(VERSION).tar.gz
	tar zxf $(SRCDIR)/ricty_diminished-$(VERSION).tar.gz -C $(SRCDIR)

	$(eval $(foreach FILE, $(RD_SOURCE_FILES), \
		$(eval $(call PATCHER,$(FILE),Ricty\ Diminished,$(FILE:$(SRCDIR)/RictyDiminished-%.ttf=%)))))


define PATCHER
$(PATCHEDDIR)/$(2)\ $(3)\ Nerd\ Font\ Complete.ttf:$(1)
	docker run --rm -i -v $(shell pwd):/data iwai/nerd-fontpatcher \
		--quiet --no-progressbars --adjust-line-height --complete -out patched $(1) 2>/dev/null

$(PATCHEDDIR)/$(2)\ $(3)\ Nerd\ Font\ Complete\ Mono.ttf:$(1)
	docker run --rm -i -v $(shell pwd):/data iwai/nerd-fontpatcher \
		--quiet --no-progressbars --adjust-line-height --complete --mono -out patched $(1) 2>/dev/null

endef

$(foreach FILE, $(RD_SOURCE_FILES), \
	$(eval $(call PATCHER,$(FILE),Ricty\ Diminished,$(FILE:$(SRCDIR)/RictyDiminished-%.ttf=%))))

$(foreach FILE, $(RDD_SOURCE_FILES), \
	$(eval $(call PATCHER,$(FILE),Ricty\ Diminished\ Discord,$(FILE:$(SRCDIR)/RictyDiminishedDiscord-%.ttf=%))))

.PHONY: build
build: $(RD_CMP_FILES) $(RD_CMP_MONO_FILES) $(RDD_CMP_FILES) $(RDD_CMP_MONO_FILES)

.PHONY: install
install: $(RD_CMP_FILES) $(RD_CMP_MONO_FILES) $(RDD_CMP_FILES) $(RDD_CMP_MONO_FILES)
	$(INSTALL_DATA) $(PATCHEDDIR)/*.ttf $(DESTDIR)

# FIXME: release target move to parent Makefile
ricty_diminished_nerd_font-$(TAG).tar.gz: $(RD_CMP_FILES) $(RD_CMP_MONO_FILES) $(RDD_CMP_FILES) $(RDD_CMP_MONO_FILES)
	tar --exclude .gitkeep -czf ricty_diminished_nerd_font-$(TAG).tar.gz -C $(PATCHEDDIR)/ .

.PHONY: release
release: ricty_diminished_nerd_font-$(TAG).tar.gz
	hub release create -m "Release $(TAG) for Nerd fonts" -a ./ricty_diminished_nerd_font-$(TAG).tar.gz $(TAG)

.PHONY: clean
clean:
	-$(RM) $(SRCDIR)/*
	-$(RM) $(PATCHEDDIR)/*
	-$(RM) ricty_diminished_nerd_font-$(TAG).tar.gz
