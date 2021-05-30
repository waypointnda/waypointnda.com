mustache=node_modules/.bin/mustache
json=node_modules/.bin/json
pages=$(wildcard *.mustache.html)
partials=$(wildcard partials/*)
targets=$(pages:.mustache.html=.html) versions.xml logo.png latest

all: $(targets)

%.html: view.json %.mustache.html tidy.config $(partials) | $(mustache) site
	$(mustache) view.json $*.mustache.html $(foreach partial,$(partials),-p $(partial)) | tidy -config tidy.config > $@

versions.xml: view.json versions.mustache.xml | $(mustache) site
	$(mustache) view.json versions.mustache.xml | xmllint --format - > $@

latest: view.json | $(json)
	$(json) latest < $< > $@

%.png: %.svg
	convert $< $@

site:
	mkdir -p site

$(mustache):
	npm ci

.PHONY: clean

clean:
	rm -f $(targets)
