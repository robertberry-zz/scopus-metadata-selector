# Error model - represents Scopus API error

define [
  "jquery",
  "underscore",
  "backbone"
], ($, _, Backbone) ->
  class SearchError extends Backbone.Model
    # parameters:
    #  message

  SearchError