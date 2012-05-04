# Custom Renderer for the Sciverse search API

includes = [
]

define includes, ->
  class Renderer
    # Constructs a Renderer with the given reference to a Documents
    # instance. This collection will be updated by the Renderer when searches
    # are successfully made - the actual rendering code should be performed by
    # a Backbone.View that also has a reference to the collection.
    constructor: (@documents) ->

    renderErrors: (errors) ->
      console.debug "renderErrors", errors

    # Renders search results - places the returned results into the Documents
    # collection.
    renderResults: (results) ->
      @documents.reset results

    renderField: (response, position, field) ->
      console.debug "renderField", response, position, field

    renderWarnings: (warnings) ->
      console.debug "renderWarnings", warnings

    setRenderLocation: (id) ->
      console.debug "setRenderLocation", id

  return Renderer