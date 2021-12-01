public with sharing class LeadsSelector {
    public static String getQueryLocatorIsPartner() {
        String query = ' SELECT Id, OwnerId, CreatedDate, LastPartnerBatchProcess__c, IsPartnerLead__c ';
        query += ' FROM Lead ';
        
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