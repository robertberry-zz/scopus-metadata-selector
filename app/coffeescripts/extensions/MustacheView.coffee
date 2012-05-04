# MustacheView extension

includes = [
  "jquery",
  "underscore",
  "backbone",
  "extensions/Context",
  "Mustache"
]

# Note: Mustache is not a fully AMD-compliant module, which is why it's not
# included in the parameter list below.

define includes, ($, _, Backbone, Context) ->
  # View extension that renders using a Mustache template, which should be
  # specified in the view's 'template' property. Passes the model directly to
  # the view. If the view wraps a collection, passes the collection's models
  # list under a 'collection' parameter in an otherwise empty hash. Do *not*
  # use this for collections, though - see CollectionView.
  class MustacheView extends Backbone.View
    render: ->
      if @model
        context = new Context(@, @model)
      else if @collection
        context = {collection: new Context(@, model) for model in @collection.models}
      else
        context = {}
      @$el.html Mustache.render(@template, context)

  MustacheView