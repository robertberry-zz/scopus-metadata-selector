# Transformations for lists

define [
  "underscore"
], (_) ->
  exports = {}

  # todo: add a partials function and reimplement these using it

  # Returns a transformation that maps the function over the list
  exports.maps = (f) ->
    (xs) ->
      _.map(xs, f)

  # Returns a transformation that rejects elements in the list for which f
  # is true
  exports.rejects = (f) ->
    (xs) ->
      _.reject(xs, f)

  exports