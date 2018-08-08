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
                    $("#city-prov-field").html(
                        '<div id="city-state-country" class="form-control">' +
                        data.city + ', ' + data.state + ' ' + data.country +
                        '</div>');

                    $("#city-state-country").append(
                        '<input type="hidden" name="city" value="' + data.city + '">');
                    $("#city-state-country").append(
                        '<input type="hidden" name="state" value="' + data.state + '">');
                } else if (data.api_status == 'OVER_QUERY_LIMIT') {
                    $("#city-prov-field").html(
                        '<div class="form-inline">'+
                            '<input type="text" name="city" placeholder="City" class="form-control">'+
                            '<select name="state" class="form-control">'+
                                '<option value="AB">Alberta</option>'+
                                '<option value="BC">British Columbia</option>'+
                                '<option value="MB">Manitoba</option>'+
                                '<option value="NB">New Brunswick</option>'+
                                '<option value="NL">Newfoundland and Labrador</option>'+
                                '<option value="NT">Northwest Territories</option>'+
                                '<option value="NS">Nova Scotia</option>'+
                                '<option value="NU">Nunavut</option>'+
                                '<option value="ON">Ontario</option>'+
                                '<option value="PE">Prince Edward Island</option>'+
                                '<option value="QC">Quebec</option>'+
                                '<option value="SK">Saskatchewan</option>'+
                                '<option value="YT">Yukon</option>'+
                            '</select>'+
                        '</div>');
                    console.log('Query limit reached');
                } else {
                    $("#city-state-country").html('No city found under postal code');
                    console.log(data.api_status);
                }
            });
        } else {
            console.log('not ok');
            $("#city-state-country").html('');
        }
    });
});
