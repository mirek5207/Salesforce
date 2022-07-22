public with sharing class LocationTriggerService {
    private static final String ADDRESS_VARIABLE = '/street-address?';
    private static final String AUTH_ID = 'auth-id=07e9db34-d373-6323-4b86-bb9e15c34ea4&';
    private static final String AUTH_TOKEN = 'auth-token=tXkakzPemyE3N1vME4Se&';
    private static final String AUTH_LICENSE = 'license=us-core-cloud';
    private static final String DATA = 'street=142%20Park%20Rd&street2=&city=Pittsford&state=NY&zipcode=14534&candidates=10&match=invalid&';
    private static final Boolean VERIFIED_FALSE = false;

    public static void checkIfLocationIsCorrectAndChangeStatusOfVerified(List<Location__c> locationsList){
        //Set<Id> locationsIdSet = (new Map<Id,Location__c>(locationsList)).keySet();
        SmartyStreetsCallout updateJob = new SmartyStreetsCallout(locationsList);
        System.enqueueJob(updateJob);
    }
}