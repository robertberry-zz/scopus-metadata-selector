# Sort by header

define [
  "extensions/MustacheView",
  "text!templates/sort_by_header.html"
], (MustacheView, template) ->
  SORT_DIRECTIONS = ["Ascending", "Descending"]
  
  class SortByHeader extends MustacheView
    tagName: "th"

    attributes:
      class: "ep_columns_title"

    template: template

    events:
      "click .sort_action": "on_click"

    # Should pass an options hash containing 'field' (the field by which to
    # sort) and 'title' (a title for the header).
    initialize: ->
      @deactivate()
      @reset_direction()

    # Deactivate this field for sorting
    deactivate: ->
      @_activated = no

    # Activate this field for sorting
    activate: ->
      @trigger "activate", @
      @_trigger_sort()
      @reset_direction()
      @_activated = yes

    # Whether currently sorting by this field
    activated: ->
      @_activated

    # Reset sorting direction
    reset_direction: ->
      @_direction = 0

    # Reverse sorting direction
    reverse_direction: ->
      @_direction = 1 - @_direction
      @_trigger_sort()

    _trigger_sort: ->
      @trigger "sort", {
        field: @options["field"],
        direction: @direction(),
      }

    title: ->
      @options["title"]

    # Sorting direction (Ascending|Descending)
    direction: ->
      SORT_DIRECTIONS[@_direction]

    # Fired when the header is clicked
    on_click: (event) ->
      event.preventDefault()
      if @activated()
        @reverse_direction()
      else
        @activate()
  