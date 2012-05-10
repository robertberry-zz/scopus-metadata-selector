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

    filter_query: (query) ->
      # Get rid of any chars that are not letters, spaces or digits
      # Scopus API gets confused especially by parentheses, which are part of
      # its special search syntax.
      query.replace(/[^\w\s\d]/g, "")

    search: (query) ->
      @trigger "search:start", query
      search = new searchObj
      search.setNumResults config.results_per_page
      search.setSearch @filter_query(query)
      # By default sorts in descending order of when published
      search.setSort "Relevancy"
      sciverse.search search