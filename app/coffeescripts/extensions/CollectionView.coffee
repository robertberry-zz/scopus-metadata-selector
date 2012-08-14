# CollectionView extension

define [
  "jquery",
  "underscore",
  "backbone",
  "utils/Set"
], ($, _, Backbone, Set) ->
  # For working with a view that represents a list of subviews based on a
  # collection. Specify the sub view class in the 'item_view' class property.
  # When the collection changes, the view will automatically re-render the
  # appropriate sub views. Fires 'refresh' event when sub views change, with a
  # list of the changed sub views.
  class CollectionView extends Backbone.View
    initialize: ->
      collection = @options["collection"]
      if not collection
        # todo: provide exception class
        throw "Must be instantiated with collection."
      collection.bind "add", _.bind(@_add, @)
      collection.bind "remove", _.bind(@_remove, @)
      collection.bind "change", _.bind(@_change, @)
      collection.bind "reset", _.bind(@_reset, @)
      @items = []

    render: ->
      @trigger "refresh", @items
      @_render_sub_views(@items)

    # Repopulate with sub views for the given set of models. Should only be
    # invoked by the collection's event handler.
    _reset: (models) ->
      @_remove_sub_views(@items)

    # Remove the given sub views
    _remove_sub_views: (sub_views) ->
      _(sub_views).invoke "off"
      _(sub_views).invoke "remove"
      @items = _(@items).without sub_views

    # For the given set of models, remove the sub views from the
    # collection. This should only ever be invoked by the event handler for
    # the collection.
    _remove: (models) ->
      @_remove_sub_views @_sub_views_for_models(models)

    # For the given set of models, add sub views. This should only ever be
    # invoked by the event handler for the collection.
    _add: (model) ->
      sub_view = new @item_view model: model
      @_append_sub_view(sub_view)
      @_add_event_forwarding(sub_view)
      @_render_sub_views([sub_view])

    _change: (model) ->
      @_render_sub_views @_sub_views_for_models(models)

    _append_sub_view: (sub_view) ->
      # Need to rewrite this if we are specifying ordering
      @items.push(sub_view)
      @$el.append sub_view.el
      
    _render_sub_views: (sub_views) ->
      for view in sub_views
        view.render()

    # Returns the sub views in the collection view for the given set of
    # models. Note: if the model is not being shown in the collection view,
    # it will not return a corresponding view.
    _sub_views_for_models: (models) ->
      cids = new Set(model.cid for model in models)
      _(@items).filter (sub_view) ->
        sub_view.model.cid in cids

    # Allows you to specify in sub views a 'forward_events' parameter. Then
    # when the sub view fires an event whose name is in the forward_events
    # list, the event is also fired by the CollectionView.
    _add_event_forwarding: (item) ->
      if item.forward_events
        for event_name in item.forward_events
          do (event_name) =>
            item.on event_name, =>
              # convert arguments object into real array
              args = [].slice.call arguments
              args.unshift event_name
              @trigger.apply @, args

  CollectionView