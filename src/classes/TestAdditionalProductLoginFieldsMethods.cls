// @author: Uttam Arya
// @date: 13 April 2018
// @param: NA
// @description: Test class for Additional Account Fields trigger methods 
// @return: NA
//-----------------------------

@isTest
private class TestAdditionalProductLoginFieldsMethods {
    
    //-----------------------------
// @author: Uttam Arya
// @date: 13 April 2018
    // @param: NA
    // @description: SFDC1-6347 Test method for Additional Account Fields trigger methods populateAdditionalFiledsLookupInAccount on insert
    // @return: NA
    //-----------------------------
    private static testMethod void testpopulateAdditionalFieldsLookupInProductLogin() {
        
        Test.startTest();
        
        ProductLogin__c testProductLogin = TestUtility.createProductLogin('populateAdditionalFiledsLookupInAccount@test.com', true);
        
        list <ProductLogin__c> testProductLoginResult = [Select AdditionalProductLoginFields__c, Id from ProductLogin__c where Id = :testProductLogin.Id];
        //Assert if Product Login is inserted
        System.assertEquals(1, testProductLoginResult.size());
        System.assert(testProductLoginResult[0].AdditionalProductLoginFields__c != null);
        
        //Assert if Adiitional Product Login Field is inserted
        list <AdditionalProductLoginFields__c> aucfList = [Select Id from AdditionalProductLoginFields__c where ProductLogin__c = :testProductLogin.Id];
        System.assertEquals(1, aucfList.size());
        System.assertEquals(aucfList[0].Id, testProductLoginResult[0].AdditionalProductLoginFields__c);
        
        Test.stopTest();
        
    }
    
}