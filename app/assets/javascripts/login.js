$(function(){
	$('#phone-number').keypress(function(event){
		if(event.which != 8 && isNaN(String.fromCharCode(event.which)) || event.keycode == 32) {
			event.preventDefault();
	};
});