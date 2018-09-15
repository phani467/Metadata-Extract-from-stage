// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: Test class for AdditionalContactFields trigger methods 
// @return: NA
//-----------------------------

@isTest
private class TestAdditionalContactFieldsMethods {
    
    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 25 Sep 2017
    // @param: NA
    // @description: SFDC1-2299 Test method for AdditionalContactFields trigger methods populateAdditionalContactFieldsLookupInContact on insert
    // @return: NA
    //-----------------------------
    private static testMethod void testAdditionalContactFieldsLookupInContact() {

        Account testAccount = TestUtility.createTestAccount('Test Account', true);
        Contact testContact = TestUtility.createContact(testAccount.Id, 'Test.ChangeAdditionalContactFields@ihsmarkit.com', true,
                                                        'Test', 'AdditionalContactFields');
        System.debug('testContact.Id=' + testContact.Id);
        System.debug('testContact.FirstName=' + testContact.FirstName);
        System.debug('testContact.LastName=' + testContact.LastName);
        
        List <Contact> testContactResult = [Select AdditionalContactFields__c, Id, Name from Contact where Id =: testContact.Id];
        System.debug('testContactResult[0].Name=' + testContactResult[0].Name);
        System.debug('testContactResult[0].AdditionalContactFields__c=' + testContactResult[0].AdditionalContactFields__c);

        //Assert if Contact is inserted
        System.assertEquals(1, testContactResult.size());
        System.assert(testContactResult[0].AdditionalContactFields__c != null);
        
        //Assert if Additional Contact Field is inserted
        List <AdditionalContactFields__c> acfList = [Select Id from AdditionalContactFields__c where ContactReference__c =: testContact.Id];
		System.debug('acfList.Size()=' + acfList.Size());
        
        System.assertEquals(1, acfList.size());
        System.assertEquals(acfList[0].Id, testContactResult[0].AdditionalContactFields__c);
        
    }
    
}