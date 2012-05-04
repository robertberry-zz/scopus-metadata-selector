# Utility functions relating to objects

includes = [
  "underscore"
]

define includes, (_) ->
  exports = {}

  # Returns a hash containing all of the object's methods, bound to the object
  exports.methods = (object) ->
    method_names = _.functions(object)
    methods = {}
    for method_name in method_names
      methods[method_name] = _.bind(object[method_name], object)
    methods

  exports