# A view that renders errors

define [
  "extensions/CollectionView",
  "views/ErrorMessage"
], (CollectionView, ErrorMessage) ->
  class ErrorMessages extends CollectionView
    item_view: ErrorMessage

    tagName: "ul"

    attributes:
      class: "scopus_errors"

  ErrorMessages