# Search router

define [
  "jquery",
  "underscore",
  "backbone",
  "config"
], ($, _, Backbone, config) ->
  # Routes for querying Scopus database
  class SearchRouter extends Backbone.Router
    routes:
      "search/:query": "search"

    initialize: ->
      sciverse.setCallback =>
        @trigger "search:end"

    # Do nothing for now, I'll just observe the event that's fired in main script.
    search: (query) ->
      @trigger "search:start", query
      search = new searchObj
      search.setNumResults config.results_per_page
      search.setSearch query
      sciverse.search search