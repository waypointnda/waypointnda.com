FILES=files
FORMATS=docx rtf pdf odt
ODT=$(wildcard $(FILES)/*.odt)

all: $(foreach version,$(ODT),$(addprefix $(version:.odt=).,$(FORMATS)))

%.rtf: %.odt
	unoconv -f rtf $<

%.pdf: %.odt
	unoconv -f pdf $<

%.docx: %.odt
	unoconv -f docx $<
