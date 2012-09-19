# Generic button class for attaching a callback
  
define [
  "jquery",
  "underscore",
  "backbone"
], ($, _, Backbone) ->
  class Button extends Backbone.View
    tagName: "input"

    attributes:
      type: "button"
      class: "ep_form_action_button"

    events:
      click: "on_click"
  
    initialize: ->
      @_callback = @options['callback']
      @attributes.value = @options['text']

    on_click: (event) ->
      event.preventDefault()
      @_callback()

  Button
