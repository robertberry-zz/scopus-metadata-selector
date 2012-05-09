# Main script

require.config
  paths:
    jquery: "libs/jquery/jquery-min"
    underscore: "libs/underscore/underscore-min"
    backbone: "libs/backbone/backbone-min"
    text: "libs/require/text"
    Mustache: "libs/mustache/mustache"
    templates: "../templates"

require [
  "jquery",
  "config"
  "Renderer",
  "collections/Documents",
  "views/SearchResults",
  "views/JSONField",
  "views/CountSubmit",
  "routers/SearchRouter",
  "text!templates/spinner.html",
], ($, config, Renderer, Documents, SearchResults, JSONField, CountSubmit, \
    SearchRouter, spinner, collection, object) ->
  sciverse.setApiKey config.api_key

  selectors = config.selectors

  search_form = $(selectors.search_form)
  search_input = $(selectors.search_input)
  search_submit = $(selectors.search_submit)
  import_form = $(selectors.import_form)
  results_container = $(selectors.results_container)

  app = new SearchRouter()

  search_results = new Documents()
  selected_results = new Documents()
  results = new SearchResults(collection: search_results)

  import_input = new JSONField(collection: selected_results)
  import_input.$el.attr "name", config.parameter_name
  import_input.render()
  import_button = new CountSubmit
    collection: selected_results
    template: "Import (<%= count %>)"
    disable_on_zero: yes
  # hide import submit till results
  import_button.$el.hide()
  import_form.append import_input.el
  import_form.append import_button.el

  app.on "search:start", (search_string) ->
    search_input.val search_string
    search_submit.attr "disabled", yes
    selected_results.reset()
    results_container.html spinner
    import_button.$el.hide()
  app.on "search:end", ->
    search_submit.attr "disabled", no
    results_container.html results.el
    import_button.$el.show()

  results.on "select", (document) ->
    selected_results.add document
  results.on "deselect", (document) ->
    selected_results.remove document

  renderer = new Renderer(search_results)
  sciverse.setRenderer renderer

  search_form.submit (event) ->
    event.preventDefault()
    app.navigate("search/" + search_input.val(), trigger: yes)

  Backbone.history.start pushState: no
