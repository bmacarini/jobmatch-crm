public with sharing class ScoreResultDTO {
    public Integer score;
    public String matchMessage;

    public ScoreResultDTO(Integer score, String matchMessage){
        this.score = score;
        this.matchMessage = matchMessage;
    }
}