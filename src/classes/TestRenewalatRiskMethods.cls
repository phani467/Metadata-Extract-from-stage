// @author: Uttam Arya
// @date: 19 Jun 2018
// @param: NA
// @description: Test class for RenewalatRiskTrigger methods 
// @return: NA
//-----------------------------
@isTest
public class TestRenewalatRiskMethods {
	
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 19 Jun 2018
    // @param: NA
    // @description: SFDC1-8545 Test method for RenewalatRiskTrigger method setRiskCustomerContactinOppatRisk() on insert
    // @return: NA
    //-----------------------------
    private static testMethod void testSetRiskCustomerContactinOppatRisk() {
        //Create test account
        Account testAccount = TestUtility.createTestAccount('Test Account 8545', true);
        //Create test Opportunity
        Opportunity testOpp = TestUtility.createOpportunity(testAccount.Id, 'Test Opportunity 8545', true);
        //Create test contacts
        List<Contact> testContactsList = new List<Contact>();
        Contact c1 = TestUtility.createContact(testAccount.Id,'testContact1@email.com',false,'TestFname1','TestLName1');
        Contact c2 = TestUtility.createContact(testAccount.Id,'testContact2@email.com',false,'TestFname2','TestLName2');
        testContactsList.add(c1);
        testContactsList.add(c2);
        if(testContactsList.size() > 0) {
            insert testContactsList;
        }            
        
        Test.startTest();        
        
        //Create test OpportunityContactRole records
        List<OpportunityContactRole> ocrList = new List<OpportunityContactRole>();
        OpportunityContactRole ocr1 = new OpportunityContactRole(OpportunityId=testOpp.Id,ContactId=testContactsList[0].Id,IsPrimary=true);
        OpportunityContactRole ocr2 = new OpportunityContactRole(OpportunityId=testOpp.Id,ContactId=testContactsList[1].Id,IsPrimary=false);
        ocrList.add(ocr1);
        ocrList.add(ocr2);
        if(ocrList.size()>0) {
            insert ocrList;
        }            
        
        //Create Opportunity at Risk records
        RenewalatRisk__c testRaR = new RenewalatRisk__c(OpportunityAtRisk__c=testOpp.Id,Status__c='Open - Pending Resolution',RiskProbability__c=12,Comments__c='Test Comments',EstimatedValueatRisk__c=100);
        insert testRaR;
        System.assertEquals(testContactsList[0].Id,[Select RiskCustomerContact__c From RenewalatRisk__c Where Id =:testRaR.Id].RiskCustomerContact__c);
        
        Test.stopTest();        
    }
}