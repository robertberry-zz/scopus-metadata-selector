

define [
  "utils/Events",
  "views/Button"
], (Events, Button) ->
  class SelectAllController extends Events
    constructor: (@search_results) ->
      # pass