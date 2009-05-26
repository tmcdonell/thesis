#
# Variables
#
export MAINROOT  = $(shell pwd)

#
# Rules
#
MAINFILE	= thesis

SOURCES		= $(wildcard *.tex)
SUBDIRS		= images
MISCDEP		= listings
BUILDDIR	= build
RUBBER_FLAGS	= --pdf --warn all --into $(BUILDDIR)

default: $(MAINFILE:%=%.pdf)

%.pdf : %.tex %.bib $(SUBDIRS) $(SOURCES) $(MISCDEP)
	@for x in $(SUBDIRS); do $(MAKE) -C $$x; done
	@[ -d $(BUILDDIR) ] || mkdir $(BUILDDIR)
	rubber $(RUBBER_FLAGS) $<
	@[ -e $@ ] || ln -s $(BUILDDIR)/$@

.PHONY: clean
clean:
	@for x in $(SUBDIRS); do $(MAKE) clean -C $$x; done
	rubber $(RUBBER_FLAGS) --clean $(MAINFILE)
	@$(RM) -d $(BUILDDIR)
	@[ -L $(MAINFILE:%=%.pdf) ] && $(RM) $(MAINFILE:%=%.pdf)

