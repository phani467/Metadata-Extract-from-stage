//-----------------------------
// @author Paras Dhingra adapted from Tran's code
// @date 28th Jun 2017
// @description Test class for unit testing on Account Triggers
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 15 March 2018
// @Last Modified Description: SFDC1-7199 - Commenting code related to NAICS hierarchy (TestNAICSUpdate method)
// @Last Modified By : Tran-Vu Tran
// @Last Modified Date : 12nd April 2018
// @Last Modified Description : SFDC1-7718 add method to update child accounts' Compliance Restriction value from Parent account if Exception is not checked
// @Last Modified By : Harshit Singhal
// @Last Modified Date : 12 Jun 2018
// @Last Modified Description : SFDC1-8537 convert Account process builder flows to Trigger
//-----------------------------

@isTest(seeAllData=false)
private class TestAccountMethods {    
    
    static testMethod void TestSyncAccountCountryWithCountryChange() {
        // Test data setup
        TestUtility.loadCountryData();
        Account acct = TestUtility.createTestAccount('Test Sync Country', true);
        
        // Verify that the AccountCountry reference to is Canada
        Account assertAccount1 = [Select Id, AccountCountry__r.Name, AccountCountry__r.CountryCode__c from Account where Id=: acct.Id];
        System.debug('TestSyncAccountCountryWithCountryChange method: Account Country Name=' + assertAccount1.AccountCountry__r.Name
                    + ', Account Country Code=' + assertAccount1.AccountCountry__r.CountryCode__c);
        // System.assertEquals('CA', assertAccount1.AccountCountry__r.Name, 'Checking account country name');
        System.assertEquals('CA', assertAccount1.AccountCountry__r.CountryCode__c, 'Checking account country code');
        
        // Perform Test on update
        Test.startTest();
        //acct.BillingCountry = 'India';
        acct.BillingCountryCode = 'IN';
        update acct;
        Test.stopTest();
        
        // Query the account again to get updated value
        Account assertAccount2 = [Select Id, AccountCountry__c from Account where Id=: acct.Id];
        
        // Country__c targetCountry = [SELECT Id from Country__c WHERE Name = 'India'];
        Country__c targetCountry = [SELECT Id from Country__c WHERE CountryCode__c = 'IN'];
        
        // Verify that the AccountCountry reference to is now showing India
        System.assert(assertAccount2.AccountCountry__c == targetCountry.Id);
    }
    
    //-----------------------------
    // @author Paras Dhingra
    // @Date 05 Jul 2017
    // @description Test class for AccountMethods.updateNAICSHierarchyLookup()
    // @param null
    // @return void
    //-----------------------------
    /*static testMethod void TestNAICSUpdate() {
        
        //create test Data
        Account acct = TestUtility.createTestAccount('Test Account', true);
        NAICSHierarchy__c testNaics = TestUtility.createNAICSData('1111','Agriculture, Forestry, Fishing and Hunting','Oilseed and Grain Farming',true);
        
        //start test
        Test.startTest();
        acct.NaicsCode = '111134';
        update acct;
        Test.stopTest();
        
        //assert 
        Account assertAcct = [Select Id, NAICSHierarchy__c from Account where id=:acct.Id];
        System.assertEquals(testNaics.Id, assertAcct.NAICSHierarchy__c, 'comparing NAICS');
    }*/
    
    //-----------------------------
    // @author Paras Dhingra
    // @Date 07 Jul 2017
    // @description Test class for Accountmethods.updateGAMOnOpenOppys
    // @param null
    // @return void
    //-----------------------------
    static testMethod void TestupdateGAMonOpenOppys() {
        
        User testGAM;
        System.runAs(new User(Id=userInfo.getUserId())) {
            testGAM = TestUtility.createAdminUser('parastest=example@test.com', true);
        }
        //create test data
        Account acct = TestUtility.createTestAccount('Test Account', false);
        acct.DataGovernanceStatus__c = 'Approved';
        insert acct;
        
        Opportunity oppy1 = new Opportunity();
        oppy1.AccountId = acct.Id;
        oppy1.Name = 'Test Oppy 1';
        oppy1.StageName= '1-Sales Qualified';
        oppy1.CloseDate = Date.today()+2;
        insert oppy1;
        
        Opportunity oppy2 = new Opportunity();
        oppy2.AccountId = acct.Id;
        oppy2.Name = 'Test Oppy 2';
        oppy2.StageName = '1-Sales Qualified';
        oppy2.CloseDate = Date.today()+2;
        insert oppy2;
        
        //add product to oppy2
        
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(oppy2.Id, testPBE, true);
        //Start test
        
        //close oppy 2.
        Test.startTest();
        oppy2.LostReasonCode__c = 'Customer Requirements Changed';
        oppy2.LostReasonDescription__c = 'Test description';
        oppy2.StageName = '6L-Closed Lost';
        update oppy2;
        
        //update GAM on account
        acct.GlobalAccountManager__c = testGAM.Id;
        update acct;
        //assert Opportunities
        Map<Id, Opportunity> mapAssertOppys = new Map<Id, Opportunity>([Select id, GAM__c from Opportunity where id=:oppy1.ID OR id=:oppy2.Id]);
        
        //assert Oppy1
        System.assertEquals(testGAM.Id, mapAssertOppys.get(oppy1.Id).GAM__c);
        System.assertEquals(null, mapAssertOppys.get(oppy2.Id).GAM__c);
        Test.stopTest();
    }
    
    //-----------------------------
    // @author Paras Dhingra
    // @Date 26 Jul 2017
    // @description Test class for Accountmethods.updateLegacyIdObject
    // @param null
    // @return void
    //-----------------------------
    static testMethod void testUpdateLegacyIdObject() {
		/* 2017-09-19 Tran-Vu Tran comment out because this is no longer needed per SFDC1-4517 
        Test.startTest();
        Account testAccount = TestUtility.createTestAccount('Test Account', false);
        testAccount.MarkitSFDC__c = 'A-11002';
        testAccount.IHSCRMGUID__c = 'IHS-23423';
        insert testAccount;
        // assert
        List<LegacyAccountID__c> assertLAI = [Select name from LegacyAccountID__c where Account__c=:testAccount.Id order by name];
        System.assertEquals(2, assertLAI.size(), 'two child records');
        System.assertEquals(testAccount.MarkitSFDC__c, assertLAI[0].name,'matching markit Id');
        System.assertEquals(testAccount.IHSCRMGUID__c, assertLAI[1].name,'matching IHS Id');
		*/
    }
    
    //-----------------------------
    // @author Paras Dhingra
    // @Date 1st Aug 2017
    // @description Test class for Accountmethods.updateAccountTeamMemberRole
    // @param null
    // @return void
    // @companyName IHS Markit
    //-----------------------------
    static testMethod void testUpdateAccountTeamMemberRole() {
        //create test data
        
        User testUser1 = TestUtility.createTestUser('IHSMarkit Data Governance', 'testUSer.testuser123@ihsmarkit.com.user',true);
        User testUser2 = TestUtility.createTestUser('IHSMarkit Data Governance', 'testUser.test22343@ihsmarkit.com.usertest',true);
        System.runAs(testUser1) {
            Test.startTest();
            Account acct = TestUtility.createTestAccount('Test Account', true);
            List<AccountTeamMember> lstAssertATM = [Select id,UserId from AccountTeamMember where  teamMemberRole = 'Account Owner' and accountId=:acct.Id];
            System.assertNotEquals(null, lstAssertATM,'Account Team member role created');
            System.assertEquals(testUser1.Id, lstAssertATM[0].userId);
            
            //update account owner
            acct.ownerId = testUser2.Id;
            update acct;
            lstAssertATM = [Select id,UserId from AccountTeamMember where  teamMemberRole = 'Account Owner' and accountId=:acct.Id];
            System.assertNotEquals(null, lstAssertATM,'Account Team member role created');
            System.assertEquals(testUser2.Id, lstAssertATM[0].userId);
            Test.stopTest();
        }
    }
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 25 Aug 2017
    // @param: NA
    // @description: SFDC1-2103 Test method for Additional Account Fields trigger method setAccountAdditionalFieldsObject on insert
    // @return: NA
    //-----------------------------
    private static testMethod void testSetAccountAdditionalFieldsObject() {
        
        Account testAccount = TestUtility.createTestAccount('TestSetAccountAdditionalFieldsObject', true);
        
        list <Account> testAccountResult = [Select AdditionalAccountFields__c, Id from Account where Id = :testAccount.Id];
        //Assert if account is inserted
        System.assertEquals(1, testAccountResult.size());
        System.assert(testAccountResult[0].AdditionalAccountFields__c != null);
        
        //Assert if Adiitional Account Field is inserted
        list <AdditionalAccountFields__c> acfList = [Select Id from AdditionalAccountFields__c where AccountReference__c = :testAccount.Id];
        System.assertEquals(1, acfList.size());
        System.assertEquals(acfList[0].Id, testAccountResult[0].AdditionalAccountFields__c);
        
    }
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 25 Aug 2017
    // @param: NA
    // @description: SFDC1-2103 Test method for Additional Account Fields trigger method changeAccountAdditionalFieldsObjectNameWhenAccountNameChanges on update. 
    //              To test if Account Additional Fields Object Name chnages when Account Name Changes
    // @return: NA
    //-----------------------------
    private static testMethod void testChangeAccountAdditionalFieldsObjectNameWhenAccountFieldChanges() {
        
        Account testAccount = TestUtility.createTestAccount('TestChangeAccountAdditionalFields', true);
        
        list <Account> testAccountResult = [Select AdditionalAccountFields__c, AdditionalAccountFields__r.Name, Id, Name  from Account where Id = :testAccount.Id];
        //Assert if account is inserted
        System.assertEquals(1, testAccountResult.size());
        System.assert(testAccountResult[0].AdditionalAccountFields__c != null);
        
        System.assertEquals(testAccountResult[0].AdditionalAccountFields__r.Name, 'Additional Fields - ' + testAccountResult[0].Name);
        
        //Update Account Name
        testAccount.Name = 'TestChangeAccountAdditionalFields2';
        update testAccount;
        
        list <Account> testAccountResult2 = [Select AdditionalAccountFields__c, AdditionalAccountFields__r.Name, Id, Name  from Account where Id = :testAccount.Id];
        //Assert if Additional Account Field name gets updated
        System.assertEquals(testAccountResult2[0].AdditionalAccountFields__r.Name, 'Additional Fields - ' + testAccountResult2[0].Name);
        
    }

/*
	// 20-April-2016 comment out codes - will be replaced by formula fields
    //-----------------------------
    // @author: Tran-Vu Tran
    // @created: 10 April 2018
    // @param: NA
    // @description: Test if Account ComplianceRestrictions 
    // @return: NA
    //-----------------------------
    static testMethod void TestAccountComplianceRestrictions() {

        Test.startTest();
        
        List<Account> testAccounts = new List<Account>();
        
        Account acc1 = TestUtility.createTestAccountWithStreet('One', 'Street One', true);
        acc1.ComplianceRestrictions__c = 'Russia Directive 1; Payment terms not > 14 days';
        acc1.CorporateRestrictionException__c = false;
        // testAccounts.add(acc1);
        update acc1;
        System.debug('Account Name: ' + acc1.Name + ', ID: ' + acc1.Id);
        System.debug('Compliance Restrictions: ' + acc1.ComplianceRestrictions__c + ', Exception: ' + acc1.CorporateRestrictionException__c);
        
        Account acc2 = TestUtility.createTestAccountWithStreet('Two', 'Lane Two', true);
        acc2.ParentId = acc1.Id;
        acc2.CorporateRestrictionException__c = false;
        acc2.ComplianceRestrictions__c = null;
        // testAccounts.add(acc2);
        update acc2;
        acc2 = [select Id, Name, ParentId, CorporateRestrictionException__c, ComplianceRestrictions__c
				From Account where Id =: acc2.Id limit 1];
        
        System.debug('Account Name: ' + acc2.Name + ', ID: ' + acc2.Id);
        System.debug('Compliance Restrictions: ' + acc2.ComplianceRestrictions__c + ', Exception: ' + acc2.CorporateRestrictionException__c);
        System.debug('Parent account Name: ' + acc1.Name + ', ID: ' + acc2.ParentId);
        System.debug('Parent Compliance Restrictions: ' + acc1.ComplianceRestrictions__c + ', Parent Exception: ' + acc1.CorporateRestrictionException__c);

        Account acc3 = TestUtility.createTestAccountWithStreet('Three', 'Blvd Three', true);
        acc3.ParentId = acc1.Id;
        acc3.CorporateRestrictionException__c = true;
        acc3.ComplianceRestrictions__c = null;
        // testAccounts.add(acc3);
        update acc3;
        acc3 = [select Id, Name, ParentId, CorporateRestrictionException__c, ComplianceRestrictions__c
				From Account where Id =: acc3.Id limit 1];
        
        System.debug('Account Name: ' + acc3.Name + ', ID: ' + acc3.Id);
        System.debug('Compliance Restrictions: ' + acc3.ComplianceRestrictions__c + ', Exception: ' + acc3.CorporateRestrictionException__c);
        System.debug('Parent account Name: ' + acc1.Name + ', ID: ' + acc3.ParentId);
        System.debug('Parent Compliance Restrictions: ' + acc1.ComplianceRestrictions__c + ', Parent Exception: ' + acc1.CorporateRestrictionException__c);
        
        Account acc4 = TestUtility.createTestAccountWithStreet('Four', 'Drive Four', true);
        acc4.ParentId = acc3.Id;
        acc4.CorporateRestrictionException__c = false;
        acc4.ComplianceRestrictions__c = null;
        // testAccounts.add(acc4);
        update acc4;
        acc4 = [select Id, Name, ParentId, CorporateRestrictionException__c, ComplianceRestrictions__c
				From Account where Id =: acc4.Id limit 1];
        
        System.debug('Account Name: ' + acc4.Name + ', ID: ' + acc4.Id);
        System.debug('Compliance Restrictions: ' + acc4.ComplianceRestrictions__c + ', Exception: ' + acc4.CorporateRestrictionException__c);
        System.debug('Parent account Name: ' + acc3.Name + ', ID: ' + acc4.ParentId);
        System.debug('Parent Compliance Restrictions: ' + acc3.ComplianceRestrictions__c + ', Parent Exception: ' + acc3.CorporateRestrictionException__c);
        
        // update testAccounts;

        System.assertEquals(acc2.ComplianceRestrictions__c, acc1.ComplianceRestrictions__c);
        System.assertNotEquals(acc3.ComplianceRestrictions__c, acc1.ComplianceRestrictions__c);
        System.assertEquals(acc4.ComplianceRestrictions__c, acc1.ComplianceRestrictions__c);

        Test.stopTest();
    }
*/
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 25 Aug 2017
    // @param: NA
    // @description: SFDC1-2103 Test method for Additional Account Fields trigger method deleteAccountAdditionalFieldsRecordWhenAccountGetsDeleted on Delete. 
    //               To test if Account Additional Fields Object gets deleted when Account gets deleted 
    // @return: NA
    //-----------------------------
    private static testMethod void testdeleteAccountAdditionalFieldsRecordWhenAccountGetsDeleted() {
        
        Account testAccount = TestUtility.createTestAccount('TestSetAccountAdditionalFieldsObject', true);
        
        list <Account> testAccountResult = [Select AdditionalAccountFields__c, Id from Account where Id = :testAccount.Id];
        //Assert if account is inserted
        System.assertEquals(1, testAccountResult.size());
        System.assert(testAccountResult[0].AdditionalAccountFields__c != null);
        
        //Assert if Adiitional Account Field is inserted
        AdditionalAccountFields__c acf = [Select Id from AdditionalAccountFields__c where AccountReference__c = :testAccount.Id];
        System.assert(acf != null);
        System.assertEquals(acf.Id, testAccountResult[0].AdditionalAccountFields__c);
        
        delete testAccount;
        
        list <AdditionalAccountFields__c> acfList = [Select Id from AdditionalAccountFields__c where Id = :acf.Id];
        
        ////Assert if Adiitional Account Field is deleted
        System.assertEquals(0, acfList.size());
    }
    
    //-----------------------------
    // @author Harshit Singhal
    // @Date 12 Jun 2018
    // @description Test class for AccountMethods.updateAccountCreatedOnParentCase()
    // @param null
    // @return void
    // @Lastmodified by : Mohit Modi
    // @lastmodified description : Added some more values to new Account co cover the changes in existing methods.
    //-----------------------------
    static testMethod void testUpdateAccountCreatedOnParentCase() {        
        TestUtility.loadCountryData();
        Account testAcc = TestUtility.createTestAccount('Test Account 123', true);
        Contact testContact = TestUtility.createContact(testAcc.Id, 'testContact@ihsmarkit.com', true, 'Test FirstName', 'Test LastName');
        Id caseRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Salesforce Helpdesk').getRecordTypeId();
        Case sourceCase = TestUtility.createCase(caseRecordTypeId, testAcc.Id, testContact.Id, UserInfo.getUserId(), 'Test Subject', false);
        sourceCase.Country__c = [SELECT Id from Country__c WHERE CountryCode__c = 'IN'].id;
        insert sourceCase;
        Test.startTest();
        Account newAcc = TestUtility.createTestAccount('Test Account 456', false);
        newAcc.BillingCity = 'Bangalore';
        newAcc.State__c = 'KA';
        newAcc.SourceCase__c = sourceCase.Id;
        Country__c tempCountry = [SELECT Id from Country__c WHERE CountryCode__c = 'IN' limit 1];
        newAcc.AccountCountry__c = tempCountry != NULL ? tempCountry.id : NULL;
        insert newAcc;
        System.assertEquals(newAcc.Id, [Select AccountCreated__c From Case Where Id=:sourceCase.Id LIMIT 1].AccountCreated__c);
        
        // Updating the Country and checking the Country Loopkup fields get updated with the same.
        newAcc.BillingStateCode = 'ON';
        newAcc.BillingCountryCode = 'CA';
        Update newAcc;
        System.assertEquals([SELECT Id from Country__c WHERE CountryCode__c = 'CA' limit 1].id,[SELECT Id,AccountCountry__c from Account WHERE id =: newAcc.id limit 1].AccountCountry__c);
        Test.stopTest();
    }
    
    //-----------------------------
    // @author Harshit Singhal
    // @Date 12 Jun 2018
    // @description Test class for AccountMethods.setAccountOwnerOnAccountManagerChangeAndUpdatePreviousOwner()
    // @param null
    // @return void
    //-----------------------------
    static testMethod void testSetAccountOwnerOnAccountManagerChangeAndUpdatePreviousOwner() {
        User testUser1 = TestUtility.createTestUser('IHSMarkit Data Governance', 'testUSer.testuser123@ihsmarkit.com.user',true);
        
        Test.startTest();
        Account newAcc = TestUtility.createTestAccount('Test Account 123', false);
        newAcc.GlobalAccountManager__c = testUser1.Id;
        insert newAcc;
        System.assertEquals(testUser1.Id, [Select OwnerId From Account Where Id=:newAcc.Id LIMIT 1].OwnerId);
        
        newAcc.GlobalAccountManager__c = UserInfo.getUserId();
        update newAcc;
        Account updatedAcc = [Select OwnerId,PreviousOwner__c From Account Where Id=:newAcc.Id LIMIT 1];
        System.assertEquals(UserInfo.getUserId(), updatedAcc.OwnerId);
        System.assertEquals(testUser1.Id, updatedAcc.PreviousOwner__c);
        Test.stopTest();
    }

}