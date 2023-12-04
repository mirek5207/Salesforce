public with sharing class LocationTriggerService {
    private static final Boolean VALUE_TRUE = true;
    private static final Boolean VALUE_FALSE = false;
    public static void checkIfLocationIsCorrectAndChangeStatusOfVerified(List<Location__c> locationsList){
        Smarty_Street_Provider__mdt provider = Smarty_Street_Provider__mdt.getInstance('UrlWithAuth');
        String urlWithAuth = provider.Url__c + 'auth-id=' + provider.Auth_Id__c + '&auth-token=' + provider.Auth_Token__c + '&license=' + provider.Auth_License__c;
        SmartyStreetsCallout updateJob = new SmartyStreetsCallout(locationsList, urlWithAuth);
        ID jobId = System.enqueueJob(updateJob);
    }
    public static void updateLocations(List<Location__c> locations){
        CheckRecursive.runOnce = VALUE_FALSE;
        update locations;
        CheckRecursive.runOnce = VALUE_TRUE;
    }
    public static List<Location__c> updateLocationCheckboxVerified(Map<Location__c,HttpResponse> locationResponse){
        List<Location__c> locations = new List<Location__c>();
        for(Location__c location : locationResponse.keySet()){
            HttpResponse response = locationResponse.get(location);
            if(response.getBody() != '[]'){
                location.Verified__c = VALUE_TRUE;   
            }
            else{
                location.Verified__c = VALUE_FALSE;   
            }
            locations.add(location);
        }
       
        return locations;
    }
}
