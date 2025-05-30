public with sharing class Handler_JobTrigger {
    public class TriggerContext {
        public Boolean isAfter;
        public Boolean isInsert;
        public Boolean isUpdate;

        public TriggerContext(Boolean isAfter, Boolean isInsert, Boolean isUpdate) {
            this.isAfter = isAfter;
            this.isInsert = isInsert;
            this.isUpdate = isUpdate;
        }
    }

    private static Map<String, List<Candidate__c>> groupCandidatesByKey(List<Candidate__c> candidates) {
        Map<String, List<Candidate__c>> candidatesByKey = new Map<String, List<Candidate__c>>();

        for(Candidate__c candidate : candidates) {
            String locationKey = String.valueOf(candidate.Is_Remote__c) == 'Yes' ? 'YesToRemote' : candidate.Location__c;
            String candidateKey = (candidate.Position__c + '|' + candidate.Experience_Level__c + '|' + locationKey);
            if (!candidatesByKey.containsKey(candidateKey)) {
                candidatesByKey.put(candidateKey, new List<Candidate__c>());
            }
            candidatesByKey.get(candidateKey).add(candidate);
        }
        return candidatesByKey;
    }

    private static Set<Id> getCandidateIds(Map<String, List<Candidate__c>> candidatesByKey){
        Set<Id> candidateIds = new Set<Id>();

        for(List<Candidate__c> candidateList : candidatesByKey.values()) {
            for(Candidate__c candidate : candidateList) {
                candidateIds.add(candidate.Id);
            }
        }
        return candidateIds;
    }

    private static Set<String> getExistingMatchesKeys(List<Match__c> existingMatches) {
        Set<String> existingMatchesKeys = new Set<String>();
        for(Match__c match : existingMatches) {
            String key = (match.Job__c + '|' + match.Candidate__c);
            existingMatchesKeys.add(key);
        }
        return existingMatchesKeys;
    }

    private static List<Match__c> buildMatchesToInsert(List<Job__c> jobs, Map<String, List<Candidate__c>> candidatesByKey, Set<String> existingMatchesKeys) {
        List<Match__c> matchesToInsert = new List<Match__c>();
        for (Job__c job : jobs) {
            String locationKey = String.valueOf(job.Is_Remote__c) == 'Yes' ? 'YesToRemote' : job.Location__c;
            
            String jobKey = (job.Position__c + '|' + job.Experience_Level__c + '|' + locationKey);

            if(candidatesByKey.containsKey(jobKey)) {
                
                for(Candidate__c candidate : candidatesByKey.get(jobKey)) {
                    String matchKey = (job.Id + '|' + candidate.Id);
                    if(!existingMatchesKeys.contains(matchKey)) {
                    Match__c match = new Match__c();
                    match.Job__c = job.Id;
                    match.Candidate__c = candidate.Id;
                    match.Status_Match__c = 'New';
                    match.Match_Score__c = Service_MatchScoring.calculateScore(job, candidate).score; //Calculo de match score
                    matchesToInsert.add(match);
                    }
                }
            }
        }
        return matchesToInsert;
    }

    public static void handleAfterInsertOrUpdate(List<Job__c> jobs, TriggerContext context) {

        List<Candidate__c> candidates = Service_FetchCandidates.getCandidates();

        Map<String, List<Candidate__c>> candidatesByKey = groupCandidatesByKey(candidates);

        Set<Id> jobIds = new Set<Id>();
        Set<Id> candidateIds = getCandidateIds(candidatesByKey);

        for (Job__c job : jobs) {
            jobIds.add(job.Id);
        }

        List<Match__c> existingMatches = Service_FetchExistingMatches.getMatches(jobIds, candidateIds);
        Set<String> existingMatchesKeys = getExistingMatchesKeys(existingMatches);

        List<Match__c> matchesToInsert = buildMatchesToInsert(jobs, candidatesByKey, existingMatchesKeys);

        if(!matchesToInsert.isEmpty()) {
            Util_Security.checkCreateAccess('Match__c');
            insert matchesToInsert;
        }
    }
}