(function() {

  define(function() {
    var StaggeredSearch;
    StaggeredSearch = (function() {

      StaggeredSearch.name = 'StaggeredSearch';

      function StaggeredSearch(collection, search, page) {
        var _this = this;
        this.collection = collection;
        this.search = search;
        this.page = page != null ? page : 0;
        this.search.on("results", function(data) {
          return _this.collection.add(data["results"]);
        });
        this.search.on("errors", function(errors) {
          return _this.collection.reset();
        });
      }

      StaggeredSearch.prototype.next = function() {
        this.search.fetch_page(this.page);
        return this.page += 1;
      };

      StaggeredSearch.prototype.how_many_more = function() {
        return this.search.total_results - (this.search.per_page * this.page + 1);
      };

      return StaggeredSearch;

    })();
    return StaggeredSearch;
  });

}).call(this);
