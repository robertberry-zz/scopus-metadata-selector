# Provides functions for encoding / decoding UTF8

define ["underscore"], (_) ->
  exports = {}

  exports.encode = _.compose unescape, encodeURIComponent
  exports.decode = _.compose decodeURIComponent, escape

  exports