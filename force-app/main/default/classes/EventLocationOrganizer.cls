public with sharing class EventLocationOrganizer {
    @AuraEnabled public Id id;
    @AuraEnabled public String name;
    @AuraEnabled public String organizerName;
    @AuraEnabled public String city;
    @AuraEnabled public Datetime startDateTime;
    @AuraEnabled public Datetime endDateTime;
    @AuraEnabled public String eventDetail;

    public EventLocationOrganizer(Id id, String name, String organizerName, String city, Datetime startDateTime, Datetime endDateTime, String eventDetail){
        this.id = id;
        this.name = name;
        this.organizerName = organizerName;
        this.city = city;
        this.startDateTime = startDateTime;
        this.endDateTime = endDateTime;
        this.eventDetail = eventDetail;
    }
}
