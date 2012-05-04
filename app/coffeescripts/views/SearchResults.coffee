# A view that renders search results

includes = [
  "extensions/CollectionView",
  "views/SearchResult"
]

define includes, (CollectionView, SearchResult) ->
  class SearchResults extends CollectionView
    item_view: SearchResult

    tagName: "div"

    attributes:
      class: "search_results"

  SearchResults