public with sharing class JobTriggerHandler {
    public static void handleAfterInsertOrUpdate(List<Job__c> jobs) {

        List<Candidate__c> candidates = [SELECT Id,Location__c,Desired_Job__c,Experience_Level__c,Open_To_Remote_Jobs__c FROM Candidate__c];

        Map<String, List<Candidate__c>> candidatesByKey = new Map<String, List<Candidate__c>>();

        for(Candidate__c candidate : candidates) {
            String locationKey = candidate.Open_To_Remote_Jobs__c != 'Yes' ? candidate.Location__c : 'Yes';
            String candidateKey = (candidate.Desired_Job__c + '|' + candidate.Experience_Level__c + '|' + locationKey);
            if (!candidatesByKey.containsKey(candidateKey)) {
                candidatesByKey.put(candidateKey, new List<Candidate__c>());
            }
            candidatesByKey.get(candidateKey).add(candidate);
        }

        Set<Id> jobIds = new Set<Id>();
        Set<Id> candidateIds = new Set<Id>();


        for(List<Candidate__c> candidateList : candidatesByKey.values()) {
            for(Candidate__c candidate : candidateList) {
                candidateIds.add(candidate.Id);
            }
        }

        for (Job__c job : jobs) {
            jobIds.add(job.Id);
        }

        List<Match__c> existingMatches = [
            SELECT Job__c,Candidate__c 
            FROM Match__c WHERE Job__c 
            IN :jobIds 
            AND Candidate__c IN :candidateIds
        ];
        Set<String> existingMatchesKeys = new Set<String>();
        for(Match__c match : existingMatches) {
            String key = (match.Job__c + '|' + match.Candidate__c);
            existingMatchesKeys.add(key);
        }

        List<Match__c> matchesToInsert = new List<Match__c>();
        for (Job__c job : jobs) {
            String locationKey = job.Remote__c != 'Yes' ? job.Location__c : 'Yes';
            
            String jobKey = (job.Title__c + '|' + job.Experience_Level__c + '|' + locationKey);

            if(candidatesByKey.containsKey(jobKey)) {
                
                for(Candidate__c candidate : candidatesByKey.get(jobKey)) {
                    String matchKey = (job.Id + '|' + candidate.Id);
                    if(!existingMatchesKeys.contains(matchKey)) {
                    Match__c match = new Match__c();
                    match.Job__c = job.Id;
                    match.Candidate__c = candidate.Id;
                    match.Status__c = 'New';
                    match.Score__c = 100;
                    matchesToInsert.add(match);
                    }
                }
            }
        }

        if(!matchesToInsert.isEmpty()) {
            insert matchesToInsert;
        }
    }
}