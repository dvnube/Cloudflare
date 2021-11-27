public with sharing class LeadPartnerBatchable implements Database.Batchable<sObject> {
    public FINAL Boolean isPartner;
    public FINAL Map<Schema.SObjectField, Object> mapFieldsToUpdate;

    public LeadPartnerBatchable(Boolean isPartner, Map<Schema.SObjectField, Object> mapFieldsToUpdate) {
        this.isPartner = isPartner;
        this.mapFieldsToUpdate = mapFieldsToUpdate;
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator(LeadsSelector.getQueryLocatorIsPartner(isPartner));
    }

    public void execute(Database.BatchableContext BC, List<Lead> scope) {
        List<Lead> leadsToUpdate = LeadsService.updateFields(scope, mapFieldsToUpdate);
        update leadsToUpdate;
    }
   
    public void finish(Database.BatchableContext BC) {
    }

}
