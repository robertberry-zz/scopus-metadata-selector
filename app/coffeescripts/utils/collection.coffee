# Utility functions relating to Backbone Collections

define [
  "underscore"
], (_) ->
  exports = {}

  identity = (x) -> x

  # Maps collection x to y. Corresponding models will be calculated for y
  # using f to transform the attributes list. Any further modifications to x
  # will update y also.
  exports.map = (x, y, f=identity) ->
    if not y.model
      throw "Second collection must specify its model."

    # Create a y model given an x model
    transform = (model) ->
      new y.model f(model.toJSON())

    # Find a y model corresponding to the given x model
    find_in_y = (model) ->
      y.find (transformed) ->
        transformed._mapped_from is model

    # Fully updates y to mirror x
    set_all = ->
      y.reset(x.map transform)

    # Whenever a model is added to x, add a corresponding model to y
    x.bind "add", (model) ->
      transformed = transform model
      transformed._mapped_from = model
      y.add transformed

    # Whenever a model is removed from x, remove the correponding model from y
    x.bind "remove", (model) ->
      transformed = find_in_y(model)
      y.remove transformed

    # Whenever a model's attributes are updated in x, update the attributes in y
    x.bind "change", (model) ->
      transformed = find_in_y(model)
      # change is also fired on add
      if transformed
        transformed.set f(model.toJSON())

    # Whenever x is reset, update all in y
    x.bind "reset", set_all

    # Set y to mirror x to start off with
    set_all()

  exports