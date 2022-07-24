global class SmartyStreetsCallout implements Queueable,Database.AllowsCallouts {
    private static final Boolean VALUE_TRUE = true;
    private static final Boolean VALUE_FALSE = false;
    private List<Location__c> locations;
    private String urlWithAuth;

    public SmartyStreetsCallout(List<Location__c> locations, String urlWithAuth){
        this.locations = locations;
        this.urlWithAuth = urlWithAuth;
    }

    public void execute(QueueableContext context) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        List<Location__c> locationsToUpdate = new List<Location__c>();

        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');

        for(Location__c location: [SELECT Id, Verified__c, Street__c, City__c, State__c, Postal_Code__c FROM Location__c WHERE Id IN : locations]){
            String street = EncodingUtil.urlEncode(location.Street__c , 'UTF-8');
            String city = EncodingUtil.urlEncode(location.City__c, 'UTF-8');
            String urlWithAuthAndData = urlWithAuth + '&street=' + street + '&street2=&city='+ city + '&state=' + location.State__c +'&zipcode=' + location.Postal_Code__c + '&candidates=1&match=strict';
            request.setEndpoint(urlWithAuthAndData);
            HttpResponse response = http.send(request);
            if(response.getBody() != '[]'){
                location.Verified__c = VALUE_TRUE;   
            }
            else{
                location.Verified__c = VALUE_FALSE;   
            }
            locationsToUpdate.add(location);
        }
        CheckRecursive.runOnce = VALUE_FALSE;
        update locationsToUpdate;
        CheckRecursive.runOnce = VALUE_TRUE;
    }
}
