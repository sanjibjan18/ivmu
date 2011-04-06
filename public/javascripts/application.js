 $(document).ready(function($) {
    $('a[rel*=facebox]').facebox();
    $("#reviews" ).tabs();
    $("#q").autocomplete({source: '/autocomplete', minLength: 3});
    $("#pagination .muvi_pagination a").live("click", function() {
       $.getScript(this.href); return false;
     });
    $("a[rel=registration-system]").fancybox();

});

function critics_reviews_sort(movie_id, value) {
  var url = '/critics_reviews?id=' + movie_id + '&sort=' + value ;
  $.getScript(url); return false;
}


function go_to_tab(index){
  $("#reviews").tabs("select", index );
  window.location.hash = '#reviews';

}

