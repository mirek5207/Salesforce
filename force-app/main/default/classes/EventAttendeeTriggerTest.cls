@isTest
public with sharing class EventAttendeeTriggerTest {
    private static final String ORGANIZER_NAME = 'testOrganizer';
    private static final String ATTENDEE_NAME = 'testAttendee';
    private static final String EVENT_NAME = 'testEvent';
    private static final String TEST_EMAIL = 'test@gmail.com';
    private static final String TEST_PHONE = '111222333';
    private static final String SPEAKER_NAME = 'testSpeaker';
    private static final Datetime EVENT_START_DATE = DateTime.newInstance(2022, 8, 16);
    private static final Datetime EVENT_END_DATE = DateTIme.newInstance(2022, 8, 18);
    private static final Boolean EVENT_LIVE_TRUE = true;
    private static final INTEGER EVENT_MAX_SEATS = 15;

    @TestSetup static void dataSetup(){
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Event_Organizer__c.SObjectType,
                Attendee__c.SObjectType,
                Event__c.SObjectType
            }
        );

        Event_Organizer__c organizer = new Event_Organizer__c();
        organizer.Name = ORGANIZER_NAME;
        organizer.Email__c = TEST_EMAIL;
        organizer.Phone__c = TEST_PHONE;
        uow.registerNew(organizer);

        Attendee__c attendee = new Attendee__c();
        attendee.Name = ATTENDEE_NAME;
        attendee.Phone__c = TEST_PHONE;
        attendee.Email__c = TEST_EMAIL;
        uow.registerNew(attendee);

        Event__c event = new Event__c();
        event.Name = EVENT_NAME;
        event.Name__c = EVENT_NAME;
        event.Start_Date_Time__c = EVENT_START_DATE;
        event.End_Date_Time__c = EVENT_END_DATE;
        event.Live__c = EVENT_LIVE_TRUE;
        event.Max_Seats__c = EVENT_MAX_SEATS;
        uow.registerNew(event, Event__c.Organizer__c,organizer);       
        uow.commitWork();
    }

    @isTest
    public static void sendEmailWithConfirmationAfterInsertTest(){
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Event_Attendee__c.SObjectType
            }
        );
        Attendee__c attendee = [SELECT id FROM Attendee__c WHERE Attendee__c.Name = :ATTENDEE_NAME ];
        Event__c event = [SELECT id FROM Event__c WHERE Event__c.Start_Date_Time__c = :EVENT_START_DATE AND Event__c.End_Date_Time__c = :EVENT_END_DATE];
        Event_Attendee__c eventAttendee = new Event_Attendee__c();
        uow.registerRelationship(eventAttendee,Event_Attendee__c.Attendee__c,attendee);
        uow.registerNew(eventAttendee,Event_Attendee__c.Event__c,event);
        test.startTest();
        uow.commitWork();
        System.assertEquals(1, Limits.getEmailInvocations());
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