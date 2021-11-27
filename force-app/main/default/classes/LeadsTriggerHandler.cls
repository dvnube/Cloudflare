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
        handleDraftLeadSource(record, leadsToUpdate);        
    }

    void handleDraftLeadSource(Lead record, List<Lead> leadsToUpdate) {
        Lead l = new Lead(Id = record.Id);

        if (isPartnerLead(record.DraftSource__c)) {
            l.LeadSource = Label.LeadPartner;
            l.DraftSource__c = null;            
        } else {
            l.OwnerId = Ids__c.getOrgDefaults().LeadDraftQueue__c;
        }

        leadsToUpdate.add(l);
    }

    Boolean isPartnerLead(String value) {
        return String.isNotBlank(value) ? value.contains(Label.LeadPartner) : false;
    }
    
}
