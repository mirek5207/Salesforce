public with sharing class EventLocationController {
    @AuraEnabled(cacheable=true)
    public static List<Location__c> getLocationDataByEventId(String eventId){
        List<Event__c> eventsList = EventLocationService.getLocationByEventId(eventId);
        List<Location__c> locationList = EventLocationService.tranformEventListToLocationList(eventsList);
        return locationList;
    }
}
