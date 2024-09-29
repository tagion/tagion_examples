export PLATFORM?=x86_64-linux

export DC?=dmd

MAIN+=hibon_example 

BIN:=.
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
export REPOROOT ::= $(dir $(mkfile_path))

PRECMD?=@
TAGION?=$(abspath $(REPOROOT)/tagion)
DTUB?=$(TAGION)/tub
DTARGETS?=$(DTUB)/targets
DTAGION_SRC?=$(TAGION)/src
TAGION_BUILD?=$(TAGION)/build/${PLATFORM}
TAGION_DLIB?=$(TAGION_BUILD)/lib
DLIB+=$(TAGION_DLIB)/libtagion.a
DLIB+=$(TAGION_BUILD)/tmp/secp256k1/.libs/libsecp256k1.a
TAGIONREPO?=git@github.com:tagion/tagion.git
TAGIONMKLOG=$(DTUB)/utilities/log.mk

DVERSIONS+=REDBLACKTREE_SAFE_PROBLEM




DFLAGS+=$(DDEBUG_SYMBOLS)
DFLAGS+=$(DPREVIEW)=dip1000
DFLAGS+=$(DPREVIEW)=inclusiveincontracts

DSRC+=$(shell find $(REPOROOT)/tagion_packages -name "package.d")
DINC+=$(REPOROOT)/tagion_packages/

DINC+=$(shell find $(DTAGION_SRC) -maxdepth 1 -type d -path "*/lib-*")
