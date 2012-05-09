# A view that updates a hidden field with a JSON string representation of the collection

define [
  "jquery",
  "underscore",
  "backbone",
  "utils/utf8"
], ($, _, Backbone, utf8) ->
  class JSONField extends Backbone.View
    tagName: "input"

    attributes:
      type: "hidden"

    initialize: ->
      if @collection
        @collection.bind "add", _.bind(@render, @)
        @collection.bind "remove", _.bind(@render, @)
        @collection.bind "change", _.bind(@render, @)
        @collection.bind "reset", _.bind(@render, @)
      else if @model
        @model.bind "change", _.bind(@render, @)

    render: ->
      json = JSON.stringify(@model || @collection)
      if @options["utf8"]
        json = utf8.encode json
      @$el.val json

  JSONField