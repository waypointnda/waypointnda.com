FILES=files
FORMATS=docx rtf pdf odt md
DOCX=$(wildcard $(FILES)/*.rtf)
LINT=node_modules/html5-lint

all: $(foreach version,$(DOCX),$(addprefix $(version:.rtf=).,$(FORMATS)))

%.odt: %.rtf
	unoconv -f odt $<

%.pdf: %.odt
	unoconv -f pdf $<

%.docx: %.odt
	unoconv -f docx $<

%.md: %.odt
	pandoc -t commonmark -o $@ $<

.PHONY: lint

$(LINT):
	npm install

lint: | $(LINT)
	./lint
