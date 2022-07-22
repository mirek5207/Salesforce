public with sharing class SmartyStreetsCallout {
    private static final String ADDRESS_VARIABLE = '/street-address?';
    private static final String AUTH_ID = 'auth-id=07e9db34-d373-6323-4b86-bb9e15c34ea4&';
    private static final String AUTH_TOKEN = 'auth-token=tXkakzPemyE3N1vME4Se&';
    private static final String AUTH_LICENSE = 'license=us-core-cloud';
    // private static final String DATA = 'street=142%20Park%20Rd&street2=&city=Pittsford&state=NY&zipcode=14534&candidates=10&match=invalid&';
    private static final Boolean VERIFIED_TRUE = true;
    private static final Boolean VERIFIED_FALSE = false;

    @Future(callout=true)
    public static void callUsStreetApiFuture(Set<Id> locationsIdSet, String authId, String authToken, String authLicense)
    {
        List<Location__c> locationsList = [SELECT Street__c, City__c, State__c, Postal_Code__c FROM Location__c WHERE Id IN: locationsIdSet AND Verified__c = :VERIFIED_FALSE];
        callUsStreetApi(locationsList, authId, authToken, authLicense);

    }
    public static void callUsStreetApi (List<Location__c> locationsList, String authId, String authToken, String authLicense)
    {
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        Http http = new Http();
        request.setHeader('Content-Type', 'application/json');
        for(Location__c location : locationsList){
            String data = 'street=' + location.Street__c + '&street2=&city='+ location.City__c + '&state=' + location.State__c +'&zipcode=' + location.Postal_Code__c + '&candidates=1&match=strict&';
            request.setEndpoint('callout:Smarty_Streets_Path' + ADDRESS_VARIABLE + AUTH_ID + AUTH_TOKEN + data + AUTH_LICENSE);
            System.debug('callout:Smarty_Streets_Path' + ADDRESS_VARIABLE + AUTH_ID + AUTH_TOKEN + data + AUTH_LICENSE);
            HttpResponse response = http.send(request);
            if(response.getBody() != '[]'){
                location.Verified__c = true;
                update location;
            }
            System.debug(response.getBody());
        }
        //LocationTriggerService.updateStatusOfLocationVerified(locationsList, VERIFIED_TRUE);
    }
}
