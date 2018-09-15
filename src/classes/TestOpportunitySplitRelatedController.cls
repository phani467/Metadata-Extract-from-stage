/**
 * @Author: Paras Dhingra
 * @Date: 01st Nov 2017
 * @Description: SFDC1-692 test class for OpportunitySplitRelatedController 
 * @company: IHS Markit
 */

@isTest
private class TestOpportunitySplitRelatedController {

    /**
     * @author: Paras Dhingra
     * @date: 01st Nov 2017
     * @description: Test OpportunitySplitRelatedController
     * @param: null
     * @return: void
     * @company: IHS Markit
     */
	private static testMethod void testOppySplits() {
	    // create test user
	    User testUser1 = TestUtility.createTestUser('IHSMarkit Data Governance', 'test@test.com.ihsmarkit2342323', true);
	    User testUser2 = TestUtility.createTestUser('IHSMarkit Data Governance', 'test@test.com.ihsmarkit23432', true);
        // create test data
        Account testAccount = TestUtility.createTestAccount('Test account1', true);
        Opportunity testOppy = TestUtility.createOpportunity(testAccount.Id, 'Test Oppy',true);
        
        Test.startTest();
        // get Map of Opportunity Split types
        Map<String,Id> mapSplitTypes = OpportunitySplitRelatedController.getSplitTypeIds();
        String overlayId = mapSplitTypes.get('Overlay');
        OpportunitySplit testOppySplit = TestUtility.createOppySplit(testOppy.Id, testUser1.Id,100.00,overlayId, true);
        //Assert get Opportunity Splits
        OpportunitySplitRelatedController.OppySplitWrapper assertOppySplits = OpportunitySplitRelatedController.getRelatedOppySplits(testOppy.Id);
        System.assertEquals(2,assertOppySplits.oppy.OpportunitySplits.size());
        
        //Modify Overlay Splits and assert them
        List<OpportunitySplit> overlaySplits = new List<OpportunitySplit>();
        // it will give range overflow error
        testOppySplit.splitPercentage = 50000;
        overlaySplits.add(testOppySplit);
        OpportunitySplitRelatedController.OppySplitResultWrapper assertOverlaySplits = OpportunitySplitRelatedController.saveOverlaySplits(overlaySplits,testOppy.Id, null);
        System.assert(assertOverlaySplits.message.containsIgnoreCase('Error occurred'),assertOverlaySplits.message);
        
        //test positive case
        OpportunitySplit testOppySplit2 = TestUtility.createOppySplit(testOppy.Id, testUser2.Id,50,overlayId, false);
        overlaySplits[0].splitPercentage = 50;
        overlaySplits.add(testOppySplit2);
        assertOverlaySplits = OpportunitySplitRelatedController.saveOverlaySplits(overlaySplits,testOppy.Id, null);
        System.assert(assertOverlaySplits.message.containsIgnoreCase('Splits updated successfully'),assertOverlaySplits.message);
        
        //Modify revenue splits and assert them
        String revenueId = mapSplitTypes.get('Revenue');
        OpportunitySplit testOppySplitRev1 = TestUtility.createOppySplit(testOppy.Id, testUser1.Id,1,revenueId, false);
        List<OpportunitySplit> lstOppySplitRev = new List<OpportunitySplit>();
        for(OpportunitySplit os : assertOppySplits.oppy.OpportunitySplits) {
            
            if(os.SplitTypeId ==revenueId) {
                lstOppySplitRev.add(os);
            }
        }
        lstOppySplitRev.add(testOppySplitRev1);
        
        //assert negative case
        OpportunitySplitRelatedController.OppySplitResultWrapper assertRevenueSplits = OpportunitySplitRelatedController.saveRevenueSplits(lstOppySplitRev,testOppy.Id);
        System.assert(assertRevenueSplits.message.containsIgnoreCase('Error occurred'),assertRevenueSplits.message);
        
        
        //assert positive case
        lstOppySplitRev[0].splitPercentage = 50;
        lstOppySplitRev[1].splitPercentage = 50;
        assertRevenueSplits = OpportunitySplitRelatedController.saveRevenueSplits(lstOppySplitRev,testOppy.Id);
        System.assert(assertRevenueSplits.message.containsIgnoreCase('Splits updated successfully'),assertRevenueSplits.message);
        
        
        Test.stopTest();
	}

}