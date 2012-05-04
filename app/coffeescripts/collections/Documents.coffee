# Collection for the SciVerse Document

includes = [
  "jquery",
  "underscore",
  "backbone",
  "models/Document"
]

define includes, ($, _, Backbone, Document) ->
  class Documents extends Backbone.Collection
    model: Document

  Documents