define [
  "extensions/MustacheView",
  "text!templates/search_result.html"
], (MustacheView, template) ->
  class SearchResult extends MustacheView
    tagName: "div"

    attributes:
      class: "search_result"

    events:
      "click .select_result": "toggle"

    forward_events: ["select", "deselect"]

    template: template

    # Fires the selected/deselected event when the checkbox is toggled
    toggle: ->
      checkbox = @$(".select_result")
      event = if checkbox.is(':checked') then "select" else "deselect"
      @trigger event, @model

  SearchResult