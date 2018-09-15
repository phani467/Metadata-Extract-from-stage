/****************************
 * @author Tran-Vu Tran
 * @date 28th Jun 2017
 * @description Test class for unit testing on Contact Triggers
//----------------------------
************************/

@isTest(seeAllData=false)
private class TestContactTriggers {
    
        static testMethod void TestSyncContactCountryWithCountryChange() {

        // Test data setup
        TestUtility.loadCountryData();
        Contact cont = new Contact(FirstName = 'Test', LastName = 'Contact',
                                   EmailUnknown__c = true, Phone = '2813456789',
                                   MailingStreet='Test street 1',
                                   MailingCity = 'Toronto',
                                   MailingStateCode = 'ON',
                                   MailingCountryCode = 'CA');
        insert cont;

        // Verify that the ContactCountry reference to is Canada
        Contact assertContact1 = [Select Id, ContactCountry__r.Name, ContactCountry__r.CountryCode__c from Contact where Id=: cont.Id];
        System.debug('Contact Country: ' + assertContact1.ContactCountry__r.Name);
        System.debug('Contact Country Code: ' + assertContact1.ContactCountry__r.CountryCode__c);
        System.assertEquals('CA', assertContact1.ContactCountry__r.CountryCode__c, 'Checking contact country code');
            
        // Perform Test on update
        Test.startTest();
        cont.MailingCountryCode = 'IN';
        update cont;
        Test.stopTest();
        
        // Query the contact again to get updated value
        Contact assertContact2 = [Select Id, ContactCountry__c from Contact where Id=: cont.Id];
        Country__c targetCountry = [SELECT Id from Country__c WHERE CountryCode__c = 'IN'];

        // Verify that the ContactCountry reference to is now showing India
        System.assert(assertContact2.ContactCountry__c == targetCountry.Id);
    }
    
    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 25 Sep 2017
    // @param: NA
    // @description: SFDC1-2299 Test method for Additional Contact Fields trigger method setAdditionalContactFieldsObject on insert
    // @return: NA
    //-----------------------------
    private static testMethod void testSetAdditionalContactFieldsObject() {
        
        System.debug('Logging for testSetAdditionalContactFieldsObject');

        Contact testContact = TestUtility.createContact(null, 'Test.SetAdditionalContactFieldsObject@ihsmarkit.com', true,
                                                        'Test', 'SetAdditionalContactFieldsObject');
        System.debug('testContact.Id=' + testContact.Id);
        System.debug('testContact.FirstName=' + testContact.FirstName);
        System.debug('testContact.LastName=' + testContact.LastName);
        
        List <Contact> testContactResult = [Select AdditionalContactFields__c, Id, Name from Contact where Id =: testContact.Id];
        System.debug('testContactResult[0].Id=' + testContactResult[0].Id);
        System.debug('testContactResult[0].Name=' + testContactResult[0].Name);
        System.debug('testContactResult[0].AdditionalContactFields__c=' + testContactResult[0].AdditionalContactFields__c);
        
        //Assert if contact is inserted
        System.assertEquals(1, testContactResult.size());
        System.assert(testContactResult[0].AdditionalContactFields__c != null);
        
        //Assert if Additional Contact Field is inserted
        List <AdditionalContactFields__c> acfList = [Select Id from AdditionalContactFields__c where ContactReference__c =: testContact.Id];
        System.assertEquals(1, acfList.size());
        System.assertEquals(acfList[0].Id, testContactResult[0].AdditionalContactFields__c);
        
    }
    
    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 25 Sep 2017
    // @param: NA
    // @description: SFDC1-2299 Test method for Additional Contact Fields trigger method changeAdditionalContactFieldsObjectNameWhenContactNameChanges on update. 
    //              To test if Contact Additional Fields Object Name chnages when Contact Name Changes
    // @return: NA
    //-----------------------------
    private static testMethod void testChangeAdditionalContactFieldsObjectNameWhenContactNameChanges() {
        
        Contact testContact = TestUtility.createContact(null, 'Test.ChangeAdditionalContactFields@ihsmarkit.com', true,
                                                        'Test', 'ChangeAdditionalContactFields');
        
        list <Contact> testContactResult =
            [Select AdditionalContactFields__c, AdditionalContactFields__r.Name, Id, FirstName, LastName from Contact where Id =: testContact.Id];
        
        //Assert if contact is inserted
        System.assertEquals(1, testContactResult.size());
        System.assert(testContactResult[0].AdditionalContactFields__c != null);
        
        Contact c = testContactResult[0];
        System.assertEquals(c.AdditionalContactFields__r.Name, 'Additional Fields - ' + c.FirstName + ' ' + c.LastName);
        
        //Update Contact Name
        testContact.FirstName = 'Test';
        testContact.LastName = 'ChangeAdditionalContactFields2';
        update testContact;
        
        list <Contact> testContactResult2 =
            [Select AdditionalContactFields__c, AdditionalContactFields__r.Name, Id, FirstName, LastName from Contact where Id =: testContact.Id];
        
        //Assert if Additional Contact Field name gets updated
        Contact c2 = testContactResult2[0];
        System.assertEquals(c2.AdditionalContactFields__r.Name, 'Additional Fields - ' + c2.FirstName + ' ' + c2.LastName);
        
    }
    
    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 25 Sep 2017
    // @param: NA
    // @description: SFDC1-2299 Test method for Additional Contact Fields trigger method deleteAdditionalContactFieldsRecordWhenContactGetsDeleted on Delete. 
    //               To test if Contact Additional Fields Object gets deleted when Contact gets deleted 
    // @return: NA
    //-----------------------------
    private static testMethod void testDeleteAdditionalContactFieldsRecordWhenContactGetsDeleted() {
        
        Contact testContact = TestUtility.createContact(null, 'Test.DeleteAdditionalContactFields@ihsmarkit.com', true,
                                                        'Test', 'DeleteAdditionalContactFields');
        
        list <Contact> testContactResult = [Select AdditionalContactFields__c, Id from Contact where Id =: testContact.Id];
        //Assert if contact is inserted
        System.assertEquals(1, testContactResult.size());
        System.assert(testContactResult[0].AdditionalContactFields__c != null);
        
        //Assert if Adiitional Contact Field is inserted
        AdditionalContactFields__c acf = [Select Id from AdditionalContactFields__c where ContactReference__c =: testContact.Id];
        System.assert(acf != null);
        System.assertEquals(acf.Id, testContactResult[0].AdditionalContactFields__c);
        
        delete testContact;
        
        list <AdditionalContactFields__c> acfList = [Select Id from AdditionalContactFields__c where Id =: acf.Id];
        
        ////Assert if Adiitional Contact Field is deleted
        System.assertEquals(0, acfList.size());
    }
}