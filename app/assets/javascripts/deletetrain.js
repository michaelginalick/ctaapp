// Delete account and confirmation
    $("#delete-account-form").submit(function(event) {

        if ($("#delete-account").val() == "Are you sure?") {

            return true;

        } else {

            $("#delete-account").val("Are you sure?");

            return false;
        };
    });

    // Cancel if user clicks outside delete button
    $(document).click(function(event) {

        if (!$(event.target).is('#delete-account')) {

            $("#delete-account").val("Delete account");
        };
    });

    // Delete a stop (use document scope b/c of AJAX call)
    $(document).on("click", ".pure-button.delete.unique", function(event) {

        event.preventDefault();
        
        var id = $("#user").val();
        console.log(id);

        $.ajax({

            url: $(".delete-stop").attr("action"),

            method: 'POST',

            dataType: 'text',

            success: function(data) {

                $('#partials-div').load('/users/' + id + '/stops');
            },

            error: function(data) {

                $("#stop-table-header").text("An error occurred.");

                setTimeout(
                    function() {
                        $('#stop-table-header').text("Your stops");
                    }, 3500);
            }
        });
    });
