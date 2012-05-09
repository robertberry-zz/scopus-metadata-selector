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

  # todo - maybe make an object/transformations library for these functions
  # so I don't have to do all this ugly renaming!
  renames = object.renames_attribute
  strips = object.strips_attribute
  transforms = object.transforms_attribute
  composes = object.composes_attribute

  # Function for producing an EPrints collection that automatically mirrors a
  # Scopus Documents collection. Whenever the Scopus collection changes, this
  # one will automatically update to reflect those changes.
  EPrints.mirroring_documents = (documents) ->
    prints = new EPrints()
    collection.map documents, prints, _.compose(
      renames("pubdate", "date"),
      strips("firstauth"),
      strips("sourcetitle"),
      strips("page"),
      strips("eid"),
      strips("issue"),
      strips("doctype"),
      strips("inwardurl"),
      strips("scp"),
      strips("doi"),
      strips("citedbycount"),
      strips("vol"),
      strips("abs"),
      strips("affiliation"),
      strips("authlist")
    )
    prints

  EPrints