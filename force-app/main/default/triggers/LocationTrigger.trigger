trigger LocationTrigger on Location__c (after insert, before update) {
    LocationTriggerHandler.execute();
}