public with sharing class Service_FetchExistingMatches {
    public static List<Match__c> getMatches(Set<Id> jobIds, Set<Id> candidateIds) {
        Util_Security.checkReadAccess('Match__c');
        List<Match__c> result = [
        SELECT Job__c,Candidate__c 
        FROM Match__c WHERE Job__c 
        IN :jobIds 
        AND Candidate__c IN :candidateIds
        ];
        return result;
    }
}