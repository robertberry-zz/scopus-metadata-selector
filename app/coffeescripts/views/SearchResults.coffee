# A view that renders search results

define [
  "extensions/CollectionView",
  "views/SearchResult"
], (CollectionView, SearchResult) ->
  class SearchResults extends CollectionView
    item_view: SearchResult

    tagName: "div"

    attributes:
      class: "search_results"

  SearchResults