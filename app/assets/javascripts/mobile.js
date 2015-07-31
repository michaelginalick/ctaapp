$(function() {

    perfectFit();

    $(window).resize(function() {
           
            perfectFit();
    });

    function perfectFit() {

        if ($(window).width() < 500) {

            $("a.navbar-brand").replaceWith("<a class='navbar-brand' href='/''><i>TTT</i></a>");
            $('#back').css('margin-right', "0em");
            $("#phone-number,#pin").css("font-size", "1.0em");
            $("th,td,#delete-train").css("font-size", ".5em");
            $("#acknowledge").css("margin-left", "0");

        } else {

            $("a.navbar-brand").replaceWith("<a class='navbar-brand' href='/''><i>TTT</i></a>");
            $('#back').css('margin-right', ".8em");
            $("#phone-number,#pin").css("font-size", "1.5em");
            $("th,td,#delete-train").css("font-size", "1em");
            $("#acknowledge").css("margin-left", ".5em");

        };

        $(".align").css('height', ($(document).height()).toString() + "px");
        $(".holder").css('height', ($(document).height()).toString() + "px");
    };
});