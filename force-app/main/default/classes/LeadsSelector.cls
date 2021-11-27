public with sharing class LeadsSelector {
    public static String getQueryLocatorIsPartner(Boolean isPartner) {
        String query = ' SELECT Id, OwnerId ';
        query += ' FROM Lead ';
        query += ' WHERE IsPartnerLead__c = ' + isPartner;
        
        return query;
    }
}
