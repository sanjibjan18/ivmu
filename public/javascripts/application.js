 $(document).ready(function($) {


    $("#reviews").tabs({ spinner: '<img src="/images/spinner.gif"/>' });
    $("#q").autocomplete({source: '/autocomplete', minLength: 3});
    $("#pagination .muvi_pagination a").live("click", function() {
       $.getScript(this.href); return false;
     });

    $("#coming_soon_sort").live("change", function() {
       $.get('/coming_soon_movies', 'sort='+ $('#coming_soon_sort').val(), null, "script");
       return false;
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



function popupCenter(url, width, height, name) {
  var left = (screen.width/2)-(width/2);
  var top = (screen.height/2)-(height/2);
  return window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);
}


function registration() {
  //$('#registration').html('<div class="spinner"><img src="/images/spinner-black.gif"/></div>');
  $('#registration').dialog({ modal: true,  width: 600, height: 350, title: 'Muvi.in registration' });
  return false;
}



function login() {
  //$('#registration').html('<div class="spinner"><img src="/images/spinner-black.gif"/></div>');
  $('#registration').dialog({  modal: true,  width: 500, height: 300, title: 'Muvi.in signin'});
  return false;
}


$(document).ready(function($) {
  $("a.popup").click(function(e) {
    popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
    e.stopPropagation(); return false;
  });
});


$(document).ready(function(){

   $('.trailerLink').click(function(event){
        event.preventDefault();
       $('#trailer').dialog( {
                modal: true,
                height: 355,
                width: 550
                });
        return false;
    });

 });

