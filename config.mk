export PLATFORM?=x86_64-linux

export DC?=dmd

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
DLIB+=$(TAGION_DLIB)/tmp/secp256k1/.libs/libsecp256k1.a
TAGIONREPO?=git@github.com:tagion/tagion.git
TAGIONMKLOG=$(DTUB)/utilities/log.mk


DFLAGS+=$(DDEBUG_SYMBOLS)
DFLAGS+=$(DPREVIEW)=dip1000
DFLAGS+=$(DPREVIEW)=inclusiveincontracts

DINC=$(shell find $(DTAGION_SRC) -maxdepth 1 -type d -path "*/lib-*")
