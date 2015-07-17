$(document).ready(function(){

	// Change train stops for each line selected
	$(function() {
        $('#select-line').change(function() {
            var id = $(this).val();
            $(".convenient").addClass("hidden");
            $("#" + id).removeClass("hidden");
    	});
	});


	$('#new-stop').submit(function(event){
		event.preventDefault();
        if (!$("#select-time").val() || $("input:checkbox:checked").length == 0) {
            $("#stop-header").text("Please enter a time and date.")
            restoreStopHeader();
        } else {

      	    ajaxCall();
	   };
    });

    // Define functions

    var ajaxCall = function() {
           $.ajax({
                url: '/user/' + getUserId() + '/train/',
                method: 'POST',
                type: 'json',
                data: {
                    time: $("#select-time").val(),
                    line: $("#select-line").val(),
                    // Workaround to dynamically match stop with line
                    stop: $("#select-stop-" + $("#select-line").val().toLowerCase()).val(),
                    days: {
                            monday: $("#monday:checked").val(),
                        
                            tuesday: $("#tuesday:checked").val(),
                                    
                            wednesday: $("#wednesday:checked").val(),
                                    
                            thursday: $("#thursday:checked").val(),
                                    
                            friday: $("#friday:checked").val(),
                                    
                            saturday: $("#saturday:checked").val(),
                                    
                            sunday: $("#sunday:checked").val()
                         },   
                },
                success: function(data) {

                    $("#stop-header").text(data);
                    
                    $('#partials-div').load('/user/' + getUserId() + '/stop');
                    
                    $("#new-stop").trigger('reset');
                    
                    // Default back to red line
                    $(".convenient").addClass("hidden"); 
                    
                    $("#Red").removeClass("hidden");
                    
                    restoreStopHeader();
                },

                error: function(data) {
                    //Prevent error dumps from rendering
                    if (data["responseText"].length > 100) {
                        
                        $("#stop-header").text("An error has occured.");
                    
                    } else {
                        
                        $("#stop-header").text(data["responseText"]);
                    }; 

                    restoreStopHeader();
                }
            });
        };
    });

    function restoreStopHeader() {

        setTimeout(

            function() {
                
                $('#stop-header').text("Add a new stop");
            },
        
        3500);
    };


      var getUserId = function(){
        var id = $("#user").val();
        return id;        
      };


	

