(function(window){

  PNotify.prototype.options.styling = "bootstrap3";
  $.fx.speeds._default = 120;

  $(".refresh-link").click(function(){
    var id = $(this).parents('*[data-domtype="component"]').attr("id");
    DataListener.execDataFunction(id);
  })

  var page = document.location.pathname;

  if (page === "/") {
    document.location = "_modules/dashboard/dashboard.html"
  }
})(window)
