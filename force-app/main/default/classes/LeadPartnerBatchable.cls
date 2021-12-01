public with sharing class LeadPartnerBatchable implements Database.Batchable<sObject> {
    public FINAL Map<Schema.SObjectField, Object> mapFieldsToUpdate;

    public LeadPartnerBatchable(Map<Schema.SObjectField, Object> mapFieldsToUpdate) {
        this.mapFieldsToUpdate = mapFieldsToUpdate;
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(LeadsSelector.getQueryLocatorIsPartner());
    }

    public void execute(Database.BatchableContext BC, List<Lead> scope) {
        List<Lead> leadsToUpdate = LeadsService.updateFields(scope, mapFieldsToUpdate);
        update leadsToUpdate;
    }
   
    public void finish(Database.BatchableContext BC) {
    }

}
