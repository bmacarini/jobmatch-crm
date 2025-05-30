public with sharing class Service_MatchScoring {
    public static DTO_ScoreResult calculateScore(Job__c job, Candidate__c candidate) {
        Integer matchScore = 0;
        
        Set<String> jobSkills = new Set<String>();
        Set<String> candidateSkills = new Set<String>();

        List<String> noNullishJobSkillsList = job.Skills__c != null ? job.Skills__c.split(';') : new List<String>();
        List<String> noNullishCandidateSkillsList = candidate.Skills__c != null ? candidate.Skills__c.split(';') : new List<String>();

        for(String jobSkill : noNullishJobSkillsList){
            jobSkills.add(jobSkill.trim());
        }

        for(String candidateSkill : noNullishCandidateSkillsList){
            candidateSkills.add(candidateSkill.trim());
        }

        for(String skill : jobSkills){
            if(candidateSkills.contains(skill)){
                matchScore += 20;
            }
        }

        if(matchScore == 0){
            return  new DTO_ScoreResult(matchScore, 'Sem match entre candidato e vaga');
        } else if(matchScore < 50){
            return new DTO_ScoreResult(matchScore, 'Match baixo entre candidato e vaga');
        } else if(matchScore >= 50 && matchScore <= 89){
            return new DTO_ScoreResult(matchScore, 'Match alto entre candidato e vaga');
        } else {
            return new DTO_ScoreResult(matchScore, 'Match perfeito entre candidato e vaga');
        }
    }
}