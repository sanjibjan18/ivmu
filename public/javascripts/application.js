 $(document).ready(function($) {
    $('a[rel*=facebox]').facebox();
    $("#reviews").tabs();
    $("#q").autocomplete({source: '/autocomplete', minLength: 3});
    $("#pagination .muvi_pagination a").live("click", function() {
       $.getScript(this.href); return false;
     });

    $("#coming_soon_sort").live("change", function() {
       $.get('/coming_soon_movies', 'sort='+ $('#coming_soon_sort').val(), null, "script");
       return false;
     });

    /*$("#register").fancybox();
    $("#login").fancybox(); */


});

function critics_reviews_sort(movie_id, value) {
  var url = '/critics_reviews?id=' + movie_id + '&sort=' + value ;
  $.getScript(url); return false;
}


function go_to_tab(index){
  $("#reviews").tabs("select", index );
  window.location.hash = '#reviews';

}



function popupCenter(url, width, height, name) {
  var left = (screen.width/2)-(width/2);
  var top = (screen.height/2)-(height/2);
  return window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);
}

$(document).ready(function($) {
  $("a.popup").click(function(e) {
    alert('hi');
    popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
    e.stopPropagation(); return false;
  });
});
