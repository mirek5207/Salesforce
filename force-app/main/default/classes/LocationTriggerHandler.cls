public with sharing class LocationTriggerHandler {
    public static void execute() {
        if (((Trigger.isBefore && Trigger.isUpdate) || (Trigger.isAfter && Trigger.isInsert)) && CheckRecursive.runOnce) {         
                LocationTriggerService.checkIfLocationIsCorrectAndChangeStatusOfVerified((List<Location__c>)Trigger.New);
        } 
    }
}
