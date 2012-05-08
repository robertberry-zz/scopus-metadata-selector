# Collection for the SciVerse Document

define [
  "jquery",
  "underscore",
  "backbone",
  "models/Document"
], ($, _, Backbone, Document) ->
  class Documents extends Backbone.Collection
    model: Document

  Documents