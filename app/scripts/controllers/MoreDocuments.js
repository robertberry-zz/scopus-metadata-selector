(function() {

  define(function() {
    var MoreDocuments;
    MoreDocuments = (function() {

      MoreDocuments.name = 'MoreDocuments';

      function MoreDocuments() {}

      MoreDocuments.prototype.initialize = function(collection, search, page) {
        this.collection = collection;
        this.search = search;
        this.page = page != null ? page : 1;
      };

      MoreDocuments.prototype.next = function() {};

      return MoreDocuments;

    })();
    return MoreDocuments;
  });

}).call(this);
