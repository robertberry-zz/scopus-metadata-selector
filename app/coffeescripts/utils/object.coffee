# Utility functions relating to objects

define [
  "underscore"
], (_) ->
  exports = {}

  # Returns a hash containing all of the object's methods, bound to the object
  exports.methods = (object) ->
    method_names = _.functions(object)
    methods = {}
    for method_name in method_names
      methods[method_name] = _.bind(object[method_name], object)
    methods

  # Returns a function that given an object, renames its before attribute to after
  exports.renames_attribute = (before, after) ->
    (attrs) ->
      attrs[after] = attrs[before]
      delete attrs[before]
      attrs

  # Returns a function that given an object, removes the attribute
  exports.strips_attribute = (attribute) ->
    (attrs) ->
      delete attrs[attribute]
      attrs

  # Returns a function that given an object, performs the transformation on
  # the attribute
  exports.transforms_attribute = (attribute, f) ->
    (attrs) ->
      attrs[attribute] = f(attrs[attribute])
      attrs

  # Composes a new attribute in the object given the other attributes using an
  # Underscore.js template
  exports.composes_attribute = (attribute, template) ->
    (attrs) ->
      attrs[attribute] = _.template(template, attrs)

  exports