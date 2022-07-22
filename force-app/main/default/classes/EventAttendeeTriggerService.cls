public with sharing class EventAttendeeTriggerService {
    private static final String ERROR_MESSAGE = 'Wystąpił błąd przy wysyłaniu emaila potwierdzającego zapis uczestnika na wydarzenie';
    
    public static void sendEmailWithConfirmationAfterInsert(List<Event_Attendee__C> eventAttendeeList) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<Id> eventAttendeeId = new List<Id>();
        for(Event_Attendee__C ea: eventAttendeeList){
            eventAttendeeId.add(ea.Id);
        }
        
        List<Event_Attendee__C> emailData = [Select Attendee__r.Name,Attendee__r.Email__c,Event__r.Name,Event__r.Start_Date_Time__c,
        Event__r.Organizer__r.Name,Event__r.Location__r.City__c,Event__r.Location__c FROM Event_Attendee__C WHERE Id IN: eventAttendeeId];
        
        for(Event_Attendee__c ed : emailData){
            String subject = 'Pass for the ' +  ed.Event__r.Name;
            String body = 'Dear ' + ed.Attendee__r.Name + ',<br><br> Thank you for registering for ' + ed.Event__r.Name + ' which will be Organized on '+ 
            ed.Event__r.Start_Date_Time__c +' & will be held in ' + ed.Event__r.Location__r.City__c +
            '. We are excited to have you, see you in the event.<br><br>' + 
            'Find the Google Map Location for the Event Here. (https://www.google.com/maps/place/) + Add your Location Here<br><br>' +
            'Thanks,<br><br>' + ed.Event__r.Organizer__r.Name;

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{ed.Attendee__r.Email__c});
            mail.setSubject(subject);
            mail.setHtmlBody(body);
            mails.add(mail);
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(mails);
        displayErrorIfThereWasAProblemWithSendingEmail(results);
    }
    @TestVisible private static void displayErrorIfThereWasAProblemWithSendingEmail(Messaging.SendEmailResult[] results) {
        for (Messaging.SendEmailResult res : results) {
            if (!res.isSuccess()) {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_MESSAGE));
            }
        }
    }
}
