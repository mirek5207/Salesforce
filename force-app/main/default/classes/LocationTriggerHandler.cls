public with sharing class LocationTriggerHandler {
    public static void execute() {
        if (Trigger.isBefore) {
            if (Trigger.isInsert || Trigger.isUpdate) {
                LocationTriggerService.checkIfLocationIsCorrectAndChangeStatusOfVerified((List<Location__c>)Trigger.New);
            } 
        } 
    }
}