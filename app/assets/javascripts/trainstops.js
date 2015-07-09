$(document).ready(function(){

		$(function() {

    // Change train stops for each line selected
    $('#select-line').change(function() {

        var id = $(this).val();

        $(".convenient").addClass("hidden");

        $("#" + id).removeClass("hidden");
    });

});

