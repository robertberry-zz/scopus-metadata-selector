# Staggers searching for documents, allows you to load more pages, updating a
# collection automatically.

define [
  "utils/Events",
  "views/SortByHeader"
], (Events, SortByHeader) ->
  class SortController extends Events
    constructor: (@container, @options) ->
      @headers = _(@options.fields).map (field) =>
        new SortByHeader field

      _(@headers).map (header) =>
        @container.append header.el

      _(@headers).invoke "render"

      _(@headers).invoke "on", "sort", (field) =>
        @trigger "sort", field

      _(@headers).invoke "on", "activate", (view) =>
        _.chain(@headers)
          .without(view)
          .invoke "deactivate"

  SortController