public with sharing class EventAttendeeController {
    @AuraEnabled(cacheable=true)
    public static List<AttendeeLocation> getEventAttendeeList(String eventId){
        List<Event_Attendee__c> eventAttendeeList = EventAttendeeService.getAttendeesByEventId(eventId);
        List<AttendeeLocation> attendeeList = EventAttendeeService.transformEventAttendeeListToAttendeeList(eventAttendeeList);
        return attendeeList;
    }
}
