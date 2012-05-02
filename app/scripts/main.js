(function() {
  var includes;

  require.config({
    paths: {
      jquery: "libs/jquery/jquery-min",
      underscore: "libs/underscore/underscore-min",
      backbone: "libs/backbone/backbone-min",
      text: "libs/require/text"
    }
  });

  includes = ["jquery", "text!../api_key"];

  require(includes, function($, api_key) {
    var form, on_complete, on_submit, query, run_search, submit;
    form = $("#sciverse_search_form");
    query = form.children("input[name=sciverse_search_string]");
    submit = form.children("input[type=submit]");
    on_complete = function() {
      return submit.attr("disabled", false);
    };
    run_search = function() {
      var search;
      submit.attr("disabled", true);
      search = new searchObj;
      search.setSearch(query.val());
      return sciverse.search(search);
    };
    on_submit = function(event) {
      event.preventDefault();
      return run_search();
    };
    form.submit(on_submit);
    sciverse.setApiKey(api_key);
    return sciverse.setCallback(on_complete);
  });

}).call(this);
