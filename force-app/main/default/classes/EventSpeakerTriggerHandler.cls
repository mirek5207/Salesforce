public with sharing class EventSpeakerTriggerHandler {
    public static void execute() {
        if (Trigger.isBefore) {
            if (Trigger.isInsert || Trigger.isUpdate) {
                EventSpeakerTriggerService.onBeforeInsertOrUpdate(Trigger.New);
            } 
        } 
    }
}