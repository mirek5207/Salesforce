public with sharing class LocationTriggerService {
    public static void checkIfLocationIsCorrectAndChangeStatusOfVerified(List<Location__c> locationsList){
        Smarty_Street_Provider__mdt provider = Smarty_Street_Provider__mdt.getInstance('UrlWithAuth');
        String urlWithAuth = provider.Url__c + 'auth-id=' + provider.Auth_Id__c + '&auth-token=' + provider.Auth_Token__c + '&license=' + provider.Auth_License__c;
        SmartyStreetsCallout updateJob = new SmartyStreetsCallout(locationsList, urlWithAuth);
        ID jobId = System.enqueueJob(updateJob);
    }
}
