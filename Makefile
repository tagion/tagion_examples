.SUFFIXES:
.SECONDARY:
.ONESHELL:
.SECONDEXPANSION:

include config.mk

all: libtagion secp256k1 

tagion-%:
	$(PRECMD)
	echo tag $*
	$(MAKE) -C $(TAGION) $*

test33:
	@
	echo TAGION $(TAGION)
	echo TAGIONMKLOG $(TAGIONMKLOG)
	echo DTUB $(DTUB)
	echo DTARGETS $(DTARGETS)

-include $(TAGIONREPO)
-include $(DTUB)/utilities/log.mk
-include $(DTARGETS)/install.mk
-include $(DTARGETS)/compiler.mk

ifdef log.info
help:
	$(PRECMD)
	$(call log.header, $@ :: help)
	$(call log.help, "make libtagion", "Compiles tagion as a library")
	$(call log.help, "make tagion-<tag>", "Calls the make <tag> in the tagion submodule")
	$(call log.close)

env:
	$(PRECMD)
	$(call log.header, $@ :: env)
	$(call log.kvp, REPOROOT, $(REPOROOT))
	$(call log.kvp, TAGION, $(TAGION))
	$(call log.kvp, DTAGION_SRC, $(DTAGION_SRC))
	$(call log.kvp, TAGION_BUILD, $(TAGION_BUILD))
	$(call log.kvp, TAGION_DLIB, $(TAGION_DLIB))
	$(call log.env, DFLAGS, $(DFLAGS))
	$(call log.env, DLIB, $(DLIB))
	$(call log.env, DINC, $(DINC))


env-compiler: tagion-env-compiler

else
help:
	$(PRECMD)
	echo tagion not install

endif

secp256k1: $(TAGION)/.git | tagion-secp256k1

libtagion:  $(TAGION)/.git | tagion-libtagion 

$(TAGION)/.git:
	$(PRECMD)
	git clone -b current $(TAGIONREPO) $(@D)

clean:

proper: clean
	$(PRECMD)
	rm -fR tagion

