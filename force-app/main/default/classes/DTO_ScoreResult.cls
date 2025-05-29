public with sharing class DTO_ScoreResult {
    public Integer score;
    public String matchMessage;

    public ScoreResultDTO(Integer score, String matchMessage){
        this.score = score;
        this.matchMessage = matchMessage;
    }
}