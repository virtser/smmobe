// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require_tree .

$(document).ready( function(){	
	// in edit mode, select the right campaign type
	if (typeof campaign_type_id != "undefined")
		selectType();

	// campaign type selection on click event trigger
    $('.types .row').on('click','.enabled', selectType);

	function selectType() {
    	 // apply selected class on selected type
         $('.enabled').removeClass('selected');

         if (event.type == 'click') 
         	$(this).addClass('selected')	
         else 
     	   	$('.types .row #' + campaign_type_id).addClass('selected')

         // get the campaing type id
         campaign_type_id = $('.selected').attr('id');
         console.log('campaign_type_id: ' + campaign_type_id);
         $('#campaign_campaign_type_id').val(campaign_type_id);
    }
});
