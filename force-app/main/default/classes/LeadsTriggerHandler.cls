public without sharing class LeadsTriggerHandler {
    
    public static void afterInsert(List<Lead> records) {
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead record : records) {
            afterInsert(record, leadsToUpdate);
        }
    }

    static void afterInsert(Lead record, List<Lead> leadsToUpdate) {
        handleDraftLeadSource(record, leadsToUpdate);        
    }

    static void handleDraftLeadSource(Lead record, List<Lead> leadsToUpdate) {
        Lead l = new Lead(Id = record.Id);

        if (isPartnerLead(record.DraftLeadSource__c)) {
            l.LeadSource = Label.Partner;
            l.DraftLeadSource__c = null;            
        } else {
            l.OwnerId = Ids__c.getOrgDefaults().LeadDraftQueue__c;
        }

        leadsToUpdate.add(l);
    }

    static Boolean isPartnerLead() {
        return String.isNotBlank(value) ? value.contains(Label.Partner) : false;
    }
    
}
