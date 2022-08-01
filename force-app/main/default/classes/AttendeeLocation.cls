public with sharing class AttendeeLocation {
    @AuraEnabled public Id id;
    @AuraEnabled public String name;
    @AuraEnabled public String email;
    @AuraEnabled public string companyName;
    @AuraEnabled public String city;

    public AttendeeLocation(Id id, String name, String email, String companyName, String city){
        this.id = id;
        this.name = name;
        this.email = email;
        this.companyName = companyName;
        this.city = city;
    }
}
