trigger LeadsTrigger on Lead (after insert, after update) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            LeadsTriggerHandler.afterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            LeadsTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }

}