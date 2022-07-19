public with sharing class DeleteOldEvents implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Datetime today = System.now();
        Datetime todayMinus2Months = today.addMonths(-2);
        return Database.getQueryLocator([SELECT Id FROM Event__c WHERE Live__c = true AND End_Date_Time__c < :todayMinus2Months]);
    }
    public void execute(Database.BatchableContext bc, List<Event__c> events){
        delete events;
    }
    public void finish(Database.BatchableContext bc){
        EmailSender.sendEmail('Intern: Project Cloufit - Batch Apex', 'Execution of the batch has been processed', 'mirek15207@gmail.com');
    }
}
