# Custom Renderer for the Sciverse search API

define ->
  class Renderer
    # Constructs a Renderer with the given reference to a Documents
    # instance. This collection will be updated by the Renderer when searches
    # are successfully made - the actual rendering code should be performed by
    # a Backbone.View that also has a reference to the collection.
    constructor: (@documents, @warnings, @errors) ->

    renderErrors: (errors) ->
      @documents.reset []
      @errors.reset({message: error} for error in errors)

    # Renders search results - places the returned results into the Documents
    # collection.
    renderResults: (results) ->
      @documents.reset results
      @errors.reset []

    renderField: (response, position, field) ->
      # render results no longer uses this

    renderWarnings: (warnings) ->
      @warnings.reset({message: warning} for warning in warnings)

    setRenderLocation: (id) ->
      # render results no longer uses this

  return Renderer