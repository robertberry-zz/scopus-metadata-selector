(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(["jquery", "underscore", "backbone"], function($, _, Backbone) {
    var exports;
    exports = {};
    exports.API = (function(_super) {

      __extends(API, _super);

      API.name = 'API';

      function API(api_key) {
        this.api_key = api_key;
        sciverse.setApiKey(config.api_key);
      }

      return API;

    })(EventsRenderer);
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
        this.api.on("results", _.bind(this, this.on_results));
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
            if (sciverse.areSearchResultsValid()) {
              _this.total_results = sciverse.getTotalHits();
              return _this._results({
                data: sciverse.getSearchResults(),
                page: n,
                offset: sciverse.getPosition(),
                length: sciverse.getNumResults()
              });
            }
          });
          return sciverse.runSearch(search);
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

    })(Backbone.Events);
    return exports;
  });

}).call(this);
