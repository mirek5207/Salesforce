public with sharing class EventAttendeeService {
    public static List<Event_Attendee__c> getAttendeesByEventId(String eventId){
        List<Event_Attendee__c> attendeeDataList = [SELECT Attendee__r.Id, Attendee__r.Name, Attendee__r.Email__c, Attendee__r.Company_Name__c, Attendee__r.Address__r.City__c FROM Event_Attendee__c WHERE Event__c = :eventId];
        return attendeeDataList;
    }
    public static List<AttendeeLocation> transformEventAttendeeListToAttendeeList(List<Event_Attendee__c> eventAttendeeList){
        List<AttendeeLocation> attendeeList = new List<AttendeeLocation>();
        for(Event_Attendee__c ev : eventAttendeeList){
            AttendeeLocation attendee = new AttendeeLocation(ev.Attendee__r.Id, ev.Attendee__r.Name, ev.Attendee__r.Email__c, ev.Attendee__r.Company_Name__c, ev.Attendee__r.Address__r.City__c);
            attendeeList.add(attendee);
        }
        return attendeeList;
    }

    public static List<Event_Attendee__c> getEventsByAttendeeId(String attendeeId, Boolean isLive){
        List<Event_Attendee__c> eventDataList = [SELECT Event__r.id, Event__r.Name, Event__r.Start_Date_Time__c, Event__r.Location__r.City__c, Event__r.Organizer__r.Name FROM Event_Attendee__c WHERE Attendee__c = :attendeeId AND Event__r.live__c = : isLive];
        return eventDataList;
    }
    public static List<EventLocationOrganizer> transformEventAttendeeListToEventsList(List<Event_Attendee__C> eventAttendeeList){
        List<EventLocationOrganizer> eventLocationOrganizerList = new List<EventLocationOrganizer>();
        for(Event_Attendee__c ea: eventAttendeeList){
            EventLocationOrganizer eventLocationOrganizer = new EventLocationOrganizer(ea.Event__r.id, ea.Event__r.Name, ea.Event__r.Organizer__r.Name, ea.Event__r.Location__r.City__c, ea.Event__r.Start_Date_Time__c);
            eventLocationOrganizerList.add(eventLocationOrganizer);
        }
        return eventLocationOrganizerList;
    }
}
