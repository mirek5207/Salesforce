@RestResource(urlMapping='/Event/*')
global with sharing class EventRestController {
    @HttpGet
    global static List<Event__c> getAllUpcomingEvents() {
        List<Event__c> eventsList =  EventService.getAllEventsWhichAreLiveAndStartDateIsGreaterThanToday();
        return eventsList;
    }
}
