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
  "views/JSONField",
  "routers/SearchRouter",
  "text!templates/spinner.html"
]

FORM_SELECTOR = "#sciverse_search_form"
SEARCH_INPUT_SELECTOR = "input[name=sciverse_search_string]"
SUBMIT_BUTTON_SELECTOR = "input[type=submit]"
RESULTS_SELECTOR = "#sciverse"
IMPORT_SELECTOR = "#sciverse_submit_form input[type=submit]"

require includes, ($, api_key, Renderer, Documents, SearchResults, \
    JSONField, SearchRouter, spinner) ->
  sciverse.setApiKey api_key

  form = $(FORM_SELECTOR)
  query = $(SEARCH_INPUT_SELECTOR)
  submit = $(SUBMIT_BUTTON_SELECTOR)
  import_button = $(IMPORT_SELECTOR)
  results_container = $(RESULTS_SELECTOR)

  app = new SearchRouter()

  documents = new Documents()
  selected = new Documents()
  results = new SearchResults(collection: documents)
  selected_field = new JSONField(collection: selected)
  selected_field.render()
  import_button.before selected_field.el

  app.on "search:start", (search_string) ->
    query.val search_string
    submit.attr "disabled", yes
    selected.reset()
    results_container.html spinner
  app.on "search:end", ->
    submit.attr "disabled", no
    results_container.html results.el

  results.on "select", (document) ->
    selected.add document
  results.on "deselect", (document) ->
    selected.remove document

  renderer = new Renderer(documents)
  sciverse.setRenderer renderer

  form.submit (event) ->
    event.preventDefault()
    app.navigate("search/" + query.val(), trigger: yes)

  Backbone.history.start pushState: no

