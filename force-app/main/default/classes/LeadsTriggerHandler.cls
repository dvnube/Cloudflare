public without sharing class LeadsTriggerHandler extends TriggerHandler {
    
    public override void afterInsert() {
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead record : (List<Lead>) Trigger.new) {
            afterInsert(record, leadsToUpdate);
        }
    }

    public override void afterUpdate() {
        Map<Id, Lead> oldMap = (Map<Id, Lead>) Trigger.oldMap;
    }

    void afterInsert(Lead record, List<Lead> leadsToUpdate) {
        LeadsService.handleDraftLeadSource(record, leadsToUpdate);
    }
    
}
