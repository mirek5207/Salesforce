public with sharing class EventSpeakerController {
    
    @AuraEnabled(cacheable=true)
    public static List<Speaker__c> getEventSpeakerList(String eventId){
        List<Event_Speaker__c> eventSpeakerList = EventSpeakerService.getSpeakersByEventId(eventId);
        List<Speaker__c> speakersList = EventSpeakerService.transformEventSpeakerListToSpeakerList(eventSpeakerList);
        return speakersList;
    }

}