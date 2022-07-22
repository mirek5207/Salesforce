global class SmartyStreetsCallout implements Queueable,Database.AllowsCallouts {
    private static final String ADDRESS_VARIABLE = '/street-address?';
    private static final String AUTH_ID = 'auth-id=07e9db34-d373-6323-4b86-bb9e15c34ea4&';
    private static final String AUTH_TOKEN = 'auth-token=tXkakzPemyE3N1vME4Se&';
    private static final String AUTH_LICENSE = 'license=us-core-cloud';
    // private static final String DATA = 'street=142%20Park%20Rd&street2=&city=Pittsford&state=NY&zipcode=14534&candidates=10&match=invalid&';
    private static final Boolean VALUE_TRUE = true;
    private static final Boolean VALUE_FALSE = false;

    private List<Location__c> locations;

    public SmartyStreetsCallout(List<Location__c> locations){
        this.locations = locations;
    }
    public void execute(QueueableContext context) {
        List<Location__c> locationsToUpdate = new List<Location__c>();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        Http http = new Http();
        request.setHeader('Content-Type', 'application/json');
        for(Location__c location: [SELECT Id, Verified__c, Street__c, City__c, State__c, Postal_Code__c FROM Location__c WHERE Id IN : locations]){
            String street = EncodingUtil.urlEncode(location.Street__c , 'UTF-8');
            String city = EncodingUtil.urlEncode(location.City__c, 'UTF-8'); 
            String data = 'street=' + street + '&street2=&city='+ city + '&state=' + location.State__c +'&zipcode=' + location.Postal_Code__c + '&candidates=1&match=strict&';
            request.setEndpoint('callout:Smarty_Streets_Path' + ADDRESS_VARIABLE + AUTH_ID + AUTH_TOKEN + data + AUTH_LICENSE);
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


    //dziala
    // public void execute(QueueableContext context) {
    //     List<Location__c> locationsToUpdate = new List<Location__c>();
    //     for(Location__c location: [SELECT Id, Verified__c FROM Location__c WHERE Id IN : locations AND Verified__c = :VALUE_FALSE]){
    //         location.Verified__c = VALUE_TRUE;
    //         locationsToUpdate.add(location);
    //     }
    //     CheckRecursive.runOnce = VALUE_FALSE;
    //     update locationsToUpdate;
    //     CheckRecursive.runOnce = VALUE_TRUE;
    // }
}
