//-----------------------------
// @author: Prachi Bhasin
// @date: 10th August 2017
// @description: SFDC1-1167  test class for BatchUpdateAccountOwnership and BatchUpdateAccountOwnershipScheduler
// @companyname: Vertiba
// @Last Modified By : Vinod Merwade
// @Last Modified Description : Corrected the Test class according to new validation rules on Opportunity
// @Last Modified Date : 19 Sept 2017
// @Last Modified By : Hemant Shukla
// @Last Modified Description : Removed the dependency of ContractExists__c field based on SFDC1-5701
// @Last Modified Date : 6-Nov-2017
//------------------------------
@isTest
private class TestBatchUpdateAccountOwnership {

    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 10th August 2017
    // @param: NA
    // @description: SFDC1-1167  test method for BatchUpdateAccountOwnership class 
    // @return: NA
    // @lastmodifiedSprint : Sprint 9
    // @lastmodifiedBy : Prachi for SFDC1-1154 validation rule
    // @lastmodified description: Primary Contact roles needs to be created before updating opprtunity to stage 3 and above as per  SFDC1-5782 AND SFDC1-5029
    // @modifiedBy: Ankita Singh on 5th December,2017
	// @modifiedBy : Mohit Modi,11 June 2018, Updating Class as it is failing for 101 Query issue.
    //-----------------------------
    private static testMethod void testBatchUpdateAccountOwnershipClass() {
        //create test Data
        User owner1 = TestUtility.createTestUser('System Administrator','owner1@xyz11abc.com',false);
        User owner2 = TestUtility.createTestUser('System Administrator','owner2@xyz11abc.com',false);
        User owner3 = TestUtility.createTestUser('System Administrator','owner3@xyz11abc.com',false);
        insert new list<user> {owner1,owner2,owner3};
        
        Id standardId = Test.getStandardPricebookId();
        Account testAccount = TestUtility.createTestAccount('Account For Contract', true);
        
        Opportunity testOpportunity1 = TestUtility.createOpportunity(testAccount.Id, 'Closed Lost Opp', false);
        Opportunity testOpportunity2 = TestUtility.createOpportunity(testAccount.Id, 'Open Opp 1', false);
        Opportunity testOpportunity3 = TestUtility.createOpportunity(testAccount.Id, 'Open Opp 2 with Highest amount', false);
        testOpportunity1.Amount = 2000;
        testOpportunity1.ownerId = owner1.Id;
        testOpportunity2.Amount = 100;
        testOpportunity2.ownerId = owner2.Id;
        testOpportunity3.Amount = 1000;
        testOpportunity3.ownerId = owner3.Id;
        Test.startTest();
        insert new list<Opportunity> {testOpportunity1,testOpportunity2,testOpportunity3};
        
        testOpportunity1.StageName = '6L-Closed Lost';
        testOpportunity1.LostReasonCode__c = 'Project completed/cancelled';
        testOpportunity1.LostReasonDescription__c = 'test';
        update testOpportunity1;
        
        Database.QueryLocator QL;
        Database.BatchableContext BC;
        Set<String> closedOpportunityStages = new Set<String>{'6W-Closed Won', '6W-Renewal Won', '6L-Closed Lost'};
        BatchUpdateAccountOwnership batchObj = new BatchUpdateAccountOwnership();
        batchObj.query = 'SELECT Id,Name,OwnerId,Owner.Name,(Select Id, Name,OwnerId,Owner.Name, Amount, StageName from Opportunities where StageName NOT IN: closedOpportunityStages order by Amount DESC limit 1 ) FROM Account where GlobalAccountManager__c =null';
        Id batchId = Database.executeBatch(batchObj, 10);
        Test.stopTest();
        
        Account acc = [Select id,name,ownerId from account where id =: testAccount.Id];        
        System.assert(acc.ownerId==testOpportunity3.ownerId);        
  }
  
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 10th August 2017
    // @param: NA
    // @description: SFDC1-1167  test method for BatchUpdateAccountOwnershipScheduler class 
    // @return: NA
    //-----------------------------
    static testMethod void testBatchUpdateAccountOwnershipScheduler(){
        Test.StartTest();        
        BatchUpdateAccountOwnershipScheduler ba = new BatchUpdateAccountOwnershipScheduler(); //Schedule apex class name
        String sch = '0 0 8 13 2 ?'; //schedule interval time
        String jobId = system.schedule('Run Job for BatchUpdateAccountOwnershipScheduler', sch, ba); //system method to schedule apex class
        System.assert(jobId!=null);
        Test.stopTest();
  }
}