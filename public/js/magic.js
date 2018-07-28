$(document).ready(function(){
    $('form').submit(function(event) {
        console.log('form submitted');
        
        var $form = $(this);

        var serializedData = $form.serialize();

        $.ajax({
            type: "post",
            url: "m2-search.dhtml",
            data: serializedData
        })

        .done(function(data) {
            //console.log(data);


            $('#search-results').html(data);
        })

        .fail(function(data) {
            console.log('failed');
            console.log(data);
            
            $('#search-results').html('<p>Search Failed</p>');
        });

        event.preventDefault();
    });

});
