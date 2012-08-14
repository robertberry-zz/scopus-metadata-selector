
define [
  "extensions/MustacheView",
  "text!templates/more_results.html",
], (MustacheView, template) ->
  class MoreResults extends MustacheView
    tagName: "div"

    events:
      "click": "on_click"

    attributes:
      class: "more_results"

    template: template

    initialize: (@options) ->
      @search = @options["staggered_search"]

      @search.on "page_loaded", =>
        if @more()
          @render()
          @$el.show()
        else
          @$el.hide()

      @search.on "load_page", =>
        @$el.hide()

    more: ->
      @search.how_many_more()

    on_click: (event) ->
      event.preventDefault()
      @search.next()
