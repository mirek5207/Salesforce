public with sharing class EventLocationService {
    public static List<Event__c> getLocationByEventId(String eventId){
        List<Event__c> events = [SELECT Location__r.Id, Location__r.Name, Location__r.Landmark__c, Location__r.City__c, Location__r.Country__c, Location__r.Postal_Code__c, Location__r.State__c, Location__r.Street__c FROM Event__c WHERE Id = :eventId];
        return events;
    }
    public static List<Location__c> tranformEventListToLocationList(List<Event__c> eventList){
        List<Location__c> locations = new List<Location__c>();
        for(Event__c event : eventList){
            Location__c location = new Location__c();
            location.Id = event.Location__r.Id;
            location.Name = event.Location__r.Name;
            location.Landmark__c = event.Location__r.Landmark__c;
            location.City__c = event.Location__r.City__c;
            location.Country__c = event.Location__r.Country__c;
            location.Postal_Code__c = event.Location__r.Postal_Code__c;
            location.State__c = event.Location__r.State__c;
            location.Street__c = event.Location__r.Street__c;
            locations.add(location);
        }
        return locations;
    }
}
