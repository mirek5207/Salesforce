@isTest
public with sharing class EventSpeakerTriggerTest {
    @TestSetup static void dataSetup(){
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Event_Organizer__c.SObjectType,
                Speaker__c.SObjectType,
                Event__c.SObjectType,
                Event_Speaker__c.SObjectType
            }
        );

        Event_Organizer__c organizer = new Event_Organizer__c();
        organizer.Name = 'testOrganizer';
        organizer.Email__c = 'organizer@gmail.com';
        organizer.Phone__c = '111222333';
        uow.registerNew(organizer);

        Speaker__c speaker = new Speaker__c();
        speaker.Name = 'testSpeaker';
        speaker.Phone__c = '111222333';
        speaker.Email__c = 'speaker@gmail.com';
        uow.registerNew(speaker);

        Event__c event = new Event__c();
        event.Name = '16.08.2022 - 18.08.2022';
        event.Name__c = 'testEvent';
        event.Start_Date_Time__c = DateTime.newInstance(2022, 8, 16);
        event.End_Date_Time__c = DateTIme.newInstance(2022, 8, 18);
        event.Live__c = true;
        event.Max_Seats__c = 15;
        uow.registerNew(event, Event__c.Organizer__c,organizer);


        Event_Speaker__c eventSpeaker = new Event_Speaker__c();
        uow.registerRelationship(eventSpeaker,Event_Speaker__c.Speaker__c,speaker);
        uow.registerNew(eventSpeaker,Event_Speaker__c.Event__c,event);
        
        //Not associated with any speaker
        Event__c testEvent = new Event__c();
        testEvent.Name = '15.08.2022 - 17.08.2022';
        testEvent.Name__c = 'testEvent';
        testEvent.Start_Date_Time__c = DateTime.newInstance(2022, 8, 15);
        testEvent.End_Date_Time__c = DateTIme.newInstance(2022, 8, 17);
        testEvent.Live__c = true;
        testEvent.Max_Seats__c = 15;
        uow.registerNew(testEvent, Event__c.Organizer__c,organizer);

        Event__c testEvent2 = new Event__c();
        testEvent2.Name = '15.08.2040 - 17.08.2040';
        testEvent2.Name__c = 'testEvent';
        testEvent2.Start_Date_Time__c = DateTime.newInstance(2040, 8, 15);
        testEvent2.End_Date_Time__c = DateTIme.newInstance(2040, 8, 17);
        testEvent2.Live__c = true;
        testEvent2.Max_Seats__c = 15;
        uow.registerNew(testEvent2, Event__c.Organizer__c,organizer);
        uow.commitWork();   
    }

    @isTest
    public static void speakerIsAssignedToAnotherEventAtSameRangeOfTime(){
        String errorMessage = 'Speaker is not available!';
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Event_Speaker__c.SObjectType
            }
        );
        Event__c event = [Select Id from Event__c where Event__c.Name = '15.08.2022 - 17.08.2022'];
        Speaker__c speaker = [Select Id from Speaker__c where Speaker__c.Name = 'testSpeaker'];
        Event_Speaker__c eventSpeaker = new Event_Speaker__c();
        uow.registerRelationship(eventSpeaker,Event_Speaker__c.Speaker__c,speaker);
        uow.registerNew(eventSpeaker,Event_Speaker__c.Event__c,event);
        try{
            test.startTest();
            uow.commitWork();
            test.stopTest();
        }catch(Exception ex){
            System.assertEquals(ex.getMessage().contains(errorMessage),true);
        }
    }
    @isTest
    public static void speakerIsNotAssignedToAnotherEventAtSameRangeOfTime(){
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Event_Speaker__c.SObjectType
            }
        );
        Event__c event = [Select Id from Event__c where Event__c.Name = '15.08.2040 - 17.08.2040'];
        Speaker__c speaker = [Select Id from Speaker__c where Speaker__c.Name = 'testSpeaker'];
        Event_Speaker__c eventSpeaker = new Event_Speaker__c();
        uow.registerRelationship(eventSpeaker,Event_Speaker__c.Speaker__c,speaker);
        uow.registerNew(eventSpeaker,Event_Speaker__c.Event__c,event);   
        test.startTest();
        uow.commitWork();
        test.stopTest();
        Integer numberOfInsertedEventSpeakerInThisTest = [SELECT count() FROM Event_Speaker__c WHERE Event__r.Name = '15.08.2040 - 17.08.2040' AND Speaker__r.Name = 'testSpeaker'];
        System.assertEquals(1, numberOfInsertedEventSpeakerInThisTest); 
    }
}