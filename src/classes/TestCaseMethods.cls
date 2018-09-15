//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: Test class for Case trigger methods 
// @return: NA
// @Update - 9 May 2018 Anjani Shukla - SFDC1-8195/96/97 - ContactId is required on Case and if IsInternal = true, 
//                                      Then Email must contain  @ihsmarkit.com
//-----------------------------

@isTest
private class TestCaseMethods {
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 22 June 2017
    // @param: NA
    // @description: Test method for Case trigger methods setCaseAdditionalFieldsObject on insert
    // @return: NA
    //-----------------------------
    private static testMethod void testSetCaseAdditionalFieldsObjectInsert() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'testSetCaseAdditionalFieldsObject';
        c.AccountId = a.Id;
        
        //Assuming NRG recordtype exist in system
        
        ProductGroup__c pg = new ProductGroup__c();
        pg.Name = 'NRG';
        insert pg;
        
        AdditionalCaseTypeLinking__c aCaseTypeLinkingNRG = new AdditionalCaseTypeLinking__c();
        aCaseTypeLinkingNRG.CaseRecordType__c = 'Customer Care';
        aCaseTypeLinkingNRG.AdditionalCaseRecordType__c = 'NRG';
        aCaseTypeLinkingNRG.ProductGroup__c = pg.Id;
        insert aCaseTypeLinkingNRG;
        
        Case testCase = new Case();
        testCase.subject = 'Test subject testSetCaseAdditionalFieldsObject';
        testCase.AccountId = a.Id;
        testCase.contactId = c.Id;
        testCase.ProductGroup__c = pg.Id;
        insert testCase;
        
        list <Case> testCaseResult = [Select AdditionalFields__c, Id from case where Id = :testCase.Id];
        list <AdditionalCaseFields__c> additionalCaseFieldsList = [Select Id from AdditionalCaseFields__c where Case__c = :testCase.Id];
        
        System.assertEquals(1, testCaseResult.size());
        System.assertEquals(1, additionalCaseFieldsList.size());
        System.assertEquals(additionalCaseFieldsList[0].Id, testCaseResult[0].AdditionalFields__c);
        
    }
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 22 June 2017
    // @param: NA
    // @description: Test method for Case trigger methods setCaseAdditionalFieldsObject on update when Product was null initailly
    // @return: NA
    //-----------------------------
    private static testMethod void testSetCaseAdditionalFieldsObjectUpdateNull() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'testSetCaseAdditionalFieldsObject';
        c.AccountId = a.Id;
        
        //Assuming NRG recordtype exist in system
        
        ProductGroup__c pg = new ProductGroup__c();
        pg.Name = 'NRG';
        insert pg;
        
        AdditionalCaseTypeLinking__c aCaseTypeLinkingNRG = new AdditionalCaseTypeLinking__c();
        aCaseTypeLinkingNRG.CaseRecordType__c = 'Customer Care';
        aCaseTypeLinkingNRG.AdditionalCaseRecordType__c = 'NRG';
        aCaseTypeLinkingNRG.ProductGroup__c = pg.Id;
        insert aCaseTypeLinkingNRG;
        
        Case testCase = new Case();
        testCase.subject = 'Test subject testSetCaseAdditionalFieldsObject';
        testCase.AccountId = a.Id;
        testCase.contactId = c.Id;
        insert testCase;
        
        testCase.ProductGroup__c = pg.Id;
        update testCase;
        
        list <Case> testCaseResult = [Select ProductGroup__c, AdditionalFields__c, Id from case where Id = :testCase.Id];
        list <AdditionalCaseFields__c> additionalCaseFieldsList = [Select Id from AdditionalCaseFields__c where Case__c = :testCase.Id];
        
        System.assertEquals(1, testCaseResult.size());
        System.assertEquals(1, additionalCaseFieldsList.size());
        System.assertEquals(pg.Id, testCaseResult[0].ProductGroup__c);
        System.assertEquals(additionalCaseFieldsList[0].Id, testCaseResult[0].AdditionalFields__c);
        
    }
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 22 June 2017
    // @param: NA
    // @description: Test method for Case trigger methods setCaseAdditionalFieldsObject on update when Product was set initailly
    // @return: NA
    //-----------------------------
    private static testMethod void testSetCaseAdditionalFieldsObjectUpdate() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'testSetCaseAdditionalFieldsObject';
        c.AccountId = a.Id;
        
        //Assuming NRG recordtype exist in system
        
        ProductGroup__c pg = new ProductGroup__c();
        pg.Name = 'NRG';
        insert pg;
        
        AdditionalCaseTypeLinking__c aCaseTypeLinkingNRG = new AdditionalCaseTypeLinking__c();
        aCaseTypeLinkingNRG.CaseRecordType__c = 'Customer Care';
        aCaseTypeLinkingNRG.AdditionalCaseRecordType__c = 'NRG';
        aCaseTypeLinkingNRG.ProductGroup__c = pg.Id;
        insert aCaseTypeLinkingNRG;
        
        //Assuming PETRA recordtype exist in system
        
        ProductGroup__c pgPETRA = new ProductGroup__c();
        pgPETRA.Name = 'PETRA';
        insert pgPETRA;
        
        AdditionalCaseTypeLinking__c aCaseTypeLinkingPETRA = new AdditionalCaseTypeLinking__c();
        aCaseTypeLinkingPETRA.CaseRecordType__c = 'Customer Care';
        aCaseTypeLinkingPETRA.AdditionalCaseRecordType__c = 'PETRA';
        aCaseTypeLinkingPETRA.ProductGroup__c = pgPETRA.Id;
        insert aCaseTypeLinkingPETRA;
        
        Case testCase = new Case();
        testCase.subject = 'Test subject testSetCaseAdditionalFieldsObject';
        testCase.AccountId = a.Id;
        testCase.contactId = c.Id;
        testCase.ProductGroup__c = pg.Id;
        insert testCase;
        
        testCase.ProductGroup__c = pgPETRA.Id;
        update testCase;
        
        list <Case> testCaseResult = [Select ProductGroup__c, AdditionalFields__c, Id from case where Id = :testCase.Id];
        list <AdditionalCaseFields__c> additionalCaseFieldsList = [Select Id from AdditionalCaseFields__c where Case__c = :testCase.Id];
        
        System.assertEquals(1, testCaseResult.size());
        System.assertEquals(1, additionalCaseFieldsList.size());
        System.assertEquals(pgPETRA.Id, testCaseResult[0].ProductGroup__c);
        System.assertEquals(additionalCaseFieldsList[0].Id, testCaseResult[0].AdditionalFields__c);
        
    }

    //-----------------------------
    // @author: Vishnu Vardhan Chowdary 
    // @date: 22 January 2018
    // @param: NA
    // @description: Test method for Case trigger method SetCaseAdditionalFieldsObjectInsert  before insert
    // when product group, family both are set in additional case type linking object.
    // 
    // @editdate: 07 Feb 2018
    // @description: adding test cases for new scenarios as per 6382.
    // @return: NA
    //-----------------------------
    private static testMethod void testSetCAFObjectInsertWithProductFamily() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        Contact c = TestUtility.createContact(a.Id,'1test.2test@3test.com' ,true,'Test', 'testSetCaseAdditionalFieldsObject');

        //Assuming NRG recordtype exist in system
        ProductGroup__c pg = new ProductGroup__c();
        pg.Name = 'NRG';
        insert pg;

        //creating product family to test other scenarions
        Family__c pf = new Family__c();
        pf.Name = 'NRG Family';
        pf.ProductGroup__c = pg.Id;
        insert pf;
        
        List<AdditionalCaseTypeLinking__c> actlList = new List<AdditionalCaseTypeLinking__c>();
        AdditionalCaseTypeLinking__c aCaseTypeLinkingNRG = new AdditionalCaseTypeLinking__c();
        aCaseTypeLinkingNRG.CaseRecordType__c = 'Customer Care';
        aCaseTypeLinkingNRG.AdditionalCaseRecordType__c = 'NRG';
        aCaseTypeLinkingNRG.ProductGroup__c = pg.Id;
        //aCaseTypeLinkingNRG.ProductFamily__c = pf.id;
        
        AdditionalCaseTypeLinking__c aCaseTypeLinkingNRG1 = new AdditionalCaseTypeLinking__c();
        aCaseTypeLinkingNRG1.CaseRecordType__c = 'Onboarding';
        aCaseTypeLinkingNRG1.AdditionalCaseRecordType__c = 'NRG';
        aCaseTypeLinkingNRG1.ProductGroup__c = pg.Id;
        aCaseTypeLinkingNRG1.ProductFamily__c = pf.id;

        actlList.add(aCaseTypeLinkingNRG);
        actlList.add(aCaseTypeLinkingNRG1);
        insert actlList;
        List<Case> caseList = new List<Case>();
        Id CCId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        Id OId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
        
        Test.startTest();
        Case testCase1 = new Case();
        testCase1.subject = 'Test subject testSetCaseAdditionalFieldsObject';
        testCase1.AccountId = a.Id;
        testCase1.contactId = c.Id;
        testCase1.ProductGroup__c = pg.Id;
        testCase1.RecordTypeId = CCId;
        
        Case testCase2 = new Case();
        testCase2.subject = 'Test subject testSetCaseAdditionalFieldsObject';
        testCase2.AccountId = a.Id;
        testCase2.contactId = c.Id;
        testCase2.ProductGroup__c = pg.Id;
        testCase2.ProductFamily__c = pf.Id;
        testCase2.RecordTypeId = CCId;
        caseList.add(testCase1);
        caseList.add(testCase2);
        insert caseList;
        List<Id> caseIds = new List<Id>();
        caseIds.add(caseList.get(0).Id);
        caseIds.add(caseList.get(1).Id);
        List <Case> testCaseResult = [Select AdditionalFields__c, ProductFamily__c, Id from case where Id in :caseIds];
        List <AdditionalCaseFields__c> additionalCaseFieldsList = [Select Id from AdditionalCaseFields__c where Case__c in :caseIds];
        
        System.assertEquals(2, testCaseResult.size());
        System.assertEquals(2, additionalCaseFieldsList.size());

        for(Case testCase:testCaseResult) {
            //as per the datasetup, If case dont have product family, then additional case should fall back on product group.
            //If product family exists then, additional case should be created.
            System.assertNotEquals(testCase.AdditionalFields__c, null);
        }
        //Test though Record type id or PF or Group changes, ACF record should not be recreated.
        testCase2.RecordTypeId = OId;
        testCase2.ProductFamily__c = pf.Id;
        update testCase2;
        additionalCaseFieldsList = [Select Id from AdditionalCaseFields__c where Case__c = :testCase2.Id];
        System.assertEquals(1, additionalCaseFieldsList.size());
        //Deleting ACF record, when matching ACTL record is not available
        testCase2.ProductFamily__c = null;
        update testCase2;
        additionalCaseFieldsList = [Select Id from AdditionalCaseFields__c where Case__c = :testCase2.Id];
        System.assertEquals(0, additionalCaseFieldsList.size());
        //Now update the record type for TestCase2 and test it. ACF should have been deleted.
        //Also we dont have a matching ACTl record for record type and product group
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Vishnu Vardhan Chowdary 
    // @date: 15 Febrauary 2018
    // @param: NA
    // @description: Above method couldnt cover all the scenarios and breaking the limits,
    // So adding new method
    //-----------------------------
    private static testMethod void testSetCAFObjectInsertWithProductFamily1() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        Contact c = TestUtility.createContact(a.Id,'1test.2test@3test.com' ,true,'Test', 'testSetCaseAdditionalFieldsObject');

        //Assuming NRG recordtype exist in system
        ProductGroup__c pg = new ProductGroup__c();
        pg.Name = 'NRG';
        insert pg;
        
        Family__c pf = new Family__c();
        pf.Name = 'NRG Family';
        pf.ProductGroup__c = pg.Id;
        insert pf;

        List<AdditionalCaseTypeLinking__c> actlList = new List<AdditionalCaseTypeLinking__c>();
        AdditionalCaseTypeLinking__c aCaseTypeLinkingNRG = new AdditionalCaseTypeLinking__c();
        aCaseTypeLinkingNRG.CaseRecordType__c = 'Customer Care';
        aCaseTypeLinkingNRG.AdditionalCaseRecordType__c = 'NRG';
        aCaseTypeLinkingNRG.ProductGroup__c = pg.Id;
        
        AdditionalCaseTypeLinking__c aCaseTypeLinkingNRG1 = new AdditionalCaseTypeLinking__c();
        aCaseTypeLinkingNRG1.CaseRecordType__c = 'Onboarding';
        aCaseTypeLinkingNRG1.AdditionalCaseRecordType__c = 'Petra';
        aCaseTypeLinkingNRG1.ProductGroup__c = pg.Id;
        
        AdditionalCaseTypeLinking__c aCaseTypeLinkingNRG2 = new AdditionalCaseTypeLinking__c();
        aCaseTypeLinkingNRG2.CaseRecordType__c = 'Customer Care';
        aCaseTypeLinkingNRG2.AdditionalCaseRecordType__c = 'Petra';
        aCaseTypeLinkingNRG2.ProductGroup__c = pg.Id;
        aCaseTypeLinkingNRG2.ProductFamily__c = pf.Id;

        actlList.add(aCaseTypeLinkingNRG);
        actlList.add(aCaseTypeLinkingNRG1);
        actlList.add(aCaseTypeLinkingNRG2);
        insert actlList;
        List<Case> caseList = new List<Case>();
        Id CCId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        Id OId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
        
        Test.startTest();
        Case testCase1 = new Case();
        testCase1.subject = 'Test subject testSetCaseAdditionalFieldsObject';
        testCase1.AccountId = a.Id;
        testCase1.contactId = c.Id;
        testCase1.ProductGroup__c = pg.Id;
        testCase1.RecordTypeId = CCId;
        
        Case testCase2 = new Case();
        testCase2.subject = 'Test subject testSetCaseAdditionalFieldsObject';
        testCase2.AccountId = a.Id;
        testCase2.contactId = c.Id;
        testCase2.ProductGroup__c = pg.Id;
        testCase2.RecordTypeId = CCId;
        caseList.add(testCase1);
        caseList.add(testCase2);
        insert caseList;
        List<Id> caseIds = new List<Id>();
        testCase1 = caseList.get(0);
        testCase2 = caseList.get(1);
        caseIds.add(testCase1.Id);
        caseIds.add(testCase2.Id);
        List <Case> testCaseResult = [Select AdditionalFields__c, ProductFamily__c, Id from case where Id in :caseIds];
        List <AdditionalCaseFields__c> additionalCaseFieldsList = [Select Id from AdditionalCaseFields__c where Case__c in :caseIds];
        
        System.assertEquals(2, testCaseResult.size());
        System.assertEquals(2, additionalCaseFieldsList.size());

        testCase2 = testCaseResult.get(0);
        testCase1 = testCaseResult.get(1);
        testCase2.RecordTypeId = OId;
        testCase1.ProductFamily__c = pf.id;
        
        caseList = new List<Case>();
        caseList.add(testCase2);
        caseList.add(testCase1);
        
        update caseList;
        testCaseResult = [Select AdditionalFields__c, Id from case where Id in :caseIds];
        for(Case testCase:testCaseResult) {
            if(testCase.Id == testCase1.id) {
                //Changing product family, so ACF record should be re-created. 
                System.assertNotEquals(testCase.AdditionalFields__c, testCase1.AdditionalFields__c);
            } else {
                 //Changing record type, so record type in ACF should be changed.
                System.assertEquals(testCase.AdditionalFields__c, testCase2.AdditionalFields__c);
            }
        }

        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 20 July 2017
    // @param: NA
    // @description: Test method for Case trigger method updateDataGovernanceCaseAccountContact before insert
    // when Case Type = "Data Governance" and Subtype = "New" or "Account Maintenance"
    // @return: NA
    // @Update - 9 May 2018 Anjani Shukla - SFDC1-8195/96/97 - ContactId is required on Case and if IsInternal = true, 
    //                                      Then Email must contain  @ihsmarkit.com
    //-----------------------------
    static testMethod void TestInternalCaseAccountContact() {

        // Test data setup
        Account acct = TestUtility.createTestAccount('Test Account', true);
        Account ihsMarkitAccount = TestUtility.createTestAccountWithAddress('IHS Markit', 
                                                                  '4th floor Ropemaker Place, 25 Ropemaker Street',
                                                                  'London', '', 'GB', true);
        String testEmail = 'dgtest@ihsmarkit.com';
        
        User myTestUser = TestUtility.createAdminUser(testEmail, true);

        Contact myTestContact = TestUtility.createContact(ihsMarkitAccount.Id, testEmail, true, 'Test', 'Contact');
        
        String recordTypeId = UtilityClass.getObjectRecordTypeId('Case', 'GDSA');
        System.debug('recordTypeId=' + recordTypeId);
        System.assert(recordTypeId != null);
        
        Case dgCase = new Case(RecordTypeId = recordTypeId,
                               AccountId = acct.Id, ContactValidation__c = true,
                               Type = 'Data Governance', Subtype__c = 'Account Maintenance',
                               Description = 'Please update address'
                              );

        System.runAs(myTestUser) {
            Test.startTest();
            
            insert dgCase;
            
            // Reload dgCase from Database
            dgCase = [SELECT AccountId, CreatedById, ContactId FROM Case WHERE Id =: dgCase.Id];
            
            System.debug('dgCase.AccountId=' + dgCase.AccountId);
            System.assert(dgCase.AccountId != null);
            System.assertEquals(ihsMarkitAccount.Id, dgCase.AccountId);
    
            System.debug('dgCase.CreatedById=' + dgCase.CreatedById);
            System.assert(dgCase.CreatedById != null);
    
            User createdBy = UtilityClass.getUserById(dgCase.CreatedById);
            System.debug('dgCase.createdBy Name=' + createdBy.Name + ', Email=' + createdBy.Email);
            
            Contact userContact = UtilityClass.getContactByEmail(createdBy.Email);
            System.debug('userContact.Name=' + userContact.Name + ', Email=' + userContact.Email);
            System.assert(userContact != null);
            
            System.debug('dgCase.ContactId=' + dgCase.ContactId);
            System.assertEquals(userContact.Id, dgCase.ContactId);
            
            System.assertEquals(userContact.Email, myTestContact.Email);
            
            Test.stopTest();
        }
    }
    
    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 04 June 2018
    // @param: NA
    // @description: SFDC1-8381 Convert Process Builder flow "SetDefaultValuesForProductGroup" created in SFDC1-6418 to a trigger
    //-----------------------------
    @isTest
    static void testSetCaseProductGroupForOrderManagementDeliveryHelpDesk() {

        Account ihsMarkitAccount = TestUtility.createTestAccountWithAddress('IHS Markit', 
                                                                            '4th floor Ropemaker Place, 25 Ropemaker Street',
                                                                            'London', '', 'GB', true);
        String testEmail = 'test@ihsmarkit.com';
        User myTestUser = TestUtility.createAdminUser(testEmail, true);
        System.runAs(myTestUser) {
            Test.startTest();
    
	        Contact myTestContact = TestUtility.createContact(ihsMarkitAccount.Id, testEmail, true, 'Test', 'Contact');
            
            List<ProductGroup__c> productGroups = new List<ProductGroup__c> ();
            productGroups.add(new ProductGroup__c(Name = 'Order Mgmt. Helpdesk'));
            productGroups.add(new ProductGroup__c(Name = 'Delivery Helpdesk'));
            productGroups.add(new ProductGroup__c(Name = 'Retail Helpdesk'));
            insert productGroups;
            
            List<Case> testCases = new List<Case>();
            
            Case testCase1 = new Case();
            testCase1.subject = 'Test Product Group for Order Management case';
            testCase1.RecordTypeId = CaseMethods.caseRecordTypeOMDHelpDesk;
            testCase1.AccountId = ihsMarkitAccount.Id;
            testCase1.ContactId = myTestContact.Id;
            testCase1.TeamSelect__c = 'Order Management';
            testCase1.OrderManagementRegion__c = 'APAC';
            testCases.add(testCase1);

            Case testCase2 = new Case();
            testCase2.subject = 'Test Product Group for Delivery Helpdesk case';
            testCase2.RecordTypeId = CaseMethods.caseRecordTypeOMDHelpDesk;
            testCase2.AccountId = ihsMarkitAccount.Id;
            testCase2.ContactId = myTestContact.Id;
            testCase2.TeamSelect__c = 'Delivery';
            testCases.add(testCase2);

            Case testCase3 = new Case();
            testCase3.subject = 'Test Product Group for Retail Helpdesk case';
            testCase3.RecordTypeId = CaseMethods.caseRecordTypeOMDHelpDesk;
            testCase3.AccountId = ihsMarkitAccount.Id;
            testCase3.ContactId = myTestContact.Id;
            testCase3.TeamSelect__c = 'Retail';
            testCase3.DeliveryTeam__c = 'RETAIL-Retail Purchasing';
            testCase3.Doc__c = 'DOC8381';
            testCase3.SDO__c = 'SDO8381';
            testCases.add(testCase3);
            
            insert testCases;

            ProductGroup__c orderMgmtHelpdesk = [Select Id, Name from ProductGroup__c where Name = 'Order Mgmt. Helpdesk'];
            testCase1 = [Select Id, ProductGroup__c from Case where Subject = 'Test Product Group for Order Management case'];        
            System.debug('Case created: ' + testCase1);
            System.debug('Product Group: ' + testCase1.ProductGroup__c);
            System.assertEquals(orderMgmtHelpdesk.Id, testCase1.ProductGroup__c);

            ProductGroup__c deliveryHelpdesk = [Select Id, Name from ProductGroup__c where Name = 'Delivery Helpdesk'];
            testCase2 = [Select Id, ProductGroup__c from Case where Subject = 'Test Product Group for Delivery Helpdesk case'];        
            System.debug('Case created: ' + testCase2);
            System.debug('Product Group: ' + testCase2.ProductGroup__c);
            System.assertEquals(deliveryHelpdesk.Id, testCase2.ProductGroup__c);

            ProductGroup__c retailHelpdesk = [Select Id, Name from ProductGroup__c where Name = 'Retail Helpdesk'];
            testCase3 = [Select Id, ProductGroup__c from Case where Subject = 'Test Product Group for Retail Helpdesk case'];
            System.debug('Case created: ' + testCase3);
            System.debug('Product Group: ' + testCase3.ProductGroup__c);
            System.assertEquals(retailHelpdesk.Id, testCase3.ProductGroup__c);

            Test.stopTest();
        }
    }
    
    //-----------------------------
    // @author: Hemant Shukla
    // @date: 18 Jan 2018
    // @param: NA
    // @description: Test method for Case trigger method fireCaseAssignmentRule after insert when case are created via quick action from Opportunity/Contract
    // @return: NA
    // @Update author: Ayan Mohanty
    // @Update date: 1 Feb 2018
    // @Update description: Updating the Test method to match account id to IHSMarkit Account Id
    // @Update author: Mohit Modi
    // @Update date: 06 Feb 2018
    // @Update description: SFDC1-6009 - Updating in Test method to account name using custom label
    // @Update author: Vishnu Vardhan Chowdary
    // @Update date: 11 Jul 2018
    // @Update description: SFDC1-6026 - Checking for email 2 case scenarion where case assignment rules
    // 				shouldn't execute.
    // @Update author: Vishnu Vardhan Chowdary
    // @Update date: 07 Aug 2018
    // @Update description: SFDC1-9677 - Changing the record type to Sales Operations.
    //-----------------------------
    static testMethod void testFireCaseAssignmentRule() {
        
        Account ihsMarkitAccount = TestUtility.createTestAccountWithAddress(label.CaseAccountNameForSalesSupport, 
                                                                  '4th floor Ropemaker Place, 25 Ropemaker Street',
                                                                  'London', '', 'GB', true);
                                                                  
        String testEmail = 'dgtest@ihsmarkit.com';
        Contact myTestContact = TestUtility.createContact(ihsMarkitAccount.Id, testEmail, true, 'Test', 'Contact');
        
        String recordTypeId = UtilityClass.getObjectRecordTypeId('Case', 'Sales Operations');
        List<Case> caseList = new List<Case> ();
        Case supportCase1 = new Case(Subject = 'Case from quick Action',
                                    RecordTypeId = recordTypeId,
                                    AccountId = ihsMarkitAccount.Id,
                                    ContactId = myTestContact.id,
                                    Type = 'Pricing',
                                    Description = 'Quick Action Case',
                                    AssignToQueue__c = true
                                    );
        caseList.add(supportCase1);
        Case supportCase2 = new Case(Subject = 'Case from quick Action',
                                    RecordTypeId = recordTypeId,
                                    AccountId = ihsMarkitAccount.Id,
                                    ContactId = myTestContact.id,
                                    Type = 'Pricing',
                                    Description = 'Quick Action Case',
                                    AssignToQueue__c = true,
                                    SuppliedEMail = testEmail
                                    );
		caseList.add(supportCase2);
        Test.startTest();
        insert caseList;
        List<Case> testCaseList = new List<Case>([select Id, OwnerID, SuppliedEMail from Case]);
        System.assertEquals(testCaseList.size(),2);
        supportCase1 = testCaseList.get(0);
        supportCase2 = testCaseList.get(1);
        //Case assignment rule will be called when Supplied email is empty, and for
        //other one case assignment rule will not be set. So, will be the current user.
        System.assertNotEquals(userInfo.getUserId(),supportCase1.OwnerID);
        System.assertEquals(userInfo.getUserId(),supportCase2.OwnerID);
        //system.assert(userInfo.getUserId() != [select Id, OwnerID from Case where Id = :supportCase.id].OwnerID);
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Mohit Modi
    // @date: 06 Feb 2018
    // @param: NA
    // @description: Test method for Case trigger method setContactNamefromOwner after insert or update of Owner when case are created of SalesSupport RecordType    // 
    // 
    // @ModifiedBy: Harshit Singhal
    // @Date: 04 Jun 2018
    // @Description: SFDC1-8551, Updating test method to cover code changes made for Salesforce Helpdesk record type
    // 
    // @return: NA
    //-----------------------------
    
    static testMethod void testsetContactNamefromOwner() {
                
        Account ihsMarkitAccount = TestUtility.createTestAccountWithAddress(label.CaseAccountNameForSalesSupport, 
                                                                            '4th floor Ropemaker Place, 25 Ropemaker Street',
                                                                            'London', '', 'GB', true);
        
        Contact ihsContact = TestUtility.createContact(ihsMarkitAccount.id,UserInfo.getUserEmail(),true,'TestConactfirstName','TestContactlastName');
        String recordTypeId = UtilityClass.getObjectRecordTypeId('Case', 'Sales Operations');
        String recordTypeIdSH = UtilityClass.getObjectRecordTypeId('Case', 'Salesforce Helpdesk');
        List<Case> insertCaseList = new List<Case>();        
        
        Case supportCase = new Case(Subject = 'Case from quick Action',
                                    RecordTypeId = recordTypeId,
                                    Type = 'Pricing',
                                    Description = 'Quick Action Case',
                                    AssignToQueue__c = true
                                   );
        insertCaseList.add(supportCase);        
        
        Case shCase1 = new Case(RecordTypeId = recordTypeIdSH,ObjectTool__c='Cases',BusinessArea__c='Configuration',Status='New',Subject='Test Subject',Description='Test Description', Origin='Quick Action');        
        insertCaseList.add(shCase1);
        
        User uobj = TestUtility.createTestUser('System Administrator','testusername@ihsmarkit.com',true);
        Contact ihsContactUpdate = TestUtility.createContact(ihsMarkitAccount.id,'testusername@ihsmarkit.com',true,'TestConactfirstName1','TestContactlastName1');   
        
        Case shCase2 = new Case(RecordTypeId = recordTypeIdSH,ObjectTool__c='Cases',BusinessArea__c='Configuration',ContactId=ihsContactUpdate.Id,AccountId = ihsMarkitAccount.Id,Status='New',Subject='Test Subject2',Description='Test Description2', Origin='Quick Action');
        insertCaseList.add(shCase2);
        
        Test.startTest();
        //insert supportCase;
        if(insertCaseList.size()>0)
            insert insertCaseList;
        system.assertEquals(ihsContact.id , [select Id, ContactId from Case where Id = :supportCase.id].ContactId );
        System.assertEquals(ihsMarkitAccount.Id,[select Id, AccountId from Case where Id = :supportCase.id].AccountId);
        System.assertEquals(ihsContact.id ,[select Id, ContactId from Case where Id = :shCase1.id].ContactId );
        System.assertEquals(ihsMarkitAccount.Id,[select Id, AccountId from Case where Id = :shCase1.id].AccountId);
        System.assertEquals(ihsContactUpdate.id ,[select Id, ContactId from Case where Id = :shCase2.id].ContactId );
        
        supportCase.OwnerId = uobj.id;
        update supportCase;
        
        system.assertEquals(ihsContactUpdate.id , [select Id, ContactId from Case where Id = :supportCase.id].ContactId );
        Test.stopTest();
        
    } 
    
    //-----------------------------
    // @author: Vishnu Vardhan  
    // @date: 16 May 2018
    // @param: NA
    // @description:7183 test coverage for afterAllCaseClosedOnContract method on caseMethod class.
    // 				 Negative testing that contract should not be updated. 	
    //-----------------------------
    private static testMethod void testafterAllCaseClosedOnOFContract() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        Contact c = TestUtility.createContact(a.Id,'1test.2test@3test.com' ,true,'Test', 'testSetCaseAdditionalFieldsObject');
        
        //creating contract
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        
        Contract contract1 = TestUtility.createContractWithInsertOptional(a.Id, legalEntity.Id, country.Id, standardId,FALSE);
        contract1.RecordTypeId = orderFormRecordTypeId;
        contract1.Fastrack__c = TRUE;
        Contract1.Status = 'Creation';
        contract1.ContractStatus__c = 'Open';
        insert contract1;
        
        // creating case
        List<Case> caseList = new List<Case>();
        Id implementationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Implementation').getRecordTypeId();
        Test.startTest();
        Case testCase1 = new Case();
        testCase1.subject = 'Test subject afterAllCaseClosedOnContract 1';
        testCase1.AccountId = a.Id;
        testCase1.contactId = c.Id;
        testCase1.Contract__c= contract1.id;
        testCase1.OnboardingCaseRequired__c=FALSE;
        testCase1.RecordTypeId = implementationRecordTypeId;
        insert testCase1;

        testCase1.status = 'Closed - Resolved by IHS Markit';
        update testCase1;

        Contract ctrct= [Select id, ContractStatus__c, Status from contract where ID =: contract1.id];
        System.assertEquals('Creation',ctrct.Status);
        System.assertEquals('Open',ctrct.ContractStatus__c);

        Test.stopTest();
    }

    //-----------------------------
    // @author: Vishnu Vardhan  
    // @date: 16 May 2018
    // @param: NA
    // @description:7183 test coverage for afterAllCaseClosedOnContract method on caseMethod class.
    // 				 testing that contract should be updated. 	
    //-----------------------------
    private static testMethod void testAfterAllCaseClosedOnContract() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        Contact c = TestUtility.createContact(a.Id,'1test.2test@ihsmarkit.com' ,true,'Test', 'testSetCaseAdditionalFieldsObject');
        
        //creating contract
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Id trailRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();
        
        Contract contract1 = TestUtility.createContractWithInsertOptional(a.Id, legalEntity.Id, country.Id, standardId,FALSE);
		contract1.Status = 'Creation';
        contract1.ContractStatus__c = 'Open';
        contract1.RecordTypeId = trailRecordTypeId;
        contract1.Fastrack__c = TRUE;
        insert contract1;
        
        // creating case
        List<Case> caseList = new List<Case>();
        Id implementationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Implementation').getRecordTypeId();
        Id caseOrderManagementRecordId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Order Management').getRecordTypeId();
        Test.startTest();
        Case testCase1 = new Case();
        testCase1.subject = 'Test subject afterAllCaseClosedOnContract 1';
        testCase1.AccountId = a.Id;
        testCase1.contactId = c.Id;
        testCase1.Contract__c= contract1.id;
        testCase1.OnboardingCaseRequired__c=FALSE;
        testCase1.RecordTypeId = implementationRecordTypeId;
        
        Case testCase2 = new Case();
        testCase2.subject = 'Test subject afterAllCaseClosedOnContract 2';
        testCase2.AccountId = a.Id;
        testCase2.contactId = c.Id;
        testCase2.Contract__c= contract1.id;
        testCase2.OnboardingCaseRequired__c=FALSE;
        testCase2.RecordTypeId = implementationRecordTypeId;
        
        Case testCase3 = new Case();
        testCase3.subject = 'Test subject afterAllCaseClosedOnContract 3';
        testCase3.AccountId = a.Id;
        testCase3.contactId = c.Id;
        testCase3.Contract__c= contract1.id;
        testCase3.RecordTypeId = caseOrderManagementRecordId;
        
        caseList.add(testCase1);
        caseList.add(testCase2);
        caseList.add(testCase3);
        insert caseList;
        
        testCase2.status = 'Closed - Resolved by IHS Markit';
        testCase3.status = 'Rejected';
        testCase3.ReasonForRejection__c = 'RAD Approval Required';
        
        caseList = new List<Case>();
        caseList.add(testCase2);
        caseList.add(testCase3);
        update caseList;
        // Still 1 Test case is open here, Dont update contract.
        Contract ctrct= [Select id, ContractStatus__c, Status from contract where ID =: contract1.id];
        System.assertEquals('Creation',ctrct.Status);
        System.assertEquals('Open',ctrct.ContractStatus__c);

		testCase1.status = 'Closed - Resolved by IHS Markit';
        update testCase1;
        //Now contract has to be updated as per the requirement. 
        ctrct= [Select id, ContractStatus__c, Status from contract where ID =: contract1.id];
        System.assertEquals('Complete',ctrct.Status);
        System.assertEquals('Delivered to Customer',ctrct.ContractStatus__c);
        
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Vishnu Vardhan  
    // @date: 18 May 2018
    // @param: NA
    // @description:7740 test coverage for updateContractWhenOMCaseIsValidated method on caseMethod class.
    // @modified by: Vishnu Vardhan
    // @date: 14 Jun 2018
    // @description: SFDC1-8337: Updating test case for this story.
    //-----------------------------
    private static testMethod void testUpdateContractWhenOMCaseIsValidated() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        Contact c = TestUtility.createContact(a.Id,'1test.2test@ihsmarkit.com' ,true,'Test', 'testSetCaseAdditionalFieldsObject');
        
        //creating contract
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        
        Contract contract1 = TestUtility.createContractWithInsertOptional(a.Id, legalEntity.Id, country.Id, standardId,FALSE);
		contract1.Status = 'Creation';
        contract1.ContractStatus__c = 'Open';
        contract1.RecordTypeId = orderFormRecordTypeId;
        contract1.Fastrack__c = TRUE;
        insert contract1;
        
        // creating case
        Id caseOrderManagementRecordId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Order Management').getRecordTypeId();
        Test.startTest();
        
        Case testCase1 = new Case();
        testCase1.subject = 'Test subject afterAllCaseClosedOnContract 3';
        testCase1.AccountId = a.Id;
        testCase1.contactId = c.Id;
        testCase1.Contract__c= contract1.id;
        testCase1.status = 'New';
        testCase1.RecordTypeId = caseOrderManagementRecordId;
        insert testCase1;
        
        testCase1.status = 'Validated';
        Update testCase1;
        // Contract status should be updated to Validated
        Contract ctrct = [Select id, ContractStatus__c from contract where ID =: contract1.id];
        System.assertEquals('Validated',ctrct.ContractStatus__c);

        //Now update Contract status should to Validated PO Pending
		testCase1.status = 'Validated PO Pending';
        update testCase1;
        //Now contract should be updated as Validated PO Pending. 
        ctrct= [Select id, ContractStatus__c from contract where ID =: contract1.id];
        System.assertEquals('Validated PO Pending',ctrct.ContractStatus__c);
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Vishnu Vardhan  
    // @date: 21 May 2018
    // @param: NA
    // @description:7740 test coverage for updateContractWhenOMCaseIsRejected method on caseMethod class.
    //-----------------------------
    private static testMethod void testupdateContractWhenOMCaseIsRejected() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        Contact c = TestUtility.createContact(a.Id,'1test.2test@ihsmarkit.com' ,true,'Test', 'testSetCaseAdditionalFieldsObject');
        Opportunity testOpportunity = TestUtility.createOpportunity(a.Id, 'test Opppy', false);
        testOpportunity.BudgetRange__c = '< 25,000';
        testOpportunity.ActivityCreated__c = true;
        testOpportunity.CloseDate = System.today() + 180;
        testOpportunity.ContractEndDate__c = System.today() + 180;
        testOpportunity.ContractStartDate__c = System.today();
        insert testOpportunity;
        //creating contract
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        
        Contract contract1 = TestUtility.createContractWithInsertOptional(a.Id, legalEntity.Id, country.Id, standardId,FALSE);
		contract1.Status = 'Creation';
        contract1.ContractStatus__c = 'Open';
        contract1.Opportunity__c = testOpportunity.id;
        contract1.RecordTypeId = orderFormRecordTypeId;
        contract1.Fastrack__c = TRUE;
        insert contract1;
        
        // creating case
        Id caseOrderManagementRecordId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Order Management').getRecordTypeId();
        Test.startTest();
        
        Case testCase1 = new Case();
        testCase1.subject = 'Test subject afterAllCaseClosedOnContract 3';
        testCase1.AccountId = a.Id;
        testCase1.contactId = c.Id;
        testCase1.Contract__c= contract1.id;
        testCase1.status = 'New';
        testCase1.RecordTypeId = caseOrderManagementRecordId;
        insert testCase1;
        
        testCase1.status = 'Rejected';
        testCase1.ReasonForRejection__c = 'Special Membership Authorization';
        Update testCase1;
        // Contract status should be updated to Rejected
        Contract ctrct = [Select id, ContractStatus__c, status from contract where ID =: contract1.id];
        System.assertEquals('Rejected',ctrct.ContractStatus__c);
        System.assertEquals('Creation',ctrct.status);
        Test.stopTest();
    }
    //-----------------------------
    // @author: Vishnu Vardhan Chowdary Andra
    // @date: 21 March 2018
    // @param: NA
    // @description: SFDC1-7163: To test that validation exception is thrown if implementation 
    // 				case has contract other than order form and onboardingCaserequired Field is checked
    //-----------------------------
    @isTest
    static void testOnboardingCaseNotCreatedForTrialContract() {
        Account acc = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        Contact con = TestUtility.createContact(acc.Id,'1test.2test@3test.com' ,true,'Test', 'testSetCaseAdditionalFieldsObject');
		Opportunity testOpportunity = TestUtility.createOpportunity(acc.Id, 'test Opppy', false);
        testOpportunity.BudgetRange__c = '< 25,000';
        testOpportunity.ActivityCreated__c = true;
        testOpportunity.CloseDate = System.today() + 180;
        insert testOpportunity;

        OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId = testOpportunity.Id, ContactId = con.Id, IsPrimary=true);
        insert ocr;
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        OpportunityLineItem oli = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, true);
        List<Id> oliIds = new List<Id>();
        oliIds.add(oli.Id);
		Id trailRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();
        Id trialContractRecId = ContractRecordTypeSelectionController.createTrialContractRecord(testOpportunity.Id,System.JSON.serialize(oliIds));
		// creating case
        Id implementationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Implementation').getRecordTypeId();

        Case testCase1 = new Case();
        testCase1.subject = 'Test subject afterAllCaseClosedOnContract 1';
        testCase1.AccountId = acc.Id;
        testCase1.Contract__c= trialContractRecId;
		testCase1.OnboardingCaseRequired__c=FALSE;
        testCase1.RecordTypeId = implementationRecordTypeId;
        insert testCase1;
		System.debug('Case created : '+testCase1);
        Test.startTest();
        //This field will be checked after creating case, but not while inserting. That is the requirement
        System.debug('Validation exception should be done : ');
        testCase1.OnboardingCaseRequired__c = True;
        boolean exceptionRaised = false;
        try {
            //Verify that update will fail, as contract should be Order form record type id.
            update testCase1;
        } catch (Exception e) {
            exceptionRaised= true;
        }
        System.assert(exceptionRaised);
        Test.stopTest();
    }

    //-----------------------------
    // @author: Vishnu Vardhan Chowdary Andra
    // @date: 21 March 2018
    // @param: NA
    // @description: SFDC1-7163: To test that case is either created or deleted when case has order form contract
    // 				 and onboardingCaseRequired Field is checked or unchecked
    //-----------------------------
    @isTest
    static void testOnboardingCaseCreatedForOrderFormContract() {
        Account acc = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        Contact con = TestUtility.createContact(acc.Id,'1test.2test@3test.com' ,true,'Test', 'testSetCaseAdditionalFieldsObject');
		Opportunity testOpportunity = TestUtility.createOpportunity(acc.Id, 'test Opppy', false);
        testOpportunity.BudgetRange__c = '< 25,000';
        testOpportunity.ActivityCreated__c = true;
        testOpportunity.CloseDate = System.today() + 180;
        insert testOpportunity;

        OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId = testOpportunity.Id, ContactId = con.Id, IsPrimary=true);
        insert ocr;
		Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();

        Id ofContractRecId = ContractRecordTypeSelectionController.createDefaultRecord(orderFormRecordTypeId, testOpportunity.Id);
		// creating case
        Id implementationRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Implementation').getRecordTypeId();
        Id onBoardingRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();

        Case testCase1 = new Case();
        testCase1.subject = 'Test subject afterAllCaseClosedOnContract 1';
        testCase1.AccountId = acc.Id;
        testCase1.Contract__c= ofContractRecId;
		testCase1.OnboardingCaseRequired__c=FALSE;
        testCase1.RecordTypeId = implementationRecordTypeId;
        insert testCase1;
		System.debug('Case created : '+testCase1);
        Test.startTest();
        //This field will be checked after creating case, but not while inserting. That is the requirement
        //Check that child case is created, and record type is Onboarding, account is related to account.
        System.debug('Create Child case : ');
        testCase1.OnboardingCaseRequired__c = True;
        update testCase1;
        Case childCase = [select id, recordTypeId, contactId, accountId from case where ParentId =: testCase1.id];
        System.assertEquals(null, childCase.ContactId);
        System.assertEquals(onBoardingRecordTypeId, childCase.recordTypeId);
        System.assertEquals(testCase1.accountId, childCase.accountId);
        System.debug('Before changing contact : ');
        //Verify that child case is updated with Contact.
        testCase1.contactId = con.Id;
		update testCase1;
        childCase = [select id, recordTypeId, contactId, accountId from case where ParentId =: testCase1.id];
        System.assertEquals(con.Id, childCase.ContactId);
        System.assertEquals(onBoardingRecordTypeId, childCase.recordTypeId);
        System.assertEquals(testCase1.accountId, childCase.accountId);
        System.debug('Before deleting child case : ');
		testCase1.OnboardingCaseRequired__c = False;
        //Check that child case is deleted
        update testCase1;
        List<Case> childCases = [select id, recordTypeId, contactId, accountId from case where ParentId =: testCase1.id];
        System.assert(childCases.isEmpty());
        Test.stopTest();
    }

    //-----------------------------
    // @author: Vishnu Vardhan Chowdary Andra
    // @date: 04 April 2018
    // @param: NA
    // @description: SFDC1-6382: To test that ACF deletion and creation works properly even when ACTL records get 
    // 				changed in between, earlier this was never covered or tested. 
    //-----------------------------
    @isTest
    static void testSetCaseAdditionalFieldsObjectOnACTLChange() {
        Id CCId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        Id OId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Onboarding').getRecordTypeId();
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        
        //Assuming NRG recordtype exist in system
        ProductGroup__c pg = new ProductGroup__c();
        pg.Name = 'NRG';
        insert pg;
        
        AdditionalCaseTypeLinking__c aCaseTypeLinkingNRG = new AdditionalCaseTypeLinking__c();
        aCaseTypeLinkingNRG.CaseRecordType__c = 'Customer Care';
        aCaseTypeLinkingNRG.AdditionalCaseRecordType__c = 'NRG';
        aCaseTypeLinkingNRG.ProductGroup__c = pg.Id;
        insert aCaseTypeLinkingNRG;
        
        Case testCase = new Case();
        testCase.RecordTypeId = OId;
        testCase.subject = 'Test subject testSetCaseAdditionalFieldsObject';
        testCase.AccountId = a.Id;
        testCase.ProductGroup__c = pg.Id;
        insert testCase;
        
		Test.startTest();        
        list <Case> testCaseResult = [Select AdditionalFields__c, Id from case where Id = :testCase.Id];
        list <AdditionalCaseFields__c> additionalCaseFieldsList = [Select Id from AdditionalCaseFields__c where Case__c = :testCase.Id];
        System.assertEquals(1, testCaseResult.size());
        System.assertEquals(0, additionalCaseFieldsList.size());
        //Now insert a new ACTL record, 

        AdditionalCaseTypeLinking__c aCaseTypeLinkingNRGOB = new AdditionalCaseTypeLinking__c();
        aCaseTypeLinkingNRGOB.CaseRecordType__c = 'Onboarding';
        aCaseTypeLinkingNRGOB.AdditionalCaseRecordType__c = 'NRG';
        aCaseTypeLinkingNRGOB.ProductGroup__c = pg.Id;
        insert aCaseTypeLinkingNRGOB;
        
        //Earlier an exception was being thrown and it should be fixed now, and case should be updated.
        testCase.RecordTypeId = CCId;
        update testCase;
        testCaseResult = [Select AdditionalFields__c, Id from case where Id = :testCase.Id];
        additionalCaseFieldsList = [Select Id from AdditionalCaseFields__c where Case__c = :testCase.Id];
        System.assertEquals(1, testCaseResult.size());
        System.assertEquals(1, additionalCaseFieldsList.size());
        System.assertEquals(additionalCaseFieldsList[0].Id, testCaseResult[0].AdditionalFields__c);
        
        delete aCaseTypeLinkingNRG;
        testCase.RecordTypeId = oId;
        update testCase;
        testCaseResult = [Select AdditionalFields__c, Id from case where Id = :testCase.Id];
        additionalCaseFieldsList = [Select Id from AdditionalCaseFields__c where Case__c = :testCase.Id];
        
        System.assertEquals(1, testCaseResult.size());
        System.assertEquals(1, additionalCaseFieldsList.size());
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 09 Mar 2018
    // @param: NA
    // @description: Test method for Case trigger methods assignCasesViaTriage on insert
    // @return: NA
    //-----------------------------
     private static testMethod void testAssignCasesViaTriageForMSERV() {
        ID CustomerCareRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'testSetCaseAdditionalFieldsObject';
        c.AccountId = a.Id;
        String testEmail = 'dgtest@test.com';
        c.EmailUnknown__c = TRUE;
        c.Phone = '1234567890';
        insert c;
        User myTestUser = TestUtility.createAdminUser(testEmail, true);
        Group g1;
        QueuesObject q1;
        List<Group> lstAllQueues;
        System.runAs(myTestUser) {
            List<String> lstQueueNames = new List<String>();
            lstQueueNames.add(System.label.DefaultMSERVQueue);
            
            lstAllQueues = new List<Group>([Select Id,name From Group where Type = 'Queue' and Name in : lstQueueNames LIMIT 1]);
        }
        ProductGroup__c prdGRP = new ProductGroup__c();
        insert prdGRP;
        ID IHSTriageRecordTypeId = Schema.Sobjecttype.TriageCriteria__c.getRecordTypeInfosByName().get('IHS').getRecordTypeId();
        ID MarkitSERVTriageRecordTypeId = Schema.Sobjecttype.TriageCriteria__c.getRecordTypeInfosByName().get('MarkitSERV').getRecordTypeId();
        Test.startTest();
        List<TriageCriteria__c> lstTRCCriteria = new List<TriageCriteria__c>();
        TriageCriteria__c trc1 = new TriageCriteria__c(RecordTypeId=MarkitSERVTriageRecordTypeId ,Priority__c=1,Queue__c=lstAllQueues[0].Name,Subject__c = 'hello');
        lstTRCCriteria.add(trc1);
        insert lstTRCCriteria ;
        CaseTriageExecutionOrder__c customSettingRec1 = new CaseTriageExecutionOrder__c(Name = '1',Field__c = 'Priority__c',ASC__c = true,DESC__c = false);
        insert customSettingRec1 ;
        
        CaseTriageMappingForAssignment__c customSettingRec2 = new CaseTriageMappingForAssignment__c(Name = '1',CaseField__c = 'Subject',TriageField__c = 'Subject__c');
        CaseTriageMappingForAssignment__c customSettingRec3 = new CaseTriageMappingForAssignment__c(Name = '2',CaseField__c = 'ProductGroup__c',TriageField__c = 'ProductGroup__c');
        List<CaseTriageMappingForAssignment__c> lstCaseTriageRecords = new List<CaseTriageMappingForAssignment__c>();
        lstCaseTriageRecords.add(customSettingRec2);
        lstCaseTriageRecords.add(customSettingRec3); 
        insert lstCaseTriageRecords;
        
        List<Case> lstCase = new List<Case>();
        Case testCase = new Case();
        testCase.subject = 'hello';
        testCase.AccountId = a.Id;
        testCase.contactId = c.Id;
        testCase.RecordTypeId = CustomerCareRecordTypeId;
        testCase.Origin = System.Label.EmailFromValue;
        lstCase.add(testCase); 
        insert lstCase; 

        Case cse = [Select id, ownerId,owner.name from Case where id =: lstCase[0].id];        
        System.assertEquals(String.valueOf(cse.ownerId).substring(0,15) , String.valueOf(lstAllQueues[0].id).substring(0,15)); 
        Test.stopTest(); 
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 30 May 2018
    // @param: NA
    // @description: Test method for Case trigger methods assignCasesViaTriageforMarkit on insert
    // @return: NA
    //-----------------------------
     private static testMethod void testAssignCasesViaTriageForMarkit() {
        ID CustomerCareRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'Test123';
        c.AccountId = a.Id;
        String testEmail = 'dgtest@test.com';
        c.EmailUnknown__c = TRUE;
        c.Phone = '1234567890';
        insert c;
        User myTestUser = TestUtility.createAdminUser(testEmail, true);
        Group g1;
        QueuesObject q1;
        List<Group> lstAllQueues;
        System.runAs(myTestUser) {
            List<String> lstQueueNames = new List<String>();
            lstQueueNames.add(System.label.DefaultMarkitQueue);
            
            lstAllQueues = new List<Group>([Select Id,name From Group where Type = 'Queue' and Name in : lstQueueNames LIMIT 1]);
        }
        ProductGroup__c prdGRP = new ProductGroup__c();
        insert prdGRP;
        ID IHSTriageRecordTypeId = Schema.Sobjecttype.TriageCriteria__c.getRecordTypeInfosByName().get('IHS').getRecordTypeId();
        ID MarkitSERVTriageRecordTypeId = Schema.Sobjecttype.TriageCriteria__c.getRecordTypeInfosByName().get('Markit').getRecordTypeId();
        Test.startTest();
        List<TriageCriteria__c> lstTRCCriteria = new List<TriageCriteria__c>();
        TriageCriteria__c trc1 = new TriageCriteria__c(RecordTypeId=MarkitSERVTriageRecordTypeId ,Priority__c=1,Queue__c=lstAllQueues[0].Name,Subject__c = 'hello');
        lstTRCCriteria.add(trc1);
        insert lstTRCCriteria ;
        CaseTriageExecutionOrder__c customSettingRec1 = new CaseTriageExecutionOrder__c(Name = '1',Field__c = 'Priority__c',ASC__c = true,DESC__c = false);
        insert customSettingRec1 ;
        
        CaseTriageMappingForAssignment__c customSettingRec2 = new CaseTriageMappingForAssignment__c(Name = '1',CaseField__c = 'Subject',TriageField__c = 'Subject__c');
        CaseTriageMappingForAssignment__c customSettingRec3 = new CaseTriageMappingForAssignment__c(Name = '2',CaseField__c = 'ProductGroup__c',TriageField__c = 'ProductGroup__c');
        List<CaseTriageMappingForAssignment__c> lstCaseTriageRecords = new List<CaseTriageMappingForAssignment__c>();
        lstCaseTriageRecords.add(customSettingRec2);
        lstCaseTriageRecords.add(customSettingRec3); 
        insert lstCaseTriageRecords;
        
        List<Case> lstCase = new List<Case>();
        Case testCase = new Case();
        testCase.subject = 'hello';
        testCase.AccountId = a.Id;
        testCase.contactId = c.Id;
        testCase.RecordTypeId = CustomerCareRecordTypeId;
        testCase.Origin = System.Label.EmailFromValueMarkit;
        lstCase.add(testCase); 
        insert lstCase; 

        Case cse = [Select id, ownerId,owner.name from Case where id =: lstCase[0].id];        
        System.assertEquals(String.valueOf(cse.ownerId).substring(0,15) , String.valueOf(lstAllQueues[0].id).substring(0,15)); 
        Test.stopTest(); 
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 09 Mar 2018
    // @param: NA
    // @description: Test method for Case trigger methods assignCasesViaTriage on insert
    // @return: NA
    //-----------------------------
     private static testMethod void testAssignCasesViaTriageForIHS() {
        ID CustomerCareRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'testSetCaseAdditionalFieldsObject';
        c.AccountId = a.Id;
        String testEmail = 'dgtest@test.com';
        c.EmailUnknown__c = TRUE;
        c.Phone = '1234567890';
        insert c;
        User myTestUser = TestUtility.createAdminUser(testEmail, true);
        Group g1;
        QueuesObject q1;
        List<Group> lstAllQueues;
        System.runAs(myTestUser) {
            List<String> lstQueueNames = new List<String>();
            lstQueueNames.add(System.label.DefaultIHSQueue);
            
            lstAllQueues = new List<Group>([Select Id,name From Group where Type = 'Queue' and Name in : lstQueueNames LIMIT 1]);
        }
        ProductGroup__c prdGRP = new ProductGroup__c();
        insert prdGRP;
        ID IHSTriageRecordTypeId = Schema.Sobjecttype.TriageCriteria__c.getRecordTypeInfosByName().get('IHS').getRecordTypeId();
        Test.startTest();
        List<TriageCriteria__c> lstTRCCriteria = new List<TriageCriteria__c>();
        TriageCriteria__c trc2 = new TriageCriteria__c(RecordTypeId=IHSTriageRecordTypeId ,Priority__c=1,Queue__c=lstAllQueues[0].Name,ProductGroup__c = prdGRP.Id);
        system.debug('trc2---'+trc2);
        lstTRCCriteria.add(trc2);
        insert lstTRCCriteria ;
        CaseTriageExecutionOrder__c customSettingRec1 = new CaseTriageExecutionOrder__c(Name = '1',Field__c = 'Priority__c',ASC__c = true,DESC__c = false);
        insert customSettingRec1 ;
        
        CaseTriageMappingForAssignment__c customSettingRec2 = new CaseTriageMappingForAssignment__c(Name = '1',CaseField__c = 'Subject',TriageField__c = 'Subject__c');
        CaseTriageMappingForAssignment__c customSettingRec3 = new CaseTriageMappingForAssignment__c(Name = '2',CaseField__c = 'ProductGroup__c',TriageField__c = 'ProductGroup__c');
        List<CaseTriageMappingForAssignment__c> lstCaseTriageRecords = new List<CaseTriageMappingForAssignment__c>();
        lstCaseTriageRecords.add(customSettingRec2);
        lstCaseTriageRecords.add(customSettingRec3); 
        insert lstCaseTriageRecords;
        
        List<Case> lstCase = new List<Case>(); 
        Case testCase1 = new Case();
        testCase1.subject = 'hello';
        testCase1.AccountId = a.Id;
        testCase1.contactId = c.Id;
        testCase1.ProductGroup__c = prdGRP.Id;
        testCase1.RecordTypeId = CustomerCareRecordTypeId; 
        testCase1.Origin = 'Internal'; 
        testCase1.OwnerId = myTestUser.Id;              
        lstCase.add(testCase1);
        insert lstCase; 
        
        testCase1.OwnerId = System.Label.ToBeAssignedQueueId;
        update testCase1;    

        Case cse1 = [Select id, ownerId, owner.name from Case where id =: testCase1.id];
        System.assertEquals(String.valueOf(cse1.ownerId).substring(0,15), String.valueOf(lstAllQueues[0].id).substring(0,15));
        Test.stopTest();    
    }
    //-----------------------------
    // @author: Jagadesh Kumar
    // @date: 30 May 2018
    // @param: NA
    // @description: Test method for Case trigger methods populateCaseLookUpFields on insert
    // @return: NA
	// @LastModifieddate : 18 July 2018
	// @LastModifieby : Mohit Modi
	// @LastModifieddescription : SFDC1-9031-Commenting this Method as field ContractOwner__c and OpportunityOwner__c is nomore required.
    //-----------------------------
    /*
    private static testMethod void testPopulateCaseLookUpFields() {
        String recordTypeId = UtilityClass.getObjectRecordTypeId('Case', 'Sales Support');
        Test.startTest();
        String testEmail = 'opptyOwnertest@ihsmarkit.com';
        User myTestUser = TestUtility.createAdminUser(testEmail, true);
        Account acc = TestUtility.createTestAccountWithAddress(label.CaseAccountNameForSalesSupport, 
                                                                  '4th floor Ropemaker Place, 25 Ropemaker Street',
                                                                  'London', '', 'GB', true);
        Contact con = TestUtility.createContact(acc.Id,'opptyOwnertest@ihsmarkit.com' ,true,'Test', 'testCaseOpptyOwner');
        Opportunity testOpportunity;
        Contract contract1;
        System.runAs(myTestUser) {
            testOpportunity = TestUtility.createOpportunity(acc.Id, 'test Opppy', true);
            //creating contract
            Product2 testProd = TestUtility.createProduct('Test Product', true);
            Id standardId = Test.getStandardPricebookId();
            PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
            
            LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
            List<Country__c> lstCountry = TestUtility.loadCountryData();
            Country__c country = lstCountry.get(0);
            Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
            
            contract1 = TestUtility.createContractWithInsertOptional(acc.Id, legalEntity.Id, country.Id, standardId,FALSE);
            contract1.RecordTypeId = orderFormRecordTypeId;
            contract1.Fastrack__c = TRUE;
            Contract1.Status = 'Creation';
            contract1.ContractStatus__c = 'Open';
            insert contract1;
        }
        Case supportCase = new Case(Subject = 'Case from quick Action',
                                    RecordTypeId = recordTypeId,
                                    AccountId = acc.Id,
                                    ContactId = con.id,
                                    Opportunity__c = testOpportunity.Id,
                                    Contract__c = contract1.Id,
                                    Type = 'Sales OPs',
                                    Description = 'Related list Case',
                                    AssignToQueue__c = true
                                    );
        insert supportCase;
        Case c = [Select OpportunityOwner__c from Case where Id =: supportCase.Id];
        System.assert(c.OpportunityOwner__c != null);
        Test.stopTest();
    }
    */
    //-----------------------------
    // @author: Jagadesh Kumar
    // @date: 03 July 2018
    // @param: NA
    // @description: Test method for Case trigger methods ValidateCaseContactAndAccountMatch on insert
    // @return: NA
    //-----------------------------
    private static testMethod void testValidateCaseContactAndAccountMatch() {
        Test.startTest();
        Id implementationRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Implementation').getRecordTypeId();
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        List<Account> listAcct = new List<Account>();
        List<Case> listCase = new List<Case>();
        Account acc1 = TestUtility.createTestAccountWithAddress('TestImplementationAccount', 
                                                                  '4th floor Ropemaker Place, 25 Ropemaker Street',
                                                                  'London', '', 'GB', false);
        Account acc2 = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        listAcct.add(acc1);
        listAcct.add(acc2);
        insert listAcct;
        Contact con = TestUtility.createContact(acc1.Id,'opptyOwnertest@ihsmarkit.com' ,true,'Test', 'testCaseOpptyOwner');
        Opportunity testOpportunity = TestUtility.createOpportunity(acc1.Id, 'test Opppy', true);
        //creating contract
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContractWithInsertOptional(acc1.Id, legalEntity.Id, country.Id, standardId,FALSE);
        contract1.RecordTypeId = orderFormRecordTypeId;
        contract1.Fastrack__c = TRUE;
        Contract1.Status = 'Creation';
        contract1.ContractStatus__c = 'Open';
        insert contract1;
        Case case1 = new Case(Subject = 'Case Impl Record',
                                    RecordTypeId = implementationRecordTypeId,
                                    AccountId = acc1.Id,
                                    ContactId = con.id,
                                    Opportunity__c = testOpportunity.Id,
                                    Contract__c = contract1.Id,
                                    Type = 'Continuation',
                                    Description = 'Case Impl Record',
                                    AssignToQueue__c = true
                                    );
        listCase.add(case1);
        Case case2 = new Case(Subject = 'Case Impl Record',
                                    RecordTypeId = implementationRecordTypeId,
                                    AccountId = acc2.Id,
                                    ContactId = con.id,
                                    Opportunity__c = testOpportunity.Id,
                                    Contract__c = contract1.Id,
                                    Type = 'Continuation',
                                    Description = 'Case Impl Record',
                                    AssignToQueue__c = true
                                    );
        listCase.add(case2);
        String errMsg;
        try {
        	insert listCase;
        } catch (DMLException e) {
            errMsg = e.getMessage();
        }
        System.assert(errMsg.contains(System.Label.CaseContactAndAccountMatchMSG));
        Test.stopTest();
    }
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 12 July 2018
    // @param: NA
    // @description: Test method for Case trigger methods populateOMDeliveryHelpDeskCaseFields on before insert
    // @return: NA
    //-----------------------------
    private static testMethod void testPopulateOMDeliveryHelpDeskCaseFields() {
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        
        List<Account> listAcct = new List<Account>();
        Account acc1 = TestUtility.createTestAccountWithAddress('TestImplementationAccount', 
                                                                  '4th floor Ropemaker Place, 25 Ropemaker Street',
                                                                  'London', '', 'GB', false);
        Account acc2 = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        listAcct.add(acc1);
        listAcct.add(acc2);
        insert listAcct;
        
        User myTestUser = TestUtility.createAdminUser('opptyOwnertest@ihsmarkit.com', true);
        Test.startTest();
        Contact con = TestUtility.createContact(acc1.Id,'opptyOwnertest@ihsmarkit.com' ,false,'Test', 'testCaseOpptyOwner');
        Contact con1 = TestUtility.createContact(acc1.Id,'abctest@ihsmarkit.com' ,false,'Tes1', 'testCaseOpptyOwner1');
        List<Contact> lstCon = new List<Contact>();
        lstCon.add(con);
        lstCon.add(con1);
        insert lstCon;
        
        Opportunity testOpportunity = TestUtility.createOpportunity(acc1.Id, 'test Opppy', true);
        //creating contract
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContractWithInsertOptional(acc1.Id, legalEntity.Id, country.Id, standardId,FALSE);
        contract1.RecordTypeId = orderFormRecordTypeId;
        contract1.Fastrack__c = TRUE;
        Contract1.Status = 'Creation';
        contract1.ContractStatus__c = 'Open';
        Contract1.SAPPGId__c = 'New';
        insert contract1;
        
        ContractContactRole cRoleObj = new ContractContactRole(contractId = contract1.Id,isprimary = true, contactid=con1.Id);
        insert cRoleObj;
        Test.stopTest();
        System.runAs(myTestUser) {
        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Order Management/Delivery Help Desk').getRecordTypeId();
            Case case1 = new Case(Subject = 'Case OM/Delivery Helpdesk Record',
                                        RecordTypeId = recTypeId,
                                        AccountId = acc1.Id,                                        
                                        //Opportunity__c = testOpportunity.Id,
                                        Contract__c = contract1.Id,
                                        //Type = 'Continuation',
                                        Description = 'Case Impl Record'
                                        //AssignToQueue__c = true
                                        );
            insert case1;
            Case c = [select ContactId, ContactReference__c from case where id =: case1.id];
            system.assert(c.ContactId == con.id);
            system.assert(c.ContactReference__c  == con1.id);           
        }
    }
}