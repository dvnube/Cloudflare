trigger LeadsTrigger on Lead (after insert, after update) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            LeadsTriggerHandler.afterInsert();
        } else if (Trigger.isUpdate) {
            LeadsTriggerHandler.afterUpdate();
        }
    }

}