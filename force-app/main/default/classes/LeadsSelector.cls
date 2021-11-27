public with sharing class LeadsSelector {
    public static String getQueryLocatorIsPartner(Boolean isPartner) {
        String query = ' SELECT Id, OwnerId ';
        query += ' FROM Lead ';
        query += ' WHERE IsPartnerLead__c = ' + isPartner;
        
        return query;
    }

    public static List<Lead> selectByNamePhoneEmail(String firstName, String lastName, String email) {
        return [
            SELECT Id, Phone 
            FROM Lead 
            WHERE 
                    FirstName = :firstName 
                AND LastName = :lastName 
                AND Email = :email
            ];
    }
}
