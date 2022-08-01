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
}
