trigger JobTrigger on Job__c (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            JobTriggerHandler.handleAfterInsertOrUpdate(Trigger.new);
        }
    }
}