# Very simple set class. Should be extended to implement underscore methods, etc.

class Set
  initialize: (data) ->
    @_contents = {}
    @extend data

  add: (datum) ->
    @_contents[datum] = 1

  remove: (datum) ->
    delete @_contents[datum]

  extend: (data) ->
    for datum in data
      @add datum

  include: (datum) ->
    datum in @_contents
