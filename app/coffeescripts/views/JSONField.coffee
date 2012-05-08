# A view that updates a hidden field with a JSON string representation of the collection

includes = [
  "jquery",
  "underscore",
  "backbone"
]

define includes, ($, _, Backbone) ->
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
      @$el.val JSON.stringify(@model || @collection)

  JSONField