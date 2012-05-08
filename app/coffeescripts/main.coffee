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
  "text!templates/spinner.html"
], ($, config, Renderer, Documents, SearchResults, \
    JSONField, CountSubmit, SearchRouter, spinner) ->
  sciverse.setApiKey config.api_key

  selectors = config.selectors

  form = $(selectors.search_form)
  query = $(selectors.search_input)
  submit = $(selectors.search_submit)
  import_form = $(selectors.import_form)
  results_container = $(selectors.results_container)

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
  # hide import submit till results
  import_button.$el.hide()
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
    import_button.$el.show()

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
