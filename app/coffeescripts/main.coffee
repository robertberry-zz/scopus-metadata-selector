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
  "routers/SearchRouter",
  "text!templates/spinner.html"
]

FORM_SELECTOR = "#sciverse_search_form"
SEARCH_INPUT_SELECTOR = "input[name=sciverse_search_string]"
SUBMIT_BUTTON_SELECTOR = "input[type=submit]"
RESULTS_SELECTOR = "#sciverse"

require includes, ($, api_key, Renderer, Documents, SearchResults, \
    SearchRouter, spinner) ->
  sciverse.setApiKey api_key

  form = $(FORM_SELECTOR)
  query = form.children(SEARCH_INPUT_SELECTOR)
  submit = form.children(SUBMIT_BUTTON_SELECTOR)
  results_container = $(RESULTS_SELECTOR)

  app = new SearchRouter()
  app.on "search:start", (search_string) ->
    query.val search_string
    submit.attr "disabled", yes
    results_container.html spinner
  app.on "search:end", ->
    submit.attr "disabled", no
    results_container.html results.el

  documents = new Documents()
  results = new SearchResults(collection: documents)

  renderer = new Renderer(documents)
  sciverse.setRenderer renderer

  form.submit (event) ->
    event.preventDefault()
    app.navigate("search/" + query.val(), trigger: yes)

  Backbone.history.start pushState: no

