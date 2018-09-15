//-----------------------------
// @author: Paras Dhingra
// @date: 12th Feb 2018
// @description: Test class for OpportunitySplit trigger methods 
// @company: IHS Markit
//-----------------------------

@isTest
private class TestOpportunitySplitMethods {
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 12th Feb 2018
    // @description: Test class for OpportunitySplit trigger method UpdateOpportunityTeamAccess
    // @company: IHS Markit
    // @param: null
    // @return: void
    //-----------------------------
	private static testMethod void TestUpdateOpportunityTeamAccess() {
        //create test data
        User testUser = testUtility.createTestUser('IHSMarkit Data Governance', 'salesUSer345435@test.com', true);
        Account testAccount  = testUtility.createTestAccount('test Account', True );
        Opportunity testOpportunity = testUtility.createOpportunity(testAccount.Id, 'test Opportunity', true);
        
        //create Opportunity split
        Test.startTest();
        
        OpportunitySplit oppySplit = new OpportunitySplit();
        oppySplit.splitOwnerId = testUser.Id;
        oppySplit.OpportunityId = testOpportunity.Id;
        oppySplit.splitPercentage = 0;
        insert oppySplit;
        //Assert Opportunity team member
        List<OpportunityTeamMember> lstAssertOTM = [Select Id,OpportunityAccessLevel from OpportunityTeamMember 
                                                    where OpportunityId=:testOpportunity.Id AND UserId=:testUser.Id];
        System.assertEquals(1, lstAssertOTM.size(), 'Checking team size');
        System.assertEquals('Edit', lstAssertOTM[0].OpportunityAccessLevel, 'Checking Access level');
        Test.stopTest();
	}
	
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 15th Feb 2018
    // @description: Test class for OpportunitySplit trigger method postChatterFeedItem. This method is for coverage only.
    // @company: IHS Markit
    // @param: null
    // @return: void
    //-----------------------------
    private static testMethod void TestPostChatterFeedItem() {
        //cannot assert feedItems as it requires seeAlldata = true and we cannot create mock feedItems for it
        //create test data
        User testUser = testUtility.createTestUser('IHSMarkit Data Governance', 'salesUSer345435@test.com', true);
        Account testAccount  = testUtility.createTestAccount('test Account', True );
        Opportunity testOpportunity = testUtility.createOpportunity(testAccount.Id, 'test Opportunity', true);
        Map<String,Id> mapSplitTypes = UtilityClass.getSplitTypeIds();
        //create Opportunity split
        //createOppySplit(String oppyId, String userId, Decimal splitPercentage,String splitTypeId ,Boolean shouldInsert)
        Test.startTest();
        OpportunitySplit oppySplit = new OpportunitySplit();
        oppySplit = testUtility.createOppySplit(testOpportunity.Id, testUser.Id, 100.00,mapSplitTypes.get('Overlay') ,true);
        
        // check for update and delete scenario
        oppySplit.splitPercentage = 100.00;
        update oppySplit;
        delete oppySplit;
        
        Test.stopTest();
    }
     //-----------------------------
    // @author: Paras Dhingra
    // @date: 28th Feb 2018
    // @description: Test class for OpportunitySplit trigger method autoFollowOpportunityOnInsert
    // @company: IHS Markit
    // @param: null
    // @return: void
    //-----------------------------
    private static testMethod void TestAutoFollowOpportunityOnInsert() {
        User testUser = testUtility.createTestUser('IHSMarkit Data Governance', 'salesUSer345435@test.com', true);
        Account testAccount  = testUtility.createTestAccount('test Account', True );
        Opportunity testOpportunity = testUtility.createOpportunity(testAccount.Id, 'test Opportunity', true);
        Map<String,Id> mapSplitTypes = UtilityClass.getSplitTypeIds();
        //create Opportunity split
        //createOppySplit(String oppyId, String userId, Decimal splitPercentage,String splitTypeId ,Boolean shouldInsert)
        Test.startTest();
        OpportunitySplit oppySplit = new OpportunitySplit();
        oppySplit = testUtility.createOppySplit(testOpportunity.Id, testUser.Id, 100,mapSplitTypes.get('Overlay') ,true);
        List<EntitySubscription> lstAssertEntitySubscription = [Select Id, ParentId, SubscriberId 
                                                                from EntitySubscription 
                                                                where ParentId=:testOpportunity.Id AND SubscriberId=:testUser.Id];
        System.assertEquals(1, lstAssertEntitySubscription.size());
        Test.stopTest();
        
    }
     //-----------------------------
    // @author: Jagadesh Kumar
    // @date: 20th April 2018
    // @description: Test class for OpportunitySplit trigger method validateOverlaySplitAmount
    // @company: IHS Markit
    // @param: null
    // @return: void
    //-----------------------------
    //SFDC1-7578-Due to limitation from SF end commenting this code for now.
    /*private static testMethod void TestValidateOverlaySplitAmount() {
        //create test data
        User testUser = testUtility.createTestUser('IHSMarkit Data Governance', 'salesUSer345435@test.com', true);
        User testUser2 = testUtility.createTestUser('IHSMarkit Data Governance', 'salesUSer3454@test.com', true);
        Account testAccount  = testUtility.createTestAccount('test Account', True );
        Opportunity testOpportunity = testUtility.createOpportunity(testAccount.Id, 'test Opportunity', true);
        Map<String,Id> mapSplitTypes = UtilityClass.getSplitTypeIds();
        //create Opportunity split
        //createOppySplit(String oppyId, String userId, Decimal splitPercentage,String splitTypeId ,Boolean shouldInsert)
        Test.startTest();
        List<OpportunitySplit> opptySplitList = new List<OpportunitySplit>();
        opptySplitList.add(testUtility.createOppySplit(testOpportunity.Id, testUser.Id, 50,mapSplitTypes.get('Overlay') ,false));
        opptySplitList.add(testUtility.createOppySplit(testOpportunity.Id, testUser2.Id, 50,mapSplitTypes.get('Overlay') ,false));
        insert opptySplitList;
        try{
            // check for update 
            OpportunitySplit oppySplit = opptySplitList.get(0);
            oppySplit.splitPercentage = 150;
            update oppySplit;
        }catch(Exception e) {
            System.Assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'));
            System.Assert(e.getMessage().contains('Overlay must be total 100% for an Opportunity Split'));
        }
        
        Test.stopTest();
    }*/
    //-----------------------------
    // @author: Jagadesh Kumar
    // @date: 2nd May 2018
    // @description: Test class for OpportunitySplit trigger method updateOpptySplitTeamName
    // @company: Vertiba
    // @param: null
    // @return: void
    //-----------------------------
    private static testMethod void TestUpdateOpptySplitTeamName() {
        //create test data
        User testUser = testUtility.createTestUser('IHSMarkit Data Governance', 'salesUSer345435@test.com', true);
        Account testAccount  = testUtility.createTestAccount('test Account', True );
        Opportunity testOpportunity = testUtility.createOpportunity(testAccount.Id, 'test Opportunity', true);
        Map<String,Id> mapSplitTypes = UtilityClass.getSplitTypeIds();
        //create Opportunity split
        Test.startTest();
        List<OpportunitySplit> opptySplitList = new List<OpportunitySplit>();
        opptySplitList.add(testUtility.createOppySplit(testOpportunity.Id, testUser.Id, 100,mapSplitTypes.get('Overlay') ,false));
        insert opptySplitList;
        Opportunity oppty = [SELECT AccountManagers__c FROM Opportunity WHERE ID =: testOpportunity.Id];
        System.assertEquals('testFirstName testLastName',oppty.AccountManagers__c);
        Test.stopTest(); 
    }
}