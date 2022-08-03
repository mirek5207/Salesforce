public with sharing class EventService {
    private static final Boolean LIVE_TRUE = true;
    public static List<EventLocationOrganizer> getAllLiveEventsWithLocationAndOrganizer(){
        List<Event__c> eventsList = [SELECT id, Name, Event_Detail__c, Start_Date_Time__c, End_Date_Time__c, Location__r.City__c, Organizer__r.Name FROM Event__c WHERE Live__c = :LIVE_TRUE];

        List<EventLocationOrganizer> eventsLocationOrganizerList = new List<EventLocationOrganizer>();
        for(Event__c event : eventsList){
            EventLocationOrganizer eventLO = new EventLocationOrganizer(event.id,event.Name,event.Organizer__r.Name,event.Location__r.City__c,event.Start_Date_Time__c,event.End_Date_Time__c, event.Event_Detail__c);
            eventsLocationOrganizerList.add(eventLO);
        }
        return eventsLocationOrganizerList;
    }
}
