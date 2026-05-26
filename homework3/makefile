HWID=3
TYPST_FILE = hw$(HWID).typ
TEMPLATE_FILE = ../template.typ
PDF = hw$(HWID).pdf
DIST_DIR = dist

-include ../.env
STUDENT_ID ?= unknown
NAME ?= unknown

all: $(PDF)

$(PDF): $(TYPST_FILE) $(TEMPLATE_FILE)
	rm -f $(PDF)
	typst compile $(TYPST_FILE)

watch:
	typst watch $(TYPST_FILE)

archive: 
	mkdir -p $(DIST_DIR)
	cp $(PDF) $(DIST_DIR)/$(STUDENT_ID)_$(NAME)_HW$(HWID).pdf

clean:
	rm -f $(PDF)

distclean: clean
	rm -rf $(DIST_DIR)

.PHONY: all clean distclean watch archive
