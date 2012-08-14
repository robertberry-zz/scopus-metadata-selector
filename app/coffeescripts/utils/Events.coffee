# Allow you to use Backbone.Events as a native CoffeeScript class

define [
  "jquery",
  "underscore",
  "backbone",
], ($, _, Backbone) ->
  class Events
  
  _.extend(Events::, Backbone.Events)

  Events
