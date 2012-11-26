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
LATEXMK_FLAGS	= -outdir=$(BUILDDIR) -pdf -silent

begin: $(SUBDIRS) $(MISCDEP)
	@for x in $(SUBDIRS); do $(MAKE) -C $$x; done
	latexmk $(LATEXMK_FLAGS) -pvc $(MAINFILE)

.PHONY: clean
clean:
	@for x in $(SUBDIRS); do $(MAKE) clean -C $$x; done
	latexmk $(LATEXMK_FLAGS) -C $(MAINFILE)

