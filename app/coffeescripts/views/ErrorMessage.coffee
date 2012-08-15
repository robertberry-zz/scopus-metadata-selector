# Scopus error message view

define [
  "extensions/MustacheView",
  "text!templates/error_message.html"
], (MustacheView, template) ->
  class ErrorMessage extends MustacheView
    tagName: "li"

    attributes:
      class: "scopus_error"

    template: template

  ErrorMessage