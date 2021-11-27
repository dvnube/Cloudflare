public class LeadPartnerSchedulable implements Schedulable {
    FINAL Integer addMinutes;
    FINAL Map<Schema.SObjectField, Object> mapFieldsToUpdate = new Map<Schema.SObjectField, Object> {
        Lead.OwnerId => Ids__c.getOrgDefaults().LeadPartnerOwner__c
    };

    public LeadPartnerSchedulable(Integer addMinutes) {
        this.addMinutes = addMinutes;
    }

    public void execute(SchedulableContext sc) {
        reschedule(sc);
        Database.executeBatch(new LeadPartnerBatchable(true, mapFieldsToUpdate)); //
    }

    void reschedule(SchedulableContext sc) {
        // Re-schedule ourself to run again in "intervalMinutes" time
        Datetime now  = Datetime.now();
        Datetime nextRunTime = now.addMinutes(addMinutes);
        //todo: levar cronString para Utils
        String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + 
                            nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
                            nextRunTime.month() + ' ? ' + nextRunTime.year(); 
        System.schedule(
            LeadPartnerSchedulable.class.getName() + '-' + now.format(),
            cronString,
            new LeadPartnerSchedulable(addMinutes)
        );

        // Abort the current job
        Id jobId = sc.getTriggerId();
        System.abortJob(jobId);
    }

}
