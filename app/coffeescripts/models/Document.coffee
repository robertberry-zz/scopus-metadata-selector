# Document model, represents a SciVerse document.

define ["jquery", "underscore", "backbone"], ($, _, Backbone) ->
  class Document extends Backbone.Model
    # parameters:
    #   abs, affiliation, authlist, citedbycount, doctype, doi, eid,
    #   firstauth, inwardurl, issn, issue, page, pubdate, scp,
    #   sourcetitle, title, vol

  Document