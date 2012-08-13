# Staggers searching for documents, allows you to load more pages, updating a
# collection automatically.

define ->
  class StaggeredSearch
    constructor: (@collection, @search, @page=0) ->
      @search.on "results", (data) =>
        @collection.add data["results"]
      @search.on "errors", (errors) =>
        @collection.reset()

    # Loads the next page of results
    next: ->
      @search.fetch_page @page
      @page += 1

    # Returns how many more results are left to load
    how_many_more: ->
      @search.total_results - (@search.per_page * @page + 1)

  StaggeredSearch