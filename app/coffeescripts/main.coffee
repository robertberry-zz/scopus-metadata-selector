# Main script

require.config
  paths:
    jquery: "libs/jquery/jquery-min"
    underscore: "libs/underscore/underscore-min"
    backbone: "libs/backbone/backbone-min"
    text: "libs/require/text"
    Mustache: "libs/mustache/mustache"
    templates: "../templates"

includes = [
  "jquery",
  "text!../api_key",
  "Renderer",
  "collections/Documents",
  "views/SearchResults"
]

require includes, ($, api_key, Renderer, Documents, SearchResults) ->
  documents = new Documents()
  results = new SearchResults(collection: documents)
  window.docs = documents
  $('#sciverse').html results.el

  renderer = new Renderer(docs)
  sciverse.setRenderer renderer

  form = $("#sciverse_search_form")
  query = form.children("input[name=sciverse_search_string]")
  submit = form.children("input[type=submit]")

  on_complete = ->
    submit.attr "disabled", no

  window.renderResults = (response) ->
    console.debug response

  run_search = ->
    submit.attr "disabled", yes
    search = new searchObj
    search.setSearch query.val()
    sciverse.search search

  on_submit = (event) ->
    event.preventDefault()
    run_search()

  form.submit(on_submit)

  sciverse.setApiKey api_key
  sciverse.setCallback on_complete
