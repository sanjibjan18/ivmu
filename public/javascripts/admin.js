$(document).ready(function($) {
    $('#celebrity_birthdate, #release_date_lt, #release_date_gt, #movie_media_updated_date').datepicker({ dateFormat: 'yy-mm-dd' });
    $('#page_content').htmlarea();

    $('.tweet_option_change').change(function() {
      tweet_id = $(this).attr('id').split('review_')[1]
      $.ajax({type: "POST",url: "/tweet_review_update", data: "id=" + tweet_id + "&option=" + $(this).val()});
    });

    $('.facebook_option_change').change(function() {
      facebook_id = $(this).attr('id').split('review_')[1]
      $.ajax({type: "POST",url: "/facebook_review_update", data: "id=" + facebook_id + "&option=" + $(this).val()});
    });
   $(".castName").autocomplete({ source: '/celebrityAutocomplete',
     select: function( event, ui ) {
				$(this).val(ui.item.label);
				$(this).prev().val( ui.item.value );
                return false;
			}
   });

  $('#check_all').click(function(){
	$("input[type='checkbox']").each(function(){
        	if (this.checked == false) {
			this.checked = true;
		} else {
			this.checked = false;
		}
	});
});


});

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).parent().parent().parent().hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

