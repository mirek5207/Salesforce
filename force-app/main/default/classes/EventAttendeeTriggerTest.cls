@isTest
public with sharing class EventAttendeeTriggerTest {
    @TestSetup static void makeData(){
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Event_Organizer__c.SObjectType,
                Attendee__c.SObjectType,
                Event__c.SObjectType,
                Event_Attendee__c.SObjectType
            }
        );

        Event_Organizer__c organizer = new Event_Organizer__c();
        organizer.Name = 'testOrganizer';
        organizer.Email__c = 'organizer@gmail.com';
        organizer.Phone__c = '111222333';
        uow.registerNew(organizer);

        Attendee__c attendee = new Attendee__c();
        attendee.Name = 'testSpeaker';
        attendee.Phone__c = '111222333';
        attendee.Email__c = 'speaker@gmai.com';
        uow.registerNew(attendee);

        Event__c event = new Event__c();
        event.Name = '16.08.2022 - 18.08.2022';
        event.Name__c = 'testEvent';
        event.Start_Date_Time__c = DateTime.newInstance(2022, 8, 16);
        event.End_Date_Time__c = DateTIme.newInstance(2022, 8, 18);
        event.Live__c = true;
        event.Max_Seats__c = 15;
        uow.registerNew(event, Event__c.Organizer__c,organizer);       
        test.startTest();
        uow.commitWork();
        test.stopTest();
    }

    @isTest
    public static void sendEmailWithConfirmationAfterInsertTest(){
        String errorMessage = 'Caught email exception:';
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Event_Attendee__c.SObjectType
            }
        );
        Attendee__c attendee = [Select id from Attendee__c WHERE Attendee__c.Name = 'testSpeaker' ];
        Event__c event = [Select id from Event__c Where Event__c.Name = '16.08.2022 - 18.08.2022'];
        Event_Attendee__c eventAttendee = new Event_Attendee__c();
        uow.registerRelationship(eventAttendee,Event_Attendee__c.Attendee__c,attendee);
        uow.registerNew(eventAttendee,Event_Attendee__c.Event__c,event);
        test.startTest();
        System.assertEquals(0, Limits.getEmailInvocations(), 'No emails should be sent');
        uow.commitWork();
        System.assertEquals(1, Limits.getEmailInvocations(), 'Emails should be sent');
        test.stopTest();    
    }

    @isTest
    public static void displayErrorIfThereWasAProblemWithSendingEmailTest(){
        Messaging.SendEmailResult failedMessageResult =(Messaging.SendEmailResult) JSON.deserialize('{"success":false}', Messaging.SendEmailResult.class);
        List<Messaging.SendEmailResult> errorList = new List<Messaging.SendEmailResult>();
        errorList.add(failedMessageResult);
        EventAttendeeTriggerService.displayErrorIfThereWasAProblemWithSendingEmail(errorList);
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertEquals(1, ApexPages.getMessages().size());
    }
}
