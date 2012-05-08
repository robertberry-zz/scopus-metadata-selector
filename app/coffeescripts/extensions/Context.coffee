# Context class

define [
  "underscore",
  "utils/object"
], (_, object) ->
  # Context for use in a Mustache view. Given the view and the model, attaches
  # the methods to the context and the model attributes, allowing convenient
  # access to all.
  class Context
    constructor: (view, model) ->
      _.extend @, object.methods(view)
      _.extend @, object.methods(model)
      _.extend @, model.attributes