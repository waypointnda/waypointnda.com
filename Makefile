FILES=files
FORMATS=docx rtf pdf odt
ODT=$(wildcard $(FILES)/*.odt)
LINT=node_modules/html5-lint

all: $(foreach version,$(ODT),$(addprefix $(version:.odt=).,$(FORMATS)))

%.rtf: %.odt
	unoconv -f rtf $<

%.pdf: %.odt
	unoconv -f pdf $<

%.docx: %.odt
	unoconv -f docx $<

.PHONY: lint

$(LINT):
	npm install

lint: | $(LINT)
	./lint


docker:
	docker build -t waypointnda .
	docker run --name waypointnda waypointnda
	docker cp waypointnda:/workdir/files .
	docker rm waypointnda
