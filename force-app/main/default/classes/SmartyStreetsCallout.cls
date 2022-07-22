global class SmartyStreetsCallout implements Queueable {
    private static final String ADDRESS_VARIABLE = '/street-address?';
    private static final String AUTH_ID = 'auth-id=07e9db34-d373-6323-4b86-bb9e15c34ea4&';
    private static final String AUTH_TOKEN = 'auth-token=tXkakzPemyE3N1vME4Se&';
    private static final String AUTH_LICENSE = 'license=us-core-cloud';
    // private static final String DATA = 'street=142%20Park%20Rd&street2=&city=Pittsford&state=NY&zipcode=14534&candidates=10&match=invalid&';
    private static final Boolean VERIFIED_TRUE = true;
    private static final Boolean VERIFIED_FALSE = false;

    private List<Location__c> locations;

    public SmartyStreetsCallout(List<Location__c> locations){
        this.locations = locations;
    }
    public void execute(QueueableContext context) {
        for(Location__c location: locations){
            location.Verified__c = true;
        }
        update locations;
    }

    // public static void callUsStreetApiFuture(Set<Id> locationsIdSet, String authId, String authToken, String authLicense,QueueableContext context)
    // {
    //     //List<Location__c> locationsList = [SELECT Id, Street__c, City__c, State__c, Postal_Code__c FROM Location__c WHERE Id IN: locationsIdSet AND Verified__c = :VERIFIED_FALSE];
    //     //callUsStreetApi(locationsList, authId, authToken, authLicense);
    //     List<Location__c> locationsToUpdate = new List<Location__c>();
    //     for(Location__c location : [SELECT Id, Street__c, City__c, State__c, Postal_Code__c, Verified__c FROM Location__c WHERE Id IN: locationsIdSet]){
    //         location.Verified__c = true;
    //         locationsToUpdate.add(location);
    //     }
    //     update locationsToUpdate;
    // }
    // public static List<Location__c> callUsStreetApi (List<Location__c> locationsList)
    // {
    //     List<Location__c> locationsTuUpdate = new List<Location__c>();
    //     HttpRequest request = new HttpRequest();
    //     request.setMethod('GET');
    //     Http http = new Http();
    //     request.setHeader('Content-Type', 'application/json');
    //     for(Location__c location : locationsList){
    //         String data = 'street=' + location.Street__c + '&street2=&city='+ location.City__c + '&state=' + location.State__c +'&zipcode=' + location.Postal_Code__c + '&candidates=1&match=strict&';
    //         request.setEndpoint('callout:Smarty_Streets_Path' + ADDRESS_VARIABLE + AUTH_ID + AUTH_TOKEN + data + AUTH_LICENSE);
    //         System.debug('callout:Smarty_Streets_Path' + ADDRESS_VARIABLE + AUTH_ID + AUTH_TOKEN + data + AUTH_LICENSE);
    //         HttpResponse response = http.send(request);
    //         if(response.getBody() != '[]'){
    //             locationsTuUpdate.add(location);
    //         }
    //         System.debug(response.getBody());
    //     }
    //     return locationsTuUpdate;
    // }
}