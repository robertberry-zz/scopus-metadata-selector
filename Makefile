# todo: add command to build JavaScripts from CoffeeScripts (I have been using Guard.)

install: build/images build/index.html build/stylesheets clean_javascript

app/scripts: app/coffeescripts app/coffeescripts/config.coffee
	coffee -o app/scripts -c app/coffeescripts

clean_javascript: build/scripts/main.js
	scripts/clean_build_scripts.sh

build/images: build
	cp -r app/images build/images

build/index.html: build
	cp app/index.html build/index.html

build/stylesheets: build
	cp -r app/stylesheets build/stylesheets

build/scripts/main.js: app/scripts
	r.js -o app.build.js

build:
	mkdir build

app/coffeescripts/config.coffee: config.coffee
	cp ./config.coffee ./app/coffeescripts/config.coffee

clean:
	rm -Rf build
