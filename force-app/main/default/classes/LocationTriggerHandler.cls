public with sharing class LocationTriggerHandler {
    public static void execute() {
        if (Trigger.isAfter) {
            if (Trigger.isInsert || Trigger.isUpdate) {
                LocationTriggerService.checkIfLocationIsCorrectAndChangeStatusOfVerified((List<Location__c>)Trigger.New);
            } 
        } 
    }
}
