public with sharing class Service_JobMatch {
    @AuraEnabled(cacheable=true)
    public static List<Match__c> getMatches(Id jobId) {
        Util_Security.checkReadAccess('Match__c');
        List<Match__c> result = [
            SELECT  Candidate__r.First_Name__c, 
                    Candidate__r.Last_Name__c, 
                    Candidate__r.Position__c, 
                    Match_Score__c, 
                    Notification_Sent__c, 
                    Status_Match__c
            FROM Match__c
            WHERE Job__c = :jobId
            ];

        return result;
    }
}