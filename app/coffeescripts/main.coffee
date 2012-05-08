# Main script

require.config
  paths:
    jquery: "libs/jquery/jquery-min"
    underscore: "libs/underscore/underscore-min"
    backbone: "libs/backbone/backbone-min"
    text: "libs/require/text"
    Mustache: "libs/mustache/mustache"
    templates: "../templates"

FORM_SELECTOR = "#sciverse_search_form"
SEARCH_INPUT_SELECTOR = "input[name=sciverse_search_string]"
SUBMIT_BUTTON_SELECTOR = "input[type=submit]"
RESULTS_SELECTOR = "#sciverse"
IMPORT_FORM = "#sciverse_submit_form"

require [
  "jquery",
  "config"
  "Renderer",
  "collections/Documents",
  "views/SearchResults",
  "views/JSONField",
  "views/CountSubmit",
  "routers/SearchRouter",
  "text!templates/spinner.html"
], ($, config, Renderer, Documents, SearchResults, \
    JSONField, CountSubmit, SearchRouter, spinner) ->
  sciverse.setApiKey config.api_key

  form = $(FORM_SELECTOR)
  query = $(SEARCH_INPUT_SELECTOR)
  submit = $(SUBMIT_BUTTON_SELECTOR)
  import_form = $(IMPORT_FORM)
  results_container = $(RESULTS_SELECTOR)

  app = new SearchRouter()

  documents = new Documents()
  selected = new Documents()
  results = new SearchResults(collection: documents)
  selected_field = new JSONField(collection: selected)
  selected_field.render()
  import_button = new CountSubmit
    collection: selected
    template: "Import (<%= count %>)"
    disable_on_zero: yes
  import_form.append selected_field.el
  import_form.append import_button.el

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

