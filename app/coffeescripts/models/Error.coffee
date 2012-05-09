# Error model - represents Scopus API error

define [
  "jquery",
  "underscore",
  "backbone"
], ($, _, Backbone) ->
  class Error extends Backbone.Model
    # parameters:
    #  message

  Error