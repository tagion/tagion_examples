.SUFFIXES:
.SECONDARY:
.ONESHELL:
.SECONDEXPANSION:

include config.mk

all: libtagion 

tagion-%:
	$(PRECMD)
	echo tag $*
	$(MAKE) -C $(TAGION) $*

test33:
	echo $(TAGION)
	echo $(TAGIONMKLOG)

-include $(TAGION)/tub/utilities/log.mk

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


else
help:
	$(PRECMD)
	echo tagion not install

endif

libtagion: $(TAGION)/.git
	$(PRECMD)
	$(MAKE) -C $(TAGION) $@

$(TAGION)/.git:
	$(PRECMD)
	git pull --recurse-submodules
