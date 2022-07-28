public with sharing class EventSpeakerService {
    public static List<Event_Speaker__c> getSpeakersByEventId(String eventId){
        List<Event_Speaker__c> speakerDataList = [SELECT Speaker__r.Id, Speaker__r.Name, Speaker__r.Email__c,Speaker__r.Phone__c FROM Event_Speaker__c WHERE Event__c = :eventId];
        return speakerDataList;
    }
    public static List<Speaker__c> transformEventSpeakerListToSpeakerList(List<Event_Speaker__c> eventSpeakerList){
        List<Speaker__c> speakerList = new List<Speaker__c>();
        for(Event_Speaker__c ev : eventSpeakerList){
            Speaker__c speaker = new Speaker__c();
            speaker.Id = ev.Speaker__r.Id;
            speaker.Name = ev.Speaker__r.Name;
            speaker.Email__c = ev.Speaker__r.Email__c;
            speaker.Phone__c = ev.Speaker__r.Phone__c;
            speakerList.add(speaker);
        }
        return speakerList;
    }
}