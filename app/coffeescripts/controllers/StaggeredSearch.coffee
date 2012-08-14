# Staggers searching for documents, allows you to load more pages, updating a
# collection automatically.

define [
  "utils/Events"
], (Events) ->
  class StaggeredSearch extends Events
    constructor: (@collection, @search, @page=0) ->
      @search.on "results", (data) =>
        @collection.add data["results"]
        @trigger "page_loaded", data
      @search.on "errors", (errors) =>
        @collection.reset()
        @trigger "page_errors", errors

    # Loads the next page of results
    next: ->
      @trigger "load_page", @page
      @search.fetch_page @page
      @page += 1

    # Returns how many more results are left to load
    how_many_more: ->
      parseInt(@search.total_results) - (@search.per_page * @page + 1)

  StaggeredSearch