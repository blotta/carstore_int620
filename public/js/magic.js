$(document).ready(function(){

    $("#postal-live").on("input", function() {
        var postal = $( this ).val();
        var re = /^[a-zA-Z][0-9][a-zA-Z]\s?[0-9][a-zA-Z][0-9]$/;
        if (re.test(postal)) {
            console.log('ok');
            postal = postal.replace(/ /, '').toLowerCase();
            console.log(postal);

            $.get("/store_int620/api/getpostalinfo.dhtml",
                { postal: postal}
            ).done(function (data) {
                console.log(data.req_status); 
                if (data.api_status == 'OK'){
                    $("#city-state-country").html(
                        data.city + ', ' + data.state + ' ' + data.country);

                    $("#city-state-country").append(
                        '<input type="hidden" name="city" value="' + data.city + '">');
                    $("#city-state-country").append(
                        '<input type="hidden" name="state" value="' + data.state + '">');
                } else {
                    $("#city-state-country").html('No city found under postal code');
                }
            });
        } else {
            console.log('not ok');
            $("#city-state-country").html('');
        }
    });
});
