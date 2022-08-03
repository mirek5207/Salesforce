public with sharing class EventController {
    @AuraEnabled
    public static List<EventLocationOrganizer> getLiveEventsList(){
        List<EventLocationOrganizer> eventsList = EventService.getAllLiveEventsWithLocationAndOrganizer();
        return eventsList;
    }
}
