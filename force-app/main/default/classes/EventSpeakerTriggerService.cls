public with sharing class EventSpeakerTriggerService {
    public static void checkIfSpeakerIsNotAssignedToAnotherEvent(List<Event_Speaker__C> eventSpeakerList){
        String errorMessage = 'Speaker is not available!';
    
        List<Id> speakersId = new List<Id>();
        for(Event_Speaker__C evS : eventSpeakerList){
            speakersId.add(evs.Speaker__c);
        }
        List<Id> eventsId = new List<Id>();
        for(Event_Speaker__C ev : eventSpeakerList){
            eventsId.add(ev.Event__c);
        }

        Map<Id,Event__c> newEventsMap = new Map<Id,Event__c>();
        for(Event__C es :[Select Id, Start_Date_Time__c, End_Date_Time__c FROM Event__c WHERE Id IN: eventsId]){
            newEventsMap.put(es.Id, es);
        }
        
        Map<Id,Set<Event_Speaker__c>> oldEventSpeakerMap = new Map<Id,Set<Event_Speaker__c>>();
        for(Event_Speaker__C es : [Select Speaker__c, Event__r.Start_Date_Time__c, Event__r.End_Date_Time__c from Event_Speaker__c WHERE Speaker__c IN: speakersId]){
            if(oldEventSpeakerMap.containsKey(es.Speaker__c)){
                oldEventSpeakerMap.get(es.Speaker__c).add(es);
            } 
            else{
                oldEventSpeakerMap.put(es.Speaker__c, new Set<Event_Speaker__c>{es});
            }
        }
        
        if(!oldEventSpeakerMap.isEmpty()){
            for(Event_Speaker__c es : eventSpeakerList){
                Datetime newEventStartDate = newEventsMap.get(es.Event__c).Start_Date_Time__c;
                Datetime newEventEndDate = newEventsMap.get(es.Event__c).End_Date_Time__c;
                for(Event_Speaker__c s: oldEventSpeakerMap.get(es.Speaker__c)){
                    Datetime oldEventStartDate = s.Event__r.Start_Date_Time__c;
                    Datetime oldEventEndDate = s.Event__r.End_Date_Time__c;
                    if(!(newEventEndDate <= oldEventStartDate || newEventStartDate >= oldEventEndDate))  
                    {
                        es.addError(errorMessage);
                    }
                }            
            }
        }
    }
}