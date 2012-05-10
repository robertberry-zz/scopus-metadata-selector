# Transformations for strings

define [
  "underscore"
], (_) ->
  exports = {}

  # Returns a transformation that splits the string with the given regular expression
  exports.splits = (re) ->
    (s) ->
      s.split re

  exports