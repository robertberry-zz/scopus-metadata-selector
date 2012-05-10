(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(["jquery", "underscore", "backbone"], function($, _, Backbone) {
    var Events, exports;
    exports = {};
    Events = (function() {

      Events.name = 'Events';

      function Events() {}

      return Events;

    })();
    _.extend(Events.prototype, Backbone.Events);
    exports.API = (function() {

      API.name = 'API';

      function API(api_key) {
        this.api_key = api_key;
        sciverse.setApiKey(this.api_key);
      }

      return API;

    })();
    exports.Search = (function(_super) {

      __extends(Search, _super);

      Search.name = 'Search';

      Search.prototype.per_page = 15;

      Search.prototype.sort = "Relevancy";

      Search.prototype.order = "Descending";

      function Search(api, options) {
        this.api = api;
        this.options = options;
        this.cache = {};
        this.query = this.options["query"];
        if (!this.query) {
          throw "You must provide a search query.";
        }
        if (this.options["per_page"]) {
          this.per_page = this.options["per_page"];
        }
        if (this.options["sort"]) {
          this.sort = this.options["sort"];
        }
        if (this.options["order"]) {
          this.order = this.options["order"];
        }
      }

      Search.prototype.fetch_page = function(n) {
        var _this = this;
        if (__indexOf.call(this.cache, n) >= 0) {
          return this._results(this.cache[n]);
        } else {
          this.searchObj = new searchObj;
          this.searchObj.setNumResults(this.per_page);
          this.searchObj.setSearch(this.query);
          this.searchObj.setSort(this.sort);
          this.searchObj.setSortDirection(this.order);
          sciverse.setErrorCallback(function(errors) {
            return _this._errors(errors);
          });
          sciverse.setCallback(function() {
            var results;
            if (sciverse.areSearchResultsValid()) {
              _this.total_results = sciverse.getTotalHits();
              results = sciverse.getSearchResults();
              results["page"] = n;
              return _this._results(results);
            }
          });
          return sciverse.runSearch(this.searchObj);
        }
      };

      Search.prototype._results = function(results) {
        var page;
        page = results["page"];
        this.cache[page] = results;
        return this.trigger("results", results);
      };

      Search.prototype._errors = function(errors) {
        return this.trigger("errors", errors);
      };

      return Search;

    })(Events);
    return exports;
  });

}).call(this);
