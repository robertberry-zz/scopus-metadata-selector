# Functions for performing transformations to objects

define [
  "underscore"
], (_) ->
  exports = {}
  # Returns a transformation that renames an attribute
  exports.renames = (before, after) ->
    (attrs) ->
      attrs[after] = attrs[before]
      delete attrs[before]
      attrs

  # Returns a transformation that removes an attribute
  exports.strips = (attribute) ->
    (attrs) ->
      delete attrs[attribute]
      attrs

  # Returns a transformation that sets an attribute
  exports.sets = (attribute, value) ->
    (attrs) ->
      attrs[attribute] = value
      attrs

  # Returns a transformation that uses the given function to transform an
  # attribute's value
  exports.transforms = (attribute, f) ->
    (attrs) ->
      attrs[attribute] = f(attrs[attribute])
      attrs

  # Returns a transformation that composes a new attribute using an Underscore
  # template and other attributes from the object
  exports.composes = (attribute, template) ->
    (attrs) ->
      attrs[attribute] = _.template(template, attrs)

  # Returns a transformation that creates new attributes from match groups a
  # regular expression finds on a given attribute
  exports.sets_from = (attribute, re, new_attributes...) ->
    (attrs) ->
      if attrs[attribute]
        matches = attrs[attribute].match re
        matches.shift() # remove whole match
        for [key, val] in _.zip(new_attributes, matches)
          attrs[key] = val
      attrs

  # Same as above, but deletes the original attribute
  exports.extracts = (attribute, re, new_attributes...) ->
    _.compose(
      strips(attribute)
      sets_from.apply(sets_from, [attribute, re].concat(new_attributes)),
    )

  # Returns a transformation that looks up the given attribute's value in the
  # given map and sets it to the map's value
  exports.maps = (attribute, map) ->
    (attrs) ->
      if map[attrs[attribute]]
        attrs[attribute] = map[attrs[attribute]]
      attrs

  exports