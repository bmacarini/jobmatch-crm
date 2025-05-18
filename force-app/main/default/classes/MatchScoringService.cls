public with sharing class MatchScoringService {
    public static Integer calculateScore(Job__c job, Candidate__c candidate) {
        score = 0;

        if(job.Title__c == candidate.Desired_Job__c) {
            score += 25;
        }

        if(job.Experience_Level__c == candidate.Experience_Level__c) {
            score += 25;
        }

        String locationKey = job.Remote__c != 'Yes' ? job.Location__c : job.Remote__c;

        if(job.locationKey == candidate.locationKey) {
            score += 25;
        }

        return score;


    }
}