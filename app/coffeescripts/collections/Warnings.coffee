# Collection for the SciVerse Warning

define [
  "jquery",
  "underscore",
  "backbone",
  "models/Warning"
], ($, _, Backbone, Warning) ->
  class Warnings extends Backbone.Collection
    model: Warning

  Warnings