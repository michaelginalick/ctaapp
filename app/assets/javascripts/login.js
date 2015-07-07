$(document).ready(function(){
		//ensure only number are entered into phone number
		$('#phone-number').keypress(function(event){
			if(event.which != 8 && isNaN(String.fromCharCode(event.which)) || event.keycode == 32) {
				event.preventDefault();
			};
	});

		$('#continue').submit(function(event){
			var height = $('.lead').height();
			var width = $('.lead').width();
			if($('#phone-number').val().length < 10){
				freezePhoneDiv(event, height, width);

				$('.lead').text("Number must be ten digits.");
				restorePhoneDiv();
			} else if ($('#phone-number').val().charAt(0) === "1"){
				freezePhoneDiv(event, height, width);
				$('.lead').text("Area code and number only, please.");
				restorePhoneDiv();
			} else {
				$(this).unbind('submit');
			}

		});

		function restorePhoneDiv(){
			setTimeout(
				function() {
					$('lead').css({
						"height": '',
						"width": '',
					});
					$('.lead').text("Please enter your cell phone number below.");
				},
			3500);
		};

		function freezePhoneDiv(event, height, width) {
			event.preventDefault();
			$('.lead').css({
				"height": height,
				"width": width
			});
		};

});		

