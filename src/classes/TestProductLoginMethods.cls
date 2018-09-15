// @author: Uttam Arya
// @date: 13 April 2018
// @param: NA
// @description: Test class for Additional ProductLogin__c Fields trigger methods 
// @return: NA
//-----------------------------

@isTest
private class TestProductLoginMethods {
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 13 April 2018
    // @param: NA
    // @description: SFDC1-6347 Test method for Additional ProductLogin__c Fields trigger method changeProductLoginAdditionalFieldsObjectNameWhenAccountNameChanges on update. 
    //              To test if ProductLogin__c Additional Fields Object Name chnages when ProductLogin__c username Changes
    // @return: NA
    //-----------------------------
    private static testMethod void testchangeProductLoginAdditionalFieldsObjectNameWhenUsernameChanges() {
        
        Test.startTest();
        
        ProductLogin__c testProductLogin = TestUtility.createProductLogin('testchangeProductLoginAdditionalFieldsObjectNameWhenUsernameChanges@test.com', true);
        
        list <ProductLogin__c> testProductLoginResult = [Select AdditionalProductLoginFields__c, Id, AdditionalProductLoginFields__r.Name, username__c from ProductLogin__c where Id = :testProductLogin.Id];
        //Assert if Product Login is inserted
        System.assertEquals(1, testProductLoginResult.size());
        System.assert(testProductLoginResult[0].AdditionalProductLoginFields__c != null);
        
        System.assertEquals(testProductLoginResult[0].AdditionalProductLoginFields__r.Name, testProductLoginResult[0].username__c);
        
        //Update ProductLogin__c Name
        testProductLogin.username__c = 'testchangeProductLoginAdditionalFieldsObjectNameWhenUsernameChanges@test.com2';
        update testProductLogin;
        
        list <ProductLogin__c> testProductLoginResult2 = [Select AdditionalProductLoginFields__c, Id, AdditionalProductLoginFields__r.Name, Name, Username__c  from ProductLogin__c where Id = :testProductLogin.Id];
        //Assert if Additional ProductLogin__c Field name gets updated
        System.assertEquals(testProductLoginResult2[0].AdditionalProductLoginFields__r.Name, testProductLoginResult2[0].username__c);
        
        Test.stopTest();
        
    }


    //-----------------------------
    // @author: Uttam Arya
    // @date: 13 April 2018
    // @param: NA
    // @description: SFDC1-6347 Test method for Additional ProductLogin__c Fields trigger method setProductLoginAdditionalFieldsObject on insert
    // @return: NA
    //-----------------------------
    private static testMethod void testSetAccountAdditionalFieldsObject() {
        
        Test.startTest();
        
        ProductLogin__c testProductLogin = TestUtility.createProductLogin('testSetAccountAdditionalFieldsObject@test.com', true);
        
        list <ProductLogin__c> testProductLoginResult = [Select AdditionalProductLoginFields__c, Id, AdditionalProductLoginFields__r.Name, username__c from ProductLogin__c where Id = :testProductLogin.Id];
        //Assert if Product Login is inserted
        System.assertEquals(1, testProductLoginResult.size());
        System.assert(testProductLoginResult[0].AdditionalProductLoginFields__c != null);
        
        //Assert if Adiitional Product Login Field is inserted
        list <AdditionalProductLoginFields__c> aucfList = [Select Id from AdditionalProductLoginFields__c where ProductLogin__c = :testProductLogin.Id];
        System.assertEquals(1, aucfList.size());
        System.assertEquals(aucfList[0].Id, testProductLoginResult[0].AdditionalProductLoginFields__c);
        
        Test.stopTest();
        
    }
    //-----------------------------
    // @author: Jagadesh Kumar
    // @date: 06 Aug 2018
    // @param: NA
    // @description: SFDC1-9572 Test method for ProductLogin__c trigger method insertPLContactAssociationWhenEmailChanges on update
    // @return: NA
    //-----------------------------
    private static testMethod void testInsertPLContactAssociationWhenEmailChanges() {
        Test.startTest();
        Account a = TestUtility.createTestAccount('Unknown Account', true);
       
        List<ProductLogin__c> plList = new List<ProductLogin__c>();
        ProductLogin__c testProductLogin = TestUtility.createProductLogin('testPLEmail@test.com', false);
        testProductLogin.Email__c = 'testPLEmail@ihsmarkit.com';
        testProductLogin.Source__c = 'Manual';
        testProductLogin.FirstName__c= 'testPLEmail';
        plList.add(testProductLogin);
        
        ProductLogin__c testProductLogin2 = TestUtility.createProductLogin('testPLEmail2@test.com', false);
        testProductLogin2.Email__c = 'testPLEmail2@ihsmarkit.com';
        testProductLogin2.Source__c = 'Manual';
        testProductLogin2.FirstName__c= 'testPLEmail2';
        plList.add(testProductLogin2);
        
        ProductLogin__c testProductLogin3 = TestUtility.createProductLogin('testPLEmail3@test.com', false);
        testProductLogin3.Email__c = 'testPLEmail3@ihsmarkit.com';
        testProductLogin3.Source__c = 'Manual';
        testProductLogin3.FirstName__c= 'testPLEmail3';
        plList.add(testProductLogin3);
        
        insert plList;
        
        List<Contact> conList = new List<Contact>();
        Contact c1 = new Contact();
        c1.firstname = 'Test1';
        c1.lastname = 'Test1';
        c1.Email = 'pl.contactExists@ihsmarkit.com';
        c1.AccountId = a.Id;
        conList.add(c1);
        insert conList;
        
        ProductLoginContactAssociation__c lcAsso = new ProductLoginContactAssociation__c();
        lcAsso.ProductLogin__c = testProductLogin.Id;
        lcAsso.Contact__c = c1.Id;
		insert lcAsso;
        
        testProductLogin.Email__c = 'pl.contactExists@ihsmarkit.com';
        testProductLogin2.Email__c = 'testPLEmailUpdate@test.com';
        testProductLogin3.Email__c = 'pl.contactExists@ihsmarkit.com';
        update plList;
        List<ProductLogin__c> productloginList = [SELECT Id,
                                             (SELECT Contact__c,ProductLogin__c FROM ProductLoginContactAssociations1__r) 
                                             FROM ProductLogin__c];
        System.assertEquals(1,productloginList.get(0).ProductLoginContactAssociations1__r.size());
        System.assertEquals(1,productloginList.get(1).ProductLoginContactAssociations1__r.size());
        System.assertEquals(1,productloginList.get(2).ProductLoginContactAssociations1__r.size());
        Test.stopTest();
    }
}