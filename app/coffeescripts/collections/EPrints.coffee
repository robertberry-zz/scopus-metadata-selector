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
    # attributes:
    #   date, title, issn ... not sure what else yet
    model: EPrint

  # todo - maybe make an object/transformations library for these functions
  # so I don't have to do all this ugly renaming!
  renames = object.renames_attribute
  strips = object.strips_attribute
  transforms = object.transforms_attribute
  composes = object.composes_attribute
  sets = object.sets_attribute

  # Given an attribute name, a regular expression, and a list of new
  # attributes, returns a function that matches the attribute in an object
  # against the regular expression, then sets the new attributes from the
  # match groups. Phew!
  sets_from = (attribute, re, new_attributes...) ->
    (attrs) ->
      if attrs[attribute]
        matches = attrs[attribute].match re
        matches.shift() # remove whole match
        for [key, val] in _.zip(new_attributes, matches)
          attrs[key] = val
      attrs

  # Same as above, but deletes the original attribute
  extracts = (attribute, re, new_attributes...) ->
    _.compose(
      strips(attribute)
      sets_from.apply(sets_from, [attribute, re].concat(new_attributes)),
    )

  get_name_components = (name) ->
    re = ///
      ([^,]+),\s*    # surname
      ([^\s]+)\s*    # first name
      (.*)?          # optional middle name
    ///
    matches = name.match re
    return family: matches[1], given: matches[2], lineage: matches[3]

  # Function for producing an EPrints collection that automatically mirrors a
  # Scopus Documents collection. Whenever the Scopus collection changes, this
  # one will automatically update to reflect those changes.
  EPrints.mirroring_documents = (documents) ->
    prints = new EPrints()
    collection.map documents, prints, _.compose(
      renames("pubdate", "date"),
      sets("date_type", "published"),
      renames("sourcetitle", "publication"),
      renames("vol", "volume"),
      renames("inwardurl", "official_url"),
      renames("doctype", "type"),
      renames("issue", "number"),
      renames("doi", "id_number"),
      renames("abs", "abstract"),
      extracts("page", /(\d+)-(\d+)/, "pagerange_from", "pagerange_to"),
      sets("publisher", "Elsevier"),
      renames("firstauth", "creators"),
      transforms("firstauth", _.compose(((x) -> [x]), get_name_components)),
      strips("authlist"),
      strips("eid"),
      strips("scp"),
      strips("citedbycount"),  # leave this to be calculated by a dedicated
                               # plug in
      strips("affiliation"),   # always us
    )
    prints

  EPrints