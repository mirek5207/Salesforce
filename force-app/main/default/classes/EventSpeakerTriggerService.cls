public with sharing class EventSpeakerTriggerService {
    public static void onBeforeInsertOrUpdate(List<sObject> objList){
        List<SObject> speakers = [Select Speaker__c from Event_Speaker__C];
        for(SObject ev : objList){
            for(SObject speaker : speakers){
                if(ev.get('Speaker__c') == speaker.get('Speaker__c')){
                    ev.addError('Speaker is not available!'+ ev.get('Speaker__c') + ' ' +speaker.id);
                }
            }
        }
    }
}