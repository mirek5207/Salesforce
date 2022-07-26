@isTest
public with sharing class LocationTriggerTest {
    private static final String LOCATION_NAME = 'testName';
    private static final String LOCATION_CITY = 'NORTH POLE';
    private static final String LOCATION_COUNTRY = 'United States';
    private static final String LOCATION_POSTAL_CODE = '99705';
    private static final String LOCATION_STREET = '71 Saint Nicholas Dr';
    private static final String LOCATION_STATE = 'AK';
    private static final Boolean VERIFIED_TRUE = true;
    private static final Boolean VERIFIED_FALSE = false;
    private static final String POSITIVE_RESPONSE_FROM_API = '[{"input_index":0,"candidate_index":0,"delivery_line_1":"71 Saint Nicholas Dr","last_line":"North Pole AK 99705-7752","delivery_point_barcode":"997057752711","components":{"primary_number":"71","street_name":"Saint Nicholas","street_suffix":"Dr","city_name":"North Pole","default_city_name":"North Pole","state_abbreviation":"AK","zipcode":"99705","plus4_code":"7752","delivery_point":"71","delivery_point_check_digit":"1"},"metadata":{"record_type":"S","zip_type":"Standard","county_fips":"02090","county_name":"Fairbanks North Star","carrier_route":"C001","congressional_district":"AL","rdi":"Commercial","elot_sequence":"0342","elot_sort":"A","latitude":64.756530,"longitude":-147.349620,"precision":"Zip9","time_zone":"Alaska","utc_offset":-9,"dst":true},"analysis":{"dpv_match_code":"Y","dpv_footnotes":"AABB","dpv_cmra":"N","dpv_vacant":"N","dpv_no_stat":"N","active":"Y"}}]';
    
    @TestSetup
    static void setupData(){
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Location__c.SObjectType
            }
        );
        List<Location__c> locations = new List<Location__c>();
        for(Integer i = 0; i < 2; i++){
            Location__c location = new Location__c();
            location.Name = LOCATION_NAME + i;
            location.City__c = LOCATION_CITY;
            location.Country__c = LOCATION_COUNTRY;
            location.Postal_Code__c = LOCATION_POSTAL_CODE;
            location.Street__c = LOCATION_STREET;
            location.State__c = LOCATION_STATE;
            if(i<1){
                location.Verified__c = VERIFIED_FALSE;
            }
            else{
                location.Verified__c = VERIFIED_TRUE;
            }      
            locations.add(location); 
        }
        uow.registerNew(locations);
        
        CheckRecursive.runOnce = VERIFIED_FALSE;
        uow.commitWork();
        CheckRecursive.runOnce = VERIFIED_True;
    }
    @isTest
    static void jobShouldRunWhenUpdateLocations(){
        Smarty_Street_Provider__mdt provider = Smarty_Street_Provider__mdt.getInstance('UrlWithAuth');
        String urlWithAuth = provider.Url__c + 'auth-id=' + provider.Auth_Id__c + '&auth-token=' + provider.Auth_Token__c + '&license=' + provider.Auth_License__c;
        List<Location__c> locations = [SELECT City__c, Country__c, Postal_Code__c, Street__c, State__c, Verified__c FROM Location__c WHERE NAME = :LOCATION_NAME+'0' Limit 1];
        SmartyStreetsCallout smartyStreetsCallout = new SmartyStreetsCallout(locations, urlWithAuth);

        Test.setMock(HttpCalloutMock.class, new SmartyStreetsCalloutMock());
        Test.startTest();
        update locations;
        Test.stopTest();
        AsyncApexJob job = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'SmartyStreetsCallout'];
        System.assert(job != null);
    }
    @isTest
    static void jobShouldRunWhenInsertLocations(){
        Smarty_Street_Provider__mdt provider = Smarty_Street_Provider__mdt.getInstance('UrlWithAuth');
        String urlWithAuth = provider.Url__c + 'auth-id=' + provider.Auth_Id__c + '&auth-token=' + provider.Auth_Token__c + '&license=' + provider.Auth_License__c;
        List<Location__c> locations = [SELECT City__c, Country__c, Postal_Code__c, Street__c, State__c, Verified__c FROM Location__c WHERE NAME = :LOCATION_NAME+'0' Limit 1];
        SmartyStreetsCallout smartyStreetsCallout = new SmartyStreetsCallout(locations, urlWithAuth);

        Test.setMock(HttpCalloutMock.class, new SmartyStreetsCalloutMock());
        Test.startTest();
        Location__c location = new Location__c(Name = LOCATION_NAME, City__c = LOCATION_CITY, Country__c = LOCATION_COUNTRY, Postal_Code__c = LOCATION_POSTAL_CODE, Street__c = LOCATION_STREET, State__c = LOCATION_STATE);
        insert location;
        Test.stopTest();
        AsyncApexJob job = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'SmartyStreetsCallout'];
        System.assert(job != null);
    }
    @isTest
    static void updateLocationCheckboxToVerifiedFalseWhenEmptyResponse(){
        Map<Location__c,HttpResponse> locationResponse = new Map<Location__c,HttpResponse>();
        List<Location__c> location = [SELECT Id, Verified__c FROM Location__c WHERE Verified__c = :VERIFIED_TRUE Limit 1];
        HttpResponse emptyResponse = new HttpResponse();
        emptyResponse.setBody('[]');
        locationResponse.put(location.get(0),emptyResponse);
        Test.startTest();
        List<Location__c> updatedLocation = LocationTriggerService.updateLocationCheckboxVerified(locationResponse);
        Test.stopTest();
        System.assertEquals(VERIFIED_FALSE, updatedLocation.get(0).Verified__c);
    }
    @isTest
    static void updateLocationCheckboxToVerifiedTrueWhenApiFoundAddressAndReturnNotEmptyResponse(){
        Map<Location__c,HttpResponse> locationResponse = new Map<Location__c,HttpResponse>();
        List<Location__c> location = [SELECT Id, Verified__c FROM Location__c WHERE Verified__c = :VERIFIED_FALSE Limit 1];
        HttpResponse emptyResponse = new HttpResponse();
        emptyResponse.setBody(POSITIVE_RESPONSE_FROM_API);
        locationResponse.put(location.get(0),emptyResponse);
        Test.startTest();
        List<Location__c> updatedLocation = LocationTriggerService.updateLocationCheckboxVerified(locationResponse);
        Test.stopTest();
        System.assertEquals(VERIFIED_TRUE, updatedLocation.get(0).Verified__c);
    }
    
}
