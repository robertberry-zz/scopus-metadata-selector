# Collection for EPrints documents

define [
  "jquery",
  "underscore",
  "backbone",
  "models/EPrint"
  "utils/collection",
  "utils/object/transformations",
  "utils/list/transformations",
  "utils/string/transformations"
], ($, _, Backbone, EPrint, collection, object_transformations, \
    list_transformations, string_transformations) ->
  class EPrints extends Backbone.Collection
    # attributes:
    #   date, title, issn ... not sure what else yet
    model: EPrint

  get_name_components = (name) ->
    if not name
      return null
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

  {maps, rejects} = list_transformations
  {splits} = string_transformations

  make_author_json = _.compose(
    maps(_.compose(((x) -> name: x), get_name_components)),
    rejects((x) -> x == ""), # if the author is an empty string to begin with
                             # split will return an array containing one empty
                             # string. this removes it.
    splits(/\s*;\s*/)
  )

  {renames, strips, transforms, composes, sets, maps, merges} = object_transformations

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
      merges("creators", "authlist", _.union),
      renames("firstauth", "creators"),
      transforms("firstauth", make_author_json),
      transforms("authlist", make_author_json),
      strips("eid"),       # Scopus Unique Article identifier
      strips("scp"),       # Not sure what this is? Another Scopus ID?
      strips("citedbycount"),  # leave this to be calculated by a dedicated
                               # plug in
      strips("affiliation"),   # always us
    )
    prints

  EPrints
