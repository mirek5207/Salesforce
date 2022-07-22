public with sharing class EventAttendeeTriggerHandler {
    public static void execute() {
        if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                EventAttendeeTriggerService.sendEmailWithConfirmationAfterInsert((List<Event_Attendee__C>)Trigger.New);
            } 
        } 
    }
}
