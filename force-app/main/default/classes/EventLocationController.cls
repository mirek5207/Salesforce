public with sharing class EventLocationController {
    @AuraEnabled(cacheable=true)
    public static List<Location__c> getLocationDataByEventId(String eventId){
        List<Event__c> eventsList = EventLocationService.getLocationByEventId(eventId);
        List<Location__c> locationList = EventLocationService.tranformEventListToLocationList(eventsList);
        if(locationList.size()>0){
            return locationList;
        }
        return null;
    }
}
