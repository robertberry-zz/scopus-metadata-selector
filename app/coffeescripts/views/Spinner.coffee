# Scopus error message view

define [
  "extensions/MustacheView",
  "text!templates/spinner.html"
], (MustacheView, template) ->
  class Spinner extends MustacheView
    tagName: "div"

    attributes:
      class: "spinner"

    template: template

    hide: ->
      @$el.hide()

    show: ->
      @$el.show()

  Spinner