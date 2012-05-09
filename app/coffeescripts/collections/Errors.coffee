# Collection for the SciVerse Error

define [
  "jquery",
  "underscore",
  "backbone",
  "models/Error"
], ($, _, Backbone, Error) ->
  class Errors extends Backbone.Collection
    model: Error

  Errors