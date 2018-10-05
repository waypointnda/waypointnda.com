FILES=files
FORMATS=docx rtf pdf odt
DOCX=$(wildcard $(FILES)/*.rtf)

all: $(foreach version,$(DOCX),$(addprefix $(version:.rtf=).,$(FORMATS)))

%.odt: %.rtf
	unoconv -f odt $<

%.pdf: %.odt
	unoconv -f pdf $<

%.docx: %.odt
	unoconv -f docx $<
