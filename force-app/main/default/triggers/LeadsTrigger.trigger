trigger LeadsTrigger on Lead (after insert, after update) {
    new LeadsTriggerHandler().run();
}