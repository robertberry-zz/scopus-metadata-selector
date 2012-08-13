# Collection for the SciVerse Error

define [
  "jquery",
  "underscore",
  "backbone",
  "models/SearchError"
], ($, _, Backbone, SearchError) ->
  class Errors extends Backbone.Collection
    model: SearchError

  Errors