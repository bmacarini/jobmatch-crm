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
private class Test_Handler_JobTrigger {

    @isTest
    static void newJobAdded() {
        Candidate__c testCandidate = new Candidate__c();
        testCandidate.Position__c = 'Salesforce Developer';
        testCandidate.Location__c = 'San Francisco';
        testCandidate.First_Name__c = 'John';
        testCandidate.Last_Name__c = 'Doe';
        testCandidate.Email__c = 'test@test.com';
        testCandidate.Experience_Level__c = 'Mid';
        testCandidate.Resume_URL__c = 'http://example.com/resume.pdf';
        testCandidate.Skills__c = 'Apex;LWC;Visualforce;SOQL;Aura Components';
        testCandidate.Is_Remote__c = 'Yes';
        insert testCandidate;

        Job__c testJob = new Job__c();
        testJob.Position__c = 'Salesforce Developer';
        testJob.Company__c = 'Test Company';
        testJob.Location__c = 'San Francisco';
        testJob.Skills__c = 'Apex;LWC;Visualforce;SOQL;HTML';
        testJob.Offered_Salary__c = 120000;
        testJob.Is_Remote__c = 'Yes';
        testJob.Experience_Level__c = 'Mid';

        test.startTest();
        insert testJob;
        test.stopTest();

        String expectedKey = testJob.Id + '|' + testCandidate.Id;

        List<Match__c> result = [SELECT Id, Job__c, Candidate__c, Status_Match__c, Match_Score__c, JobCandidateUniqueKey__c
                                  FROM Match__c 
                                  WHERE JobCandidateUniqueKey__c = :expectedKey];
        
        System.assertEquals(1, result.size(), 'Expected one match to be created');
        System.assertEquals('New', result[0].Status_Match__c, 'Expected status match');
        System.assertEquals(80, result[0].Match_Score__c, 'Expected match score');
    }

    @isTest
    static void noMatchFound() {
        Candidate__c testCandidate = new Candidate__c();
        testCandidate.Position__c = 'Salesforce Developer';
        testCandidate.Location__c = 'San Francisco';
        testCandidate.First_Name__c = 'John';
        testCandidate.Last_Name__c = 'Doe';
        testCandidate.Email__c = 'test@test.com';
        testCandidate.Experience_Level__c = 'Mid';
        testCandidate.Resume_URL__c = 'http://example.com/resume.pdf';
        testCandidate.Skills__c = 'Apex;LWC;Visualforce;SOQL;Aura Components';
        testCandidate.Is_Remote__c = 'Yes';
        insert testCandidate;

        Job__c testJob = new Job__c();
        testJob.Position__c = 'Salesforce Administrator';
        testJob.Company__c = 'Test Company';
        testJob.Location__c = 'San Francisco';
        testJob.Skills__c = 'Flows;Permission Sets;Reports and Dashboards;Process Builder;Data Loader';
        testJob.Offered_Salary__c = 120000;
        testJob.Is_Remote__c = 'Yes';
        testJob.Experience_Level__c = 'Mid';

        test.startTest();
        insert testJob;
        test.stopTest();

        String expectedKey = testJob.Id + '|' + testCandidate.Id;

        List<Match__c> result = [SELECT Id, Job__c, Candidate__c, Status_Match__c, Match_Score__c, JobCandidateUniqueKey__c 
                                  FROM Match__c 
                                  WHERE JobCandidateUniqueKey__c = :expectedKey];
        
        System.assertEquals(0, result.size(), 'No match must be created');
    }

    @isTest
    static void noDuplicatedMatch() {

        Candidate__c testCandidate = new Candidate__c();
        testCandidate.Position__c = 'Salesforce Developer';
        testCandidate.Location__c = 'San Francisco';
        testCandidate.First_Name__c = 'John';
        testCandidate.Last_Name__c = 'Doe';
        testCandidate.Email__c = 'test@test.com';
        testCandidate.Experience_Level__c = 'Mid';
        testCandidate.Resume_URL__c = 'http://example.com/resume.pdf';
        testCandidate.Skills__c = 'Apex;LWC;Visualforce;SOQL;Aura Components';
        testCandidate.Is_Remote__c = 'Yes';
        insert testCandidate;

        Job__c testJob = new Job__c();
        testJob.Position__c = 'Salesforce Developer';
        testJob.Company__c = 'Test Company';
        testJob.Location__c = 'San Francisco';
        testJob.Skills__c = 'Apex;LWC;Visualforce;SOQL;HTML';
        testJob.Offered_Salary__c = 120000;
        testJob.Is_Remote__c = 'Yes';
        testJob.Experience_Level__c = 'Mid';
        insert testJob;

        test.startTest();
        testJob.Offered_Salary__c = 150000;
        update testJob;
        test.stopTest();

        List<Match__c> result = [SELECT Id, Job__c, Candidate__c, Status_Match__c, Match_Score__c 
                                  FROM Match__c 
                                  WHERE Job__c = :testJob.Id AND Candidate__c = :testCandidate.Id
                                  ];
        
        System.assertEquals(1, result.size(), 'Expected no duplicated match to be created');
    }
}