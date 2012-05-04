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
  "views/SearchResults",
  "routers/SearchRouter"
]

FORM_SELECTOR = "#sciverse_search_form"
SEARCH_INPUT_SELECTOR = "input[name=sciverse_search_string]"
SUBMIT_BUTTON_SELECTOR = "input[type=submit]"

require includes, ($, api_key, Renderer, Documents, SearchResults, \
    SearchRouter) ->
  sciverse.setApiKey api_key

  form = $(FORM_SELECTOR)
  query = form.children(SEARCH_INPUT_SELECTOR)
  submit = form.children(SUBMIT_BUTTON_SELECTOR)

  app = new SearchRouter()
  app.on "search:start", (search_string) ->
    query.val search_string
    submit.attr "disabled", yes
  app.on "search:end", ->
    submit.attr "disabled", no

  documents = new Documents()
  results = new SearchResults(collection: documents)
  $('#sciverse').html results.el

  renderer = new Renderer(documents)
  sciverse.setRenderer renderer

  form.submit (event) ->
    event.preventDefault()
    app.navigate("search/" + query.val(), trigger: yes)

  Backbone.history.start pushState: no

