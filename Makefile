mustache=node_modules/.bin/mustache
json=node_modules/.bin/json
svgs=$(wildcard *.svg)
pages=$(wildcard *.mustache.html)
partials=$(wildcard partials/*)
targets=$(pages:.mustache.html=.html) versions.xml $(svgs:.svg=.png) latest social.png
docxs=$(wildcard files/*.docx)
formats=docx pdf odt rtf
conversions=$(foreach format,$(formats),$(docxs:.docx=.$(format)))

all: $(targets) $(conversions)

%.html: view.json %.mustache.html tidy.config $(partials) | $(mustache) site
	$(mustache) view.json $*.mustache.html $(foreach partial,$(partials),-p $(partial)) | tidy -config tidy.config > $@

versions.xml: view.json versions.mustache.xml | $(mustache) site
	$(mustache) view.json versions.mustache.xml | xmllint --format - > $@

latest: view.json | $(json)
	$(json) latest < $< > $@

%.png: %.svg
	convert $< $@

social.png: logo.svg
	convert -size 500x500 -fill white -gravity center -extent 500x500 -border 25x25 -bordercolor white $< $@

files/%.pdf: files/%.docx
	soffice --headless --convert-to pdf --outdir files $<

files/%.odt: files/%.docx
	soffice --headless --convert-to odt --outdir files $<

files/%.rtf: files/%.docx
	soffice --headless --convert-to rtf --outdir files $<

site:
	mkdir -p site

$(mustache):
	npm ci

.PHONY: clean

clean:
	rm -f $(targets)
