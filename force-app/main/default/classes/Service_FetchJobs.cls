public with sharing class Service_FetchJobs {
    @AuraEnabled(cacheable=true)
    public static List<Job__c> getJobs() {
        Util_Security.checkReadAccess('Job__c');
        List<Job__c> result = [
            SELECT Id,Company__c,Employment_Type__c,Industry__c,Is_Active__c,Location__c,Position__c,Experience_Level__c,Offered_Salary__c,Is_Remote__c, Skills__c, OwnerId 
            FROM Job__c
            ];
        return result;
    }
}