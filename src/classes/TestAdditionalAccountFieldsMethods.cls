// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: Test class for Additional Account Fields trigger methods 
// @return: NA
//-----------------------------

@isTest
private class TestAdditionalAccountFieldsMethods {
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 25 Aug 2017
    // @param: NA
    // @description: SFDC1-2103 Test method for Additional Account Fields trigger methods populateAdditionalFiledsLookupInAccount on insert
    // @return: NA
    //-----------------------------
    private static testMethod void testpopulateAdditionalFiledsLookupInAccount() {
        
        Account testAccount = TestUtility.createTestAccount('Test subject testpopulateAdditionalFiledsLookupInAccount', true);
        
        list <Account> testAccountResult = [Select AdditionalAccountFields__c, Id from Account where Id = :testAccount.Id];
        //Assert if account is inserted
        System.assertEquals(1, testAccountResult.size());
        System.assert(testAccountResult[0].AdditionalAccountFields__c != null);
        
        //Assert if Adiitional Account Field is inserted
        list <AdditionalAccountFields__c> acfList = [Select Id from AdditionalAccountFields__c where AccountReference__c = :testAccount.Id];
        System.assertEquals(1, acfList.size());
        System.assertEquals(acfList[0].Id, testAccountResult[0].AdditionalAccountFields__c);
        
    }
    
}