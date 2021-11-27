public with sharing class LeadsService {
    public static void handleDraftLeadSource(Lead record, List<Lead> leadsToUpdate) {
        Lead l = new Lead(Id = record.Id);

        if (isPartnerLead(record.DraftSource__c)) {
            l.LeadSource = Label.LeadPartner;
            l.DraftSource__c = null;            
        } else {
            l.OwnerId = Ids__c.getOrgDefaults().LeadDraftQueue__c;
        }

        leadsToUpdate.add(l);
    }

    static Boolean isPartnerLead(String value) {
        return String.isNotBlank(value) ? value.contains(Label.LeadPartner) : false;
    }
}
