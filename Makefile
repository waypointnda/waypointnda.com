FILES=files
FORMATS=docx rtf pdf odt md
ODT=$(wildcard $(FILES)/*.odt)
LINT=node_modules/html5-lint

all: $(foreach version,$(ODT),$(addprefix $(version:.odt=).,$(FORMATS)))

%.rtf: %.odt
	unoconv -f rtf $<

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
