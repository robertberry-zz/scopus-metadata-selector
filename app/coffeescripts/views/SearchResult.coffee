
includes = [
  "extensions/MustacheView",
  "text!templates/search_result.html"
]

define includes, (MustacheView, template) ->
  class SearchResult extends MustacheView
    tagName: "div"

    attributes:
      class: "search_result"

    template: template

  SearchResult