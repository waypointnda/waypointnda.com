mustache=node_modules/.bin/mustache
pages=$(wildcard *.mustache.html)
partials=$(wildcard partials/*)
targets=$(pages:.mustache.html=.html) versions.xml logo.png

all: $(targets)

%.html: view.json %.mustache.html tidy.config $(partials) | $(mustache) site
	$(mustache) view.json $*.mustache.html $(foreach partial,$(partials),-p $(partial)) | tidy -config tidy.config > $@

versions.xml: view.json versions.mustache.xml | $(mustache) site
	$(mustache) view.json versions.mustache.xml | xmllint --format - > $@

%.png: %.svg
	convert $< $@

site:
	mkdir -p site

$(mustache):
	npm ci

.PHONY: clean

clean:
	rm -f $(targets)
