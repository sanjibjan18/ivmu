 $(document).ready(function($) {
    $('a[rel*=facebox]').facebox();
    $( "#reviews" ).tabs();
    $("#search_name_contains").autocomplete({source: '/autocomplete', minLength: 2});
    $("#pagination .muvi_pagination a").live("click", function() {
       $.getScript(this.href); return false;
     });
});

function critics_reviews_sort(movie_id, value) {
  var url = '/critics_reviews?id=' + movie_id + '&sort=' + value ;
  $.getScript(url); return false;
}


function go_to_tab(index){
  $("#reviews").tabs("select", index );
  window.location.hash = '#reviews';

}

