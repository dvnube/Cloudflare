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
        handleDraftLeadSourceAfter(record, leadsToUpdate);      
    }


    public static void handleDraftLeadSourceAfterUpdate(Lead record, Lead oldRecord, List<Lead> leadsToUpdate) {
        handleDraftLeadSourceAfter(record, leadsToUpdate);
    }

    static void handleDraftLeadSourceAfter(Lead record, List<Lead> leadsToUpdate) {
        Lead l = new Lead();

        if (isPartnerLeadFromDraftSource(record.DraftSource__c)) {
            l.Id = record.Id;
            l.IsPartnerLead__c = true;
            l.LeadSource = Label.LeadPartner;
            l.DraftSource__c = null;            
        } else if (!record.IsPartnerLead__c && !record.OwnerId.equals(Ids__c.getOrgDefaults().LeadDraftQueue__c)) {
            l.Id = record.Id;
            l.OwnerId = Ids__c.getOrgDefaults().LeadDraftQueue__c;
        }

        if (String.isNotBlank(l.Id)) {
            leadsToUpdate.add(l);
        }   
    }

    static Boolean isPartnerLeadFromDraftSource(String draftSource) {
        return String.isNotBlank(draftSource) ? draftSource.contains(Label.LeadPartner) : false;
    }

    public static List<Lead> updateFields(List<Lead> records, Map<Schema.SObjectField, Object> mapFieldsToUpdate) {
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead record : records) {
            Boolean isChanged = false;
            updateUsingMap(record, mapFieldsToUpdate, isChanged);
            updateNewRequirements(record, isChanged);

            if (isChanged) {
                leadsToUpdate.add(record);
            }
        }

        return leadsToUpdate;
    }

    static void updateUsingMap(Lead record, Map<Schema.SObjectField, Object> mapFieldsToUpdate, Boolean isChanged) {
        for (Schema.SObjectField field : mapFieldsToUpdate.keySet()) {
            Object oldValue = record.get(field);
            Object newValue = mapFieldsToUpdate.get(field);
            if (oldValue != newValue) {
                record.put(field, newValue);
                isChanged = true;
            }
        }
    }

    static void updateNewRequirements(Lead record, Boolean isChanged) {
        if (record.IsPartnerLead__c || (greaterThan60Days(record.CreatedDate))) {
            record.PartnerStatus__c = 'Golden Partner';
            isChanged = true;
        } else {
            record.PartnerStatus__c = 'Normal Partner';
            isChanged = true;
        }
    }

    static Boolean greaterThan60Days(Datetime d) {
        Integer daysBetween = d.date().daysBetween(now.date());

        return daysBetween > 60;
    }
}