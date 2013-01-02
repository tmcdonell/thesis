#
# Variables
#
export MAINROOT = $(shell pwd)

#
# Rules
#
MAINFILE	= thesis

SUBDIRS		= images semantics
MISCDEP		= listings
BUILDDIR	= build
LATEXMK_FLAGS	= -outdir=$(BUILDDIR) -pdf
OTT_FLAGS	= -show_sort true -show_defns true -tex_wrap false

begin: $(SUBDIRS) $(MISCDEP)
	@for x in $(SUBDIRS); do $(MAKE) -C $$x; done
	latexmk $(LATEXMK_FLAGS) -pvc $(MAINFILE)

%.tex: %.mng
	ott $(OTT_FLAGS) -tex_filter $< $@ $(OTT_FILES)


.PHONY: clean distclean
clean:
	@for x in $(SUBDIRS); do $(MAKE) clean -C $$x; done
	latexmk $(LATEXMK_FLAGS) -C $(MAINFILE)

distclean:
	rm -rf $(BUILDDIR)

