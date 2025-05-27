trigger JobTrigger on Job__c (after insert, after update) {
    JobTriggerHandler.handleAfterInsertOrUpdate(Trigger.new, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate);
}