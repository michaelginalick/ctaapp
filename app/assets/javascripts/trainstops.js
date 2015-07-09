$(document).ready(function(){

		// Change train stops for each line selected
		$(function() {
    $('#select-line').change(function() {

        var id = $(this).val();

        $(".convenient").addClass("hidden");

        $("#" + id).removeClass("hidden");
    	});
		});

});		

