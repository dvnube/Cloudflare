public without sharing class LeadsTriggerHandler {

    /* public static void beforeInsert(List<Lead> records) {
        for (Lead record : records) {
            beforeInsert(record);
        }
    } */

    public static void afterInsert(List<Lead> records) {
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead record : (List<Lead>) Trigger.new) {
            afterInsert(record, leadsToUpdate);
        }

        update leadsToUpdate;
    }

    public static void afterUpdate(List<Lead> records, Map<Id, Lead> oldMap) {
        List<Lead> leadsToUpdate = new List<Lead>();

        for (Lead record : records) {
            afterUpdate(record, oldMap.get(record.Id), leadsToUpdate);
        }

        update leadsToUpdate;
    }

    /* static void beforeInsert(Lead record) {
        LeadsService.handleDraftLeadSourceBeforeInsert(record);
    } */

    static void afterInsert(Lead record, List<Lead> leadsToUpdate) {
        LeadsService.handleDraftLeadSourceAfterInsert(record, leadsToUpdate);
    }

    static void afterUpdate(Lead record, Lead oldRecord, List<Lead> leadsToUpdate) {
        LeadsService.handleDraftLeadSourceAfterUpdate(record, oldRecord, leadsToUpdate);
    }
    
}
