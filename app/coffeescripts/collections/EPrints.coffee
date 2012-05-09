# Collection for EPrints documents

define [
  "jquery",
  "underscore",
  "backbone",
  "models/EPrint"
  "utils/collection",
  "utils/object/transformations",
], ($, _, Backbone, EPrint, collection, transformations) ->
  class EPrints extends Backbone.Collection
    # attributes:
    #   date, title, issn ... not sure what else yet
    model: EPrint

  {renames, strips, transforms, composes, sets, maps} = transformations

  get_name_components = (name) ->
    re = ///
      ([^,]+),\s*    # surname
      ([^\s]+)\s*    # first name
      (.*)?          # optional middle name
    ///
    matches = name.match re
    if matches
      return family: matches[1], given: matches[2], lineage: matches[3]
    else
      return family: name

  list_authors = _.compose(((x) -> [name: x]), get_name_components)

  # Function for producing an EPrints collection that automatically mirrors a
  # Scopus Documents collection. Whenever the Scopus collection changes, this
  # one will automatically update to reflect those changes.
  EPrints.mirroring_documents = (documents) ->
    prints = new EPrints()
    collection.map documents, prints, _.compose(
      renames("pubdate", "date"),
      sets("date_type", "published"),
      sets("ispublished", "pub"),    # If it's on Elsevier assume published
      sets("refereed", "TRUE"),      # assume refereed too???
      renames("sourcetitle", "publication"),  # should be book_title in books ...
      renames("vol", "volume"),
      renames("inwardurl", "official_url"),
      maps("type", Journal: "article", Book: "book"),
      renames("doctype", "type"),
      renames("issue", "number"),
      renames("doi", "id_number"),
      renames("abs", "abstract"),
      renames("page", "pagerange"),
      sets("publisher", "Elsevier"),
      renames("firstauth", "creators"),
      transforms("firstauth", list_authors),
      strips("authlist"),   # could we concat this to firstauth?
      strips("eid"),       # Scopus Unique Article identifier
      strips("scp"),       # Not sure what this is? Another Scopus ID?
      strips("citedbycount"),  # leave this to be calculated by a dedicated
                               # plug in
      strips("affiliation"),   # always us
    )
    prints

  EPrints
