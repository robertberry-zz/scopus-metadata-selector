# Scopus Metadata Selector

Scopus Metadata Selector is a JavaScript component for querying
[Scopus's](http://www.scopus.com/home.url) API for metadata based on search
criteria, then posting selected results as a JSON string to an endpoint on the
host server.

Developed as part of a more complete import plug in for
[EPrints](http://www.eprints.org/) but should be easily adaptable to other systems.

## Requirements for build

* [RequireJS optimizer](http://requirejs.org/docs/optimization.html)
* [CoffeeScript compiler](https://github.com/jashkenas/coffee-script)

## Build

Add your API key to the `config.coffee.new`, then rename to
`config.coffee`. Now run make.

```bash
$ mv config.coffee.new config.coffee
$ make
```

This will output minified JavaScript into the build directory.

## Recommended for development

* [RVM](https://rvm.io//)
* [Bundler](http://gembundler.com/)

## Setting up development environment

Use RVM and Bundler to install the dependencies:

```bash
$ bundle install
```

Use Guard to compile CoffeeScript files on the fly as you edit them:

```bash
$ bundle exec guard
```

Use Python's SimpleHTTPServer to serve the files:

```bash
$ cd app
$ python -m SimpleHTTPServer
```
