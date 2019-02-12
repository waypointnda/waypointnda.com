FILES=files
FORMATS=docx rtf pdf odt md
RTF=$(wildcard $(FILES)/*.rtf)
LATEST=$(lastword $(sort $(RTF)))
LINT=node_modules/html5-lint

all: $(foreach version,$(RTF),$(addprefix $(version:.rtf=).,$(FORMATS))) $(FILES)/latest.md

%.odt: %.rtf
	unoconv -f odt $<

%.pdf: %.odt
	unoconv -f pdf $<

%.docx: %.odt
	unoconv -f docx $<

%.md: %.odt
	pandoc -t commonmark -o $@ $<

.INTERMEDIATE: $(FILES)/latest.rtf

$(FILES)/latest.rtf: $(LATEST)
	cp $< $@

.PHONY: lint

$(LINT):
	npm install

lint: | $(LINT)
	./lint
