@isTest
public with sharing class EventSpeakerTriggerTest {
    private static final String ERROR_MESSAGE = 'Speaker is not available!';
    private static final String ORGANIZER_NAME = 'testOrganizer';
    private static final String SPEAKER_NAME = 'testSpeaker';
    private static final String EVENT_NAME = 'testEvent';
    private static final String TEST_EMAIL = 'test@gmail.com';
    private static final String TEST_PHONE = '111222333';
    private static final INTEGER EVENT_MAX_SEATS = 15;
    private static final Boolean EVENT_LIVE_TRUE = true;

    private static final Datetime EVENT_START_DATE_BASIC = DateTime.newInstance(2050, 8, 16);
    private static final Datetime EVENT_END_DATE_BASIC = DateTIme.newInstance(2050, 8, 20);
    private static final Datetime EVENT_START_DATE_OVERLAP_FROM_LEFT = DateTime.newInstance(2050, 8, 15);
    private static final Datetime EVENT_END_DATE_OVERLAP_FROM_LEFT = DateTIme.newInstance(2050, 8, 17);
    private static final Datetime EVENT_START_DATE_OVERLAP_FROM_RIGHT = DateTime.newInstance(2050, 8, 18);
    private static final Datetime EVENT_END_DATE_OVERLAP_FROM_RIGHT = DateTIme.newInstance(2050, 8, 21);
    private static final Datetime EVENT_START_DATE_INSIDE_BASIC = DateTime.newInstance(2050, 8, 17);
    private static final Datetime EVENT_END_DATE_INSIDE_BASIC = DateTIme.newInstance(2050, 8, 19);
    private static final Datetime EVENT_START_DATE_OUTSIDE_BASIC = DateTime.newInstance(2050, 8, 14);
    private static final Datetime EVENT_END_DATE_OUTSIDE_BASIC = DateTIme.newInstance(2050, 8, 24);
    private static final Datetime EVENT_START_DATE_AFTER_BASIC = DateTime.newInstance(2050, 8, 24);
    private static final Datetime EVENT_END_DATE_AFTER_BASIC = DateTIme.newInstance(2050, 8, 27);
    
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
        organizer.Name = ORGANIZER_NAME;
        organizer.Email__c = TEST_EMAIL;
        organizer.Phone__c = TEST_PHONE;
        uow.registerNew(organizer);

        Speaker__c speaker = new Speaker__c();
        speaker.Name = SPEAKER_NAME;
        speaker.Phone__c = TEST_PHONE;
        speaker.Email__c = TEST_EMAIL;
        uow.registerNew(speaker);

        Event__c event = new Event__c();
        event.Name = EVENT_NAME;
        event.Name__c = EVENT_NAME;
        event.Start_Date_Time__c = EVENT_START_DATE_BASIC;
        event.End_Date_Time__c = EVENT_END_DATE_BASIC;
        event.Live__c = EVENT_LIVE_TRUE;
        event.Max_Seats__c = EVENT_MAX_SEATS;
        uow.registerNew(event, Event__c.Organizer__c,organizer);


        Event_Speaker__c eventSpeaker = new Event_Speaker__c();
        uow.registerRelationship(eventSpeaker,Event_Speaker__c.Speaker__c,speaker);
        uow.registerNew(eventSpeaker,Event_Speaker__c.Event__c,event);
        
        //Not associated with any speaker
        List<Event__c> eventList = new List<Event__c>();

        Event__c testEvent = new Event__c();
        testEvent.Start_Date_Time__c = EVENT_START_DATE_OVERLAP_FROM_LEFT;
        testEvent.End_Date_Time__c = EVENT_END_DATE_OVERLAP_FROM_LEFT;
        eventList.add(testEvent);

        Event__c testEvent2 = new Event__c();
        testEvent2.Start_Date_Time__c = EVENT_START_DATE_OVERLAP_FROM_RIGHT;
        testEvent2.End_Date_Time__c = EVENT_END_DATE_OVERLAP_FROM_RIGHT;
        eventList.add(testEvent2);

        Event__c testEvent3 = new Event__c();
        testEvent3.Start_Date_Time__c = EVENT_START_DATE_INSIDE_BASIC;
        testEvent3.End_Date_Time__c = EVENT_END_DATE_INSIDE_BASIC;
        eventList.add(testEvent3);

        Event__c testEvent4 = new Event__c();
        testEvent4.Start_Date_Time__c = EVENT_START_DATE_OUTSIDE_BASIC;
        testEvent4.End_Date_Time__c = EVENT_END_DATE_OUTSIDE_BASIC;
        eventList.add(testEvent4);

        Event__c testEvent5 = new Event__c();
        testEvent5.Start_Date_Time__c = EVENT_START_DATE_AFTER_BASIC;
        testEvent5.End_Date_Time__c = EVENT_END_DATE_AFTER_BASIC;
        eventList.add(testEvent5);

        for(Event__c ev : eventList){
            ev.Name = EVENT_NAME;
            ev.Name__c = EVENT_NAME;
            ev.Live__c = EVENT_LIVE_TRUE;
            ev.Max_Seats__c = EVENT_MAX_SEATS;
            uow.registerNew(ev, Event__c.Organizer__c,organizer);
        }
        uow.commitWork();   
    }
    @isTest
    public static void speakerIsAssignedToAnotherEventAtSameRangeOfTime_DateOverlapFromLeft(){
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Event_Speaker__c.SObjectType
            }
        );
        Event__c event = [SELECT Id FROM Event__c WHERE Event__c.Start_Date_Time__c = :EVENT_START_DATE_OVERLAP_FROM_LEFT AND Event__c.End_Date_Time__c = :EVENT_END_DATE_OVERLAP_FROM_LEFT];
        Speaker__c speaker = [SELECT Id FROM Speaker__c WHERE Speaker__c.Name = :SPEAKER_NAME];
        Event_Speaker__c eventSpeaker = new Event_Speaker__c();
        uow.registerRelationship(eventSpeaker,Event_Speaker__c.Speaker__c,speaker);
        uow.registerNew(eventSpeaker,Event_Speaker__c.Event__c,event);
        try{
            test.startTest();
            uow.commitWork();
            test.stopTest();
        }catch(Exception ex){
            System.assertEquals(ex.getMessage().contains(ERROR_MESSAGE),true);
        }
    }
    @isTest
    public static void speakerIsAssignedToAnotherEventAtSameRangeOfTime_DateOverlapFromRight(){
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Event_Speaker__c.SObjectType
            }
        );
        Event__c event = [SELECT Id FROM Event__c WHERE Event__c.Start_Date_Time__c = :EVENT_START_DATE_OVERLAP_FROM_RIGHT AND Event__c.End_Date_Time__c = :EVENT_END_DATE_OVERLAP_FROM_RIGHT];
        Speaker__c speaker = [SELECT Id FROM Speaker__c WHERE Speaker__c.Name = :SPEAKER_NAME];
        Event_Speaker__c eventSpeaker = new Event_Speaker__c();
        uow.registerRelationship(eventSpeaker,Event_Speaker__c.Speaker__c,speaker);
        uow.registerNew(eventSpeaker,Event_Speaker__c.Event__c,event);
        try{
            test.startTest();
            uow.commitWork();
            test.stopTest();
        }catch(Exception ex){
            System.assertEquals(ex.getMessage().contains(ERROR_MESSAGE),true);
        }
    }

    @isTest
    public static void speakerIsNotAssignedToAnotherEventAtSameRangeOfTime(){
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Event_Speaker__c.SObjectType
            }
        );
        Event__c event = [SELECT Id FROM Event__c WHERE Event__c.Start_Date_Time__c = :EVENT_START_DATE_AFTER_BASIC AND Event__c.End_Date_Time__c = :EVENT_END_DATE_AFTER_BASIC];
        Speaker__c speaker =  [SELECT Id FROM Speaker__c WHERE Speaker__c.Name = :SPEAKER_NAME];
        Event_Speaker__c eventSpeaker = new Event_Speaker__c();
        uow.registerRelationship(eventSpeaker,Event_Speaker__c.Speaker__c,speaker);
        uow.registerNew(eventSpeaker,Event_Speaker__c.Event__c,event);   
        test.startTest();
        uow.commitWork();
        test.stopTest();
        Integer numberOfInsertedEventSpeaker = [SELECT count() FROM Event_Speaker__c WHERE Speaker__r.Name = :SPEAKER_NAME AND Event__r.Start_Date_Time__c = :EVENT_START_DATE_AFTER_BASIC AND Event__r.End_Date_Time__c = :EVENT_END_DATE_AFTER_BASIC];
        System.assertEquals(1, numberOfInsertedEventSpeaker); 
    }
}