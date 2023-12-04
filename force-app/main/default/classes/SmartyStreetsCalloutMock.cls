global class SmartyStreetsCalloutMock implements HttpCalloutMock {
    private final String responseBody = '[{"input_index":0,"candidate_index":0,"delivery_line_1":"71 Saint Nicholas Dr","last_line":"North Pole AK 99705-7752","delivery_point_barcode":"997057752711","components":{"primary_number":"71","street_name":"Saint Nicholas","street_suffix":"Dr","city_name":"North Pole","default_city_name":"North Pole","state_abbreviation":"AK","zipcode":"99705","plus4_code":"7752","delivery_point":"71","delivery_point_check_digit":"1"},"metadata":{"record_type":"S","zip_type":"Standard","county_fips":"02090","county_name":"Fairbanks North Star","carrier_route":"C001","congressional_district":"AL","rdi":"Commercial","elot_sequence":"0342","elot_sort":"A","latitude":64.756530,"longitude":-147.349620,"precision":"Zip9","time_zone":"Alaska","utc_offset":-9,"dst":true},"analysis":{"dpv_match_code":"Y","dpv_footnotes":"AABB","dpv_cmra":"N","dpv_vacant":"N","dpv_no_stat":"N","active":"Y"}}]';
    private static final String LOCATION_NAME = 'testName';

    global HttpResponse respond(HttpRequest req){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(responseBody);
        response.setStatusCode(200);
        return response;
    }
}
