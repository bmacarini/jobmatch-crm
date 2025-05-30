trigger JobTrigger on Job__c (after insert, after update) {
    Handler_JobTrigger.handleAfterInsertOrUpdate(
        Trigger.new,
        new Handler_JobTrigger.TriggerContext(Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate)
    );
}