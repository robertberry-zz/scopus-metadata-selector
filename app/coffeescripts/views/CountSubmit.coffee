
define [
  "jquery",
  "underscore",
  "backbone"
], ($, _, Backbone) ->
  class CountSubmit extends Backbone.View
    tagName: "input"

    attributes:
      type: "submit"

    template: "Submit (<%= count %>)"

    initialize: ->
      if @collection
        @collection.bind "add", _.bind(@render, @)
        @collection.bind "remove", _.bind(@render, @)
        @collection.bind "reset", _.bind(@render, @)
      else
        # todo: add exception class
        throw "CountSubmit must be initialized with a collection."
      if @options['template']
        @template = @options['template']

    render: ->
      count = @collection.length
      if @options['disable_on_zero']
        @$el.attr "disabled", count == 0
      @$el.val _.template(@template, count: count)