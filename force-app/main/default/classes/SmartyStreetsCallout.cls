global class SmartyStreetsCallout implements Queueable,Database.AllowsCallouts {
    private List<Location__c> locations;
    private String urlWithAuth;

    private final String requestMethodGet = 'GET';

    public SmartyStreetsCallout(List<Location__c> locations, String urlWithAuth){
        this.locations = locations;
        this.urlWithAuth = urlWithAuth;
    }

    public void execute(QueueableContext context) {
        Map<Location__c, HttpResponse> responseLocationsMap = new Map<Location__c, HttpResponse>();
        HttpResponse response = new HttpResponse();
        for(Location__c location: [SELECT Id, Verified__c, Street__c, City__c, State__c, Postal_Code__c FROM Location__c WHERE Id IN : locations]){
            String street = EncodingUtil.urlEncode(location.Street__c , 'UTF-8');
            String city = EncodingUtil.urlEncode(location.City__c, 'UTF-8');
            String urlWithAuthAndData = urlWithAuth + '&street=' + street + '&street2=&city='+ city + '&state=' + location.State__c +'&zipcode=' + location.Postal_Code__c + '&candidates=1&match=strict';
            response = sendRequestToCheckIfLocationAddressIsValid(urlWithAuthAndData,requestMethodGet);
            responseLocationsMap.put(location, response);
        }
        List<Location__c> locationsToUpdate = LocationTriggerService.updateLocationCheckboxVerified(responseLocationsMap);
        LocationTriggerService.updateLocations(locationsToUpdate);
    }
    @TestVisible 
    private HttpResponse sendRequestToCheckIfLocationAddressIsValid(String urlWithAuthAndData, String method){
        Map<Location__c, HttpResponse> responseLocationsMap = new Map<Location__c, HttpResponse>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(urlWithAuthAndData);
        HttpResponse response = http.send(request);

        return response;
    }
    
    
}
