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

  # Given an author name, returns the components split up as EPrints wants them
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

  # Went a little crazy with functional programming ideas here (mostly
  # composition of functions and partial application). Although the syntax for
  # specifying how EPrints is a transformation of Scopus documents below is
  # nice I'm not sure whether I've over-complicated it for what it's actually
  # trying to do. todo: consider refactoring.

  {maps, rejects} = list_transformations
  {splits} = string_transformations

  # Given a string containing a list of author names, returns the
  # EPrints-compatible JSON form
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
    # The main problem with composition is although we'd logically read it as
    # do this, then that, composition actually means you need to specify the
    # operations in reverse: so don't get confused by the below!
    collection.map documents, prints, _.compose(
      renames("pubdate", "date"),
      sets("date_type", "published"),
      sets("ispublished", "pub"),    # If it's on Elsevier assume published
            # (can we? I think Elsevier has articles in the future too)
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
      merges("firstauth", "authlist", _.union),
      transforms("firstauth", make_author_json),
      transforms("authlist", make_author_json),
      strips("eid"),       # Scopus Unique Article identifier
      strips("scp"),       # Not sure what this is? Another Scopus ID?
      strips("citedbycount"),  # calculated by dedicated plug in
      strips("affiliation"),   # always us
    )
    prints

  EPrints
