# Collection for EPrints documents

define [
  "jquery",
  "underscore",
  "backbone",
  "models/EPrint"
  "utils/collection",
  "utils/object"
], ($, _, Backbone, EPrint, collection, object) ->
  class EPrints extends Backbone.Collection
    model: EPrint

  renames = object.renames_attribute
  strips = object.strips_attribute

  # Function for producing an EPrints collection that automatically mirrors a
  # Scopus Documents collection. Whenever the Scopus collection changes, this
  # one will automatically update to reflect those changes.
  EPrints.mirroring_documents = (documents) ->
    prints = new EPrints()
    collection.map documents, prints, _.compose(
      renames("pubdate", "date"),
      strips("doi"),
      strips("citedbycount")
    )
    prints

  EPrints