public with sharing class Service_FetchCandidates {
    public static List<Candidate__c> getCandidates() {
        Util_Security.checkReadAccess('Candidate__c');
        List<Candidate__c> result = [
            SELECT Id,Location__c,Position__c,Experience_Level__c,Is_Remote__c, Skills__c 
            FROM Candidate__c
            ];
        return result;
    }
}