$(document).ready(function($) {
    $('#celebrity_birthdate, #release_date_lt, #release_date_gt, #movie_poster_release_date, #movie_trailer_release_date').datepicker({ dateFormat: 'yy-mm-dd' });
    $('#page_content').htmlarea();
});

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).parent().hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

