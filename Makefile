# todo: add command to build JavaScripts from CoffeeScripts (I have been using Guard.)

install: build/images build/index.html build/stylesheets build/scripts/main.js

build/images: build
	cp -r app/images build/images

build/index.html: build
	cp app/index.html build/index.html

build/stylesheets: build
	cp -r app/stylesheets build/stylesheets

build/scripts/main.js: app/coffeescripts/config.coffee
	r.js -o app.build.js

build:
	mkdir build

app/coffeescripts/config.coffee: config.coffee
	cp ./config.coffee ./app/coffeescripts/config.coffee

clean:
	rm -Rf build



