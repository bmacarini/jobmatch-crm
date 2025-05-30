/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_Service_MatchScoring {

    @isTest
    static void noMatchTest() {
        Job__c testJob = new Job__c();
        testJob.Position__c = 'Software Engineer';
        testJob.Company__c = 'Test Company';
        testJob.Location__c = 'San Francisco';
        testJob.Skills__c = 'Java;Apex;Salesforce;JavaScript;HTML';
        testJob.Offered_Salary__c = 120000;
        testJob.Is_Remote__c = 'Yes';
        testJob.Experience_Level__c = 'Mid';
        insert testJob;

        Candidate__c testCandidate = new Candidate__c();
        testCandidate.Position__c = 'Software Engineer';
        testCandidate.Location__c = 'San Francisco';
        testCandidate.First_Name__c = 'John';
        testCandidate.Last_Name__c = 'Doe';
        testCandidate.Email__c = 'teste@test.com';
        testCandidate.Experience_Level__c = 'Mid';
        testCandidate.Resume_URL__c = 'http://example.com/resume.pdf';
        testCandidate.Skills__c = 'Python;C++;Ruby;Go;Swift';
        testCandidate.Is_Remote__c = 'Yes';
        insert testCandidate;

        DTO_ScoreResult result = Service_MatchScoring.calculateScore(testJob, testCandidate);

        System.assertEquals(0, result.score, 'Expected score to be 0 for no matching skills');
        System.assertEquals('Sem match entre candidato e vaga', result.matchMessage, 'Expected match message for no match');
    }

    @isTest
    static void lowMatchTest() {
        Job__c testJob = new Job__c();
        testJob.Position__c = 'Software Engineer';
        testJob.Company__c = 'Test Company';
        testJob.Location__c = 'San Francisco';
        testJob.Skills__c = 'Java;Apex;Salesforce;JavaScript;HTML';
        testJob.Offered_Salary__c = 120000;
        testJob.Is_Remote__c = 'Yes';
        testJob.Experience_Level__c = 'Mid';
        insert testJob;

        Candidate__c testCandidate = new Candidate__c();
        testCandidate.Position__c = 'Software Engineer';
        testCandidate.Location__c = 'San Francisco';
        testCandidate.First_Name__c = 'John';
        testCandidate.Last_Name__c = 'Doe';
        testCandidate.Email__c = 'teste@test.com';
        testCandidate.Experience_Level__c = 'Mid';
        testCandidate.Resume_URL__c = 'http://example.com/resume.pdf';
        testCandidate.Skills__c = 'Java;Apex;Ruby;Go;Swift';
        testCandidate.Is_Remote__c = 'Yes';
        insert testCandidate;

        DTO_ScoreResult result = Service_MatchScoring.calculateScore(testJob, testCandidate);

        System.assertEquals(40, result.score, 'Expected score to be 40% for matching skills');
        System.assertEquals('Match baixo entre candidato e vaga', result.matchMessage, 'Expected match message for low match');
    }

    @isTest
    static void highMatchTest() {
        Job__c testJob = new Job__c();
        testJob.Position__c = 'Software Engineer';
        testJob.Company__c = 'Test Company';
        testJob.Location__c = 'San Francisco';
        testJob.Skills__c = 'Java;Apex;Salesforce;JavaScript;HTML';
        testJob.Offered_Salary__c = 120000;
        testJob.Is_Remote__c = 'Yes';
        testJob.Experience_Level__c = 'Mid';
        insert testJob;

        Candidate__c testCandidate = new Candidate__c();
        testCandidate.Position__c = 'Software Engineer';
        testCandidate.Location__c = 'San Francisco';
        testCandidate.First_Name__c = 'John';
        testCandidate.Last_Name__c = 'Doe';
        testCandidate.Email__c = 'teste@test.com';
        testCandidate.Experience_Level__c = 'Mid';
        testCandidate.Resume_URL__c = 'http://example.com/resume.pdf';
        testCandidate.Skills__c = 'Java;Apex;Salesforce;JavaScript;Swift';
        testCandidate.Is_Remote__c = 'Yes';
        insert testCandidate;

        DTO_ScoreResult result = Service_MatchScoring.calculateScore(testJob, testCandidate);

        System.assertEquals(80, result.score, 'Expected score to be 80% for matching skills');
        System.assertEquals('Match alto entre candidato e vaga', result.matchMessage, 'Expected match message for high match');
    }

    @isTest
    static void perfectMatchTest() {
        Job__c testJob = new Job__c();
        testJob.Position__c = 'Software Engineer';
        testJob.Company__c = 'Test Company';
        testJob.Location__c = 'San Francisco';
        testJob.Skills__c = 'Java;Apex;Salesforce;JavaScript;HTML';
        testJob.Offered_Salary__c = 120000;
        testJob.Is_Remote__c = 'Yes';
        testJob.Experience_Level__c = 'Mid';
        insert testJob;

        Candidate__c testCandidate = new Candidate__c();
        testCandidate.Position__c = 'Software Engineer';
        testCandidate.Location__c = 'San Francisco';
        testCandidate.First_Name__c = 'John';
        testCandidate.Last_Name__c = 'Doe';
        testCandidate.Email__c = 'teste@test.com';
        testCandidate.Experience_Level__c = 'Mid';
        testCandidate.Resume_URL__c = 'http://example.com/resume.pdf';
        testCandidate.Skills__c = 'Java;Apex;Salesforce;JavaScript;HTML';
        testCandidate.Is_Remote__c = 'Yes';
        insert testCandidate;

        DTO_ScoreResult result = Service_MatchScoring.calculateScore(testJob, testCandidate);

        System.assertEquals(100, result.score, 'Expected score to be 100% for matching skills');
        System.assertEquals('Match perfeito entre candidato e vaga', result.matchMessage, 'Expected match message for perfect match');
    }
}