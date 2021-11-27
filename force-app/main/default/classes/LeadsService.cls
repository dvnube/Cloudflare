public with sharing class LeadsService {

    /* public static void handleDraftLeadSourceBeforeInsert(Lead record) {
        if (isPartnerLead(record.DraftSource__c)) {
            record.IsPartnerLead__c = true;
            record.LeadSource = Label.LeadPartner;
            record.DraftSource__c = null;            
        } else {
            record.OwnerId = Ids__c.getOrgDefaults().LeadDraftQueue__c;
        }
    } */

    public static void handleDraftLeadSourceAfterInsert(Lead record, List<Lead> leadsToUpdate) {
        Lead l = new Lead();

        if (isPartnerLead(record.DraftSource__c)) {
            l.Id = record.Id;
            l.IsPartnerLead__c = true;
            l.LeadSource = Label.LeadPartner;
            l.DraftSource__c = null;            
        } else if (!record.OwnerId.equals(Ids__c.getOrgDefaults().LeadDraftQueue__c)) {
            l.Id = record.Id;
            l.OwnerId = Ids__c.getOrgDefaults().LeadDraftQueue__c;
        }

        if (String.isNotBlank(l.Id)) {
            leadsToUpdate.add(l);
        }        
    }


    public static void handleDraftLeadSourceAfterUpdate(Lead record, Lead oldRecord, List<Lead> leadsToUpdate) {
        Lead l = new Lead();

        if (isPartnerLead(record.DraftSource__c)) {
            l.Id = record.Id;
            l.IsPartnerLead__c = true;
            l.LeadSource = Label.LeadPartner;
            l.DraftSource__c = null;            
        } else if (!record.OwnerId.equals(Ids__c.getOrgDefaults().LeadDraftQueue__c)) {
            l.Id = record.Id;
            l.OwnerId = Ids__c.getOrgDefaults().LeadDraftQueue__c;
        }

        if (String.isNotBlank(l.Id)) {
            leadsToUpdate.add(l);
        }        
    }

    static Boolean isPartnerLead(String value) {
        return String.isNotBlank(value) ? value.contains(Label.LeadPartner) : false;
    }
}
