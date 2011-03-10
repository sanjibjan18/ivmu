 $(document).ready(function($) {
    $('a[rel*=facebox]').facebox();
    $( "#tabs" ).tabs();
    $("#critics_reviews .pagination a").live("click", function() {
       $.getScript(this.href); return false;
     });
});

function critics_reviews_sort(movie_id, value) {
  var url = '/critics_reviews?id=' + movie_id + '&sort=' + value ;
  $.getScript(url); return false;
}

