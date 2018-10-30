FILES=files
FORMATS=docx rtf pdf odt
DOCX=$(wildcard $(FILES)/*.rtf)
LINT=node_modules/html5-lint

all: $(foreach version,$(DOCX),$(addprefix $(version:.rtf=).,$(FORMATS)))

%.odt: %.rtf
	unoconv -f odt $<

%.pdf: %.odt
	unoconv -f pdf $<

%.docx: %.odt
	unoconv -f docx $<

.PHONY: lint

$(LINT):
	npm install

lint: | $(LINT)
	./lint
