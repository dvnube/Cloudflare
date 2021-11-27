trigger LeadsTrigger on Lead (
    //before insert,
    after insert,
    after update) {
    
    /* if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            LeadsTriggerHandler.beforeInsert(Trigger.new);
        }
    } else  */if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            LeadsTriggerHandler.afterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            LeadsTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }

}