trigger LocationTrigger on Location__c (after insert, after update) {
    LocationTriggerHandler.execute();
}