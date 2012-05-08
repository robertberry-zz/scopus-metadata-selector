# CollectionView extension

define [
  "jquery",
  "underscore",
  "backbone"
], ($, _, Backbone) ->
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
      collection.bind "add", _.bind(@render, @)
      collection.bind "remove", _.bind(@render, @)
      collection.bind "change", _.bind(@render, @)
      collection.bind "reset", _.bind(@render, @)
      @items = []

    # Re-renders the view and its subviews. Note: this is slow, rewrite to
    # only remove the views that have actually been removed, instead of
    # re-rendering all.
    render: ->
      _(@items).invoke "off"
      _(@items).invoke "remove"
      @$el.html ""
      @items = @collection.map (model) =>
        new @item_view model: model
      @start_event_forwarding()
      @trigger "refresh", @items
      for view in @items
        view.render()
        @$el.append view.el

    # Allows you to specify in sub views a 'forward_events' parameter. Then
    # when the sub view fires an event whose name is in the forward_events
    # list, the event is also fired by the CollectionView.
    start_event_forwarding: ->
      _(@items).each (item) =>
        if item.forward_events
          for event_name in item.forward_events
            do (event_name) =>
              item.on event_name, =>
                # convert arguments object into real array
                args = [].slice.call arguments
                args.unshift event_name
                @trigger.apply @, args

  CollectionView