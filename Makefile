.SUFFIXES:
.SECONDARY:
.ONESHELL:
.SECONDEXPANSION:

include config.mk

all: examples | libraries

run: all
	$(PRECMD)
	$(addprefix $(BIN)/,$(addsuffix ;,$(MAIN)))

tagion-%:
	$(PRECMD)
	echo tag $*
	$(MAKE) -C $(TAGION) $*

libraries: libtagion secp256k1

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
	$(call log.help, "make run", "Compiles and run all the test examples")
	$(call log.help, "make <example>", "This will only compiler <example>")
	$(call log.help, "make env", "List the compilation environment")
	$(call log.help, "make libtagion", "Compiles tagion as a library")
	$(call log.help, "make secp256k1", "Compiles the secp256k1 secure library")
	$(call log.help, "make tagion-<tag>", "Calls the make <tag> in the tagion submodule")
	$(call log.help, "make clean", "Erase the build")
	$(call log.help, "make proper", "This will remove the tagion library and erase the build")
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
	$(call log.env, MAIN, $(MAIN))

env-compiler: tagion-env-compiler

examples: $(MAIN)
else
help:
	$(PRECMD)
	echo tagion not installed

ifndef EXAMPLE_RECURSIVE 
examples: libraries  
	#$(PRECMD)
	make EXAMPLE_RECURSIVE=1 $@
endif
endif

%: %.d 
	$(PRECMD)
	$(DC) $(DFLAGS) $(addprefix -I,$(DINC)) $(addprefix $(DVERSION)=,$(DVERSIONS)) $(DSRC) $< $(DOUT)=$@ $(DLIB)	

secp256k1: $(TAGION)/.git | tagion-secp256k1

libtagion:  $(TAGION)/.git | tagion-libtagion 

$(TAGION)/.git:
	$(PRECMD)
	git clone -b current $(TAGIONREPO) $(@D)

clean:
	$(PRECMD)
	rm -f $(MAIN)
	rm -f *.o 

proper: clean
	$(PRECMD)
	rm -fR tagion

