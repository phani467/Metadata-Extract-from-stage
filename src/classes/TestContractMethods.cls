//-----------------------------
// @author: Mohit Modi
// @date: 27 Sept 2017
// @param: NA
// @description: Test Class for ContractMethods
// @return: NA
// @company: VERTIBA
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 14 Dec 2017 Sprint 15
// @Last Modified Description: SFDC1-5851, Included Fastrack chakbox value for order form contracts
//-----------------------------
//-----------------------------
// @author: Mohit Modi
// @date: 27 Sept 2017
// @param: NA
// @description: Test Class for ContractMethods
// @return: NA
// @company: VERTIBA
// @Last Modified By : Ayan Mohanty
// @Last Modified Date: 14 Feb 2018 Sprint 19
// @Last Modified Description: SFDC1-6993, Removing instances of BillToFaxNumber__c and ShipToFaxNumber__c
//-----------------------------
// @Last Modified By : Vishnu Vardhan Chowdary
// @Last Modified Date: 13 Mar 2018, Sprint 21
// @Last Modified Description: Adding test methods for Case creation from contracts, and a test setup for SFDC1-4207, 7204 and 4324.
// -------------------------------------
// @Last Modified By : Sruti Srivastava 
// @Last Modified Date : 5th April 2018
// @Last Modified Description : SFDC1-7604 - updated test class to bypass validation on contract
// -------------------------------------
// @author: Sruti Srivastava
// @date: 12 May 2018
// @description: Test method to test updateOppTo6WPClosedWonOPWhenOrderFormIsCompleted method on contractMethod
//-----------------------------
@isTest
private class TestContractMethods {

    @isTest
    static void testCopyPrimaryContactToContract() {

            Id OrderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
            Account acc = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
            acc.DataGovernanceStatus__c = 'Approved';
            insert acc;
            
            Contact con = TestUtility.createContact(acc.id,'testemail1@test.com',false,'TestFirstName','TestLastName');
            con.Phone = '123423';
            con.Fax = '321412321';
            
            Contact con1 = TestUtility.createContact(acc.id,'testemail2@test.com',false,'TestFirstName1','TestLastName1');
            con1.Phone = '12342312312';
            con1.Fax = '3214123211231231';
            insert new list<contact>{con,con1};
            
            Test.startTest();
            Opportunity testOpportunity = TestUtility.createOpportunity(acc.Id, 'test Opppy', true);
            
            Opportunity testOpportunity1 = TestUtility.createOpportunity(acc.Id, 'test Opppy', true);
            
            OpportunityContactRole oppContactRole = new OpportunityContactRole ();
            oppContactRole.OpportunityId = testOpportunity.id;
            oppContactRole.ContactId = con.id;
            oppContactRole.IsPrimary = true;
            
            OpportunityContactRole oppContactRole1 = new OpportunityContactRole ();
            oppContactRole1.OpportunityId = testOpportunity1.id;
            oppContactRole1.ContactId = con1.id;
            oppContactRole1.IsPrimary = true;
            
            insert new List<OpportunityContactRole> {oppContactRole,oppContactRole1};
            
            Id contractRecId = ContractRecordTypeSelectionController.createDefaultRecord(OrderFormRecordTypeId, testOpportunity.Id);
            
            // Quering Contract Object to verify the Contact Values on Contract
            Contract Contractobj = [Select id, accountId,BillToContactEmailAddress__c,BillToContactFirstName__c,
            ShipToContactEmailAddress__c,ShipToContactTelephoneNumber__c  from contract where Id=: contractRecId];
            
            // Assert for the Contact Values on Contract
            System.assertEquals(Contractobj.BillToContactEmailAddress__c,'testemail1@test.com');
            System.assertEquals(Contractobj.BillToContactFirstName__c,'TestFirstName');
            //System.assertEquals(Contractobj.BillToFaxNumber__c,'321412321');
            System.assertEquals(Contractobj.ShipToContactTelephoneNumber__c ,'123423');
            //System.assertEquals(Contractobj.ShipToFaxNumber__c  ,'321412321');
            
            // Updating Opportunity on Contract to verfiy that the Contact Values should be updated accordingly
            Contractobj.Opportunity__c = testOpportunity1.id;
            Contractobj.Fastrack__c= TRUE;
            update Contractobj;
            
            // Quering again Contract Object to verify the Contact Values on Contract
            Contractobj = [Select id, accountId,BillToContactEmailAddress__c,BillToContactFirstName__c,
            ShipToContactEmailAddress__c,ShipToContactTelephoneNumber__c  from contract where Id=: contractRecId];
            
            // Assert for the Contact Values on Contract
            System.assertEquals(Contractobj.BillToContactEmailAddress__c,'testemail2@test.com');
            System.assertEquals(Contractobj.BillToContactFirstName__c,'TestFirstName1');
            //System.assertEquals(Contractobj.BillToFaxNumber__c,'3214123211231231');
            System.assertEquals(Contractobj.ShipToContactTelephoneNumber__c ,'12342312312');
           // System.assertEquals(Contractobj.ShipToFaxNumber__c  ,'3214123211231231');
            
        Test.stopTest();
    }

    //-----------------------------
    // @author: Vishnu Vardhan Chowdary
    // @date: 12 Mar 2018
    // @description: Method to create test data.
    // @param: 
    // @return: void
    //-----------------------------
    @testSetup 
    static void insertCommonCodeForCreatingCaseFromContract() {
        Account acc = TestUtility.createTestAccount('Account testImplCaseFromOrderFormContract', false);
        acc.DataGovernanceStatus__c = 'Approved';
        insert acc;
        Opportunity testOpportunity = TestUtility.createOpportunity(acc.Id, 'test Opppy', false);
        testOpportunity.BudgetRange__c = '< 25,000';
        testOpportunity.ActivityCreated__c = true;
        testOpportunity.CloseDate = System.today() + 180;
        insert testOpportunity;

        Contact testContact = TestUtility.createContact(acc.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId = testOpportunity.Id, ContactId = testContact.Id, IsPrimary=true);
        insert ocr;

        List<LoadingGroup__c> lgList = new List<LoadingGroup__c> ();
        lgList.add(TestUtility.createLoadingGroup('IHS', 'IHS Lg1', false));
        lgList.add(TestUtility.createLoadingGroup('IHS', 'IHS Lg2', false));
        lgList.add(TestUtility.createLoadingGroup('Markit', 'Markit Lg3', false));
        lgList.add(TestUtility.createLoadingGroup('Markit', 'Markit Lg4', false));
        insert lgList;
        
        Id standardId = Test.getStandardPricebookId();
        List<Product2> productList = new List<Product2>();
        productList.add(TestUtility.createProductWithLoadingGroup('Test Product1', lgList.get(0).id, false));
        productList.add(TestUtility.createProductWithLoadingGroup('Test Product2', lgList.get(0).id, false));
        productList.add(TestUtility.createProductWithLoadingGroup('Test Product3', lgList.get(1).id, false));
        productList.add(TestUtility.createProductWithLoadingGroup('Test Product4', lgList.get(2).id, false));
        productList.add(TestUtility.createProductWithLoadingGroup('Test Product5', lgList.get(2).id, false));
        productList.add(TestUtility.createProductWithLoadingGroup('Test Product6', lgList.get(3).id, false));
        insert productList;
        
        List<PricebookEntry> pbeList = new List<PricebookEntry>();
        pbeList.add(TestUtility.createPriceBookEntry(standardId, productList.get(0).id, false));
        pbeList.add(TestUtility.createPriceBookEntry(standardId, productList.get(1).id, false));
        pbeList.add(TestUtility.createPriceBookEntry(standardId, productList.get(2).id, false));
        pbeList.add(TestUtility.createPriceBookEntry(standardId, productList.get(3).id, false));
        pbeList.add(TestUtility.createPriceBookEntry(standardId, productList.get(4).id, false));
        pbeList.add(TestUtility.createPriceBookEntry(standardId, productList.get(5).id, false));
        insert pbeList;

        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        oliList.add(TestUtility.createOpportunityLineItem(testOpportunity.Id, pbeList.get(0), false));
        oliList.add(TestUtility.createOpportunityLineItem(testOpportunity.Id, pbeList.get(1), false));
        oliList.add(TestUtility.createOpportunityLineItem(testOpportunity.Id, pbeList.get(2), false));
        oliList.add(TestUtility.createOpportunityLineItem(testOpportunity.Id, pbeList.get(3), false));
        oliList.add(TestUtility.createOpportunityLineItem(testOpportunity.Id, pbeList.get(4), false));
        oliList.add(TestUtility.createOpportunityLineItem(testOpportunity.Id, pbeList.get(5), false));
        insert oliList;
    }

    //-----------------------------
    // @author: Vishnu Vardhan Chowdary
    // @date: 12 Mar 2018
    // @description: SFDC1-7740 Test method to test if cases are created or not for order form contract.
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    public static void testCaseCreationFromOrderFormContract() {
        Id implementationRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Implementation').getRecordTypeId();
        Id ofRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
        Id contractRecId = ContractRecordTypeSelectionController.createDefaultRecord(ofRecordTypeId, testOpportunity.Id);

        Test.startTest();
        Contract testContract = [Select id, status, Fastrack__c from contract where Id=: contractRecId];
        testContract.ContractStatus__c = 'Validated PO Pending';
        testcontract.Fastrack__c = true;
        update testContract;
        List<Case> caseList = [select recordType.Name, id, type, description, owner.Name from case where contract__c =:testContract.id and recordTypeId = :implementationRecordTypeId];
        System.assertEquals(caseList.size(),2);
        for(Case cas : caseList) {
            System.assertEquals('New Contract', cas.Type);
            System.assert(cas.Description.contains('Test Product'));
        } 
		//When contract is changed from Validated to validated PO pending then new cases shouldnt be created.
        testContract.ContractStatus__c = 'Validated';
        update testContract;
        caseList = [select recordType.Name, id, type, description, owner.Name from case where contract__c =:testContract.id and recordTypeId = :implementationRecordTypeId];
        System.assertEquals(caseList.size(),2);
        //Recreation of Impl cases should happen if the Contract is moved to Scheduled Termination
        testContract.Status = 'Complete';
        testContract.ContractStatus__c = 'Scheduled Termination';
        update testContract;
        caseList = [select recordType.Name, id, type, description, owner.Name from case where contract__c =:testContract.id and recordTypeId = :implementationRecordTypeId];
        System.assertEquals(caseList.size(),4);
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Vishnu Vardhan Chowdary
    // @date: 12 Mar 2018
    // @description: Test method to test if cases are created or not for a trial contract.
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    public static void testCaseCreationFromTrialContract() {
        Id trialRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();
        Opportunity testOpportunity = [SELECT Id, (select id from OpportunityLineItems) FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
        List<Id> oliIds = new List<Id>();
        for (OpportunityLineItem oliId : testOpportunity.OpportunityLineItems) {
            oliIds.add(oliId.id);
        }
        Id contractRecId = ContractRecordTypeSelectionController.createTrialContractRecord(testOpportunity.Id,System.JSON.serialize(oliIds));

        Test.startTest();
        Contract testContract = [Select id, status, Fastrack__c from contract where Id=: contractRecId];
        testContract.contractStatus__c = 'Signed By Customer';
        testContract.Status = 'ReadyForProcessing';
        testcontract.Fastrack__c = true;
        //testcontract.AutoRenewal__c = true;
        testcontract.PriceIncreaseClause__c = 'Standard Contract Price Increase';
        testcontract.NoInternalApprovalNeeded__c = true;
        update testContract;
        List<Case> caseList = [select recordType.Name, id, type, description, owner.Name from case where contract__c =:testContract.id];
        System.assertEquals(caseList.size(),4);
        for(Case cas : caseList) {
            System.assertEquals('Trial', cas.Type);
            System.assert(cas.Description.contains('Test Product'));
        }

        testContract.Status = 'Creation';
        update testContract;
        //Recreation of cases shouldnot happen if the contract returns to same status
        testContract.Status = 'ReadyForProcessing';
        caseList = [select recordType.Name, id, owner.Name from case where contract__c =:testContract.id];
        System.assertEquals(caseList.size(),4);
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Vishnu Vardhan Chowdary
    // @date: 24 May 2018
    // @description: Test method to test if cases are created or not for a Continuation letter contract.
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    public static void testCaseCreationFromContLetterContract() {
        Id ofRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
        Id ofcontractRecId = ContractRecordTypeSelectionController.createDefaultRecord(ofRecordTypeId, testOpportunity.Id);
        Id continuationLetterRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Continuation Letter').getRecordTypeId();
        Id contractRecId = ContractRecordTypeSelectionController.createDefaultRecord(continuationLetterRecordTypeId,testOpportunity.Id);

        Test.startTest();
        Contract testContract = [Select id, OriginalContract__C, status, Fastrack__c from contract where Id=: contractRecId];
        testContract.OriginalContract__C = ofcontractRecId;
        testContract.Status = 'ReadyForProcessing';
        testcontract.Fastrack__c = true;
        //testcontract.AutoRenewal__c = true;
        testcontract.PriceIncreaseClause__c = 'Standard Contract Price Increase';
        testcontract.NoInternalApprovalNeeded__c = true;
        update testContract;
        List<Case> caseList = [select recordType.Name, id, type, description, owner.Name from case where contract__c =:testContract.id];
        System.assertEquals(caseList.size(),4);
        for(Case cas : caseList) {
            System.assertEquals('Continuation', cas.Type);
            System.assert(cas.Description.contains('Test Product'));
        }

        testContract.Status = 'Creation';
        update testContract;
        //Recreation of cases shouldnot happen if the contract returns to same status
        testContract.Status = 'ReadyForProcessing';
        caseList = [select recordType.Name, id, owner.Name from case where contract__c =:testContract.id];
        System.assertEquals(caseList.size(),4);
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Ankita Singh
    // @date: 26 April 2018
    // @description: Test method to test updateCaseAndOppoStatusContract method on contractMethod
    // @param: 
    // @return: void
    // @author: Vishnu 
    // @date: 10 May 2018
    // @Description: Fixing test case, that is failing after introducing new validation rule.
    //-----------------------------
    @isTest
    public static void testupdateCaseAndOppoStatusContract() {
        Id ofRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id OMRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Order Management').getRecordTypeId();
         Account ihsMarkitAccount = TestUtility.createTestAccountWithAddress('IHS Markit', 
                                                                  '4th floor Ropemaker Place, 25 Ropemaker Street',
                                                                  'London', '', 'GB', true);
        String testEmail = 'dgtest@ihsmarkit.com';
        Contact myTestContact = TestUtility.createContact(ihsMarkitAccount.Id, testEmail, true, 'Test', 'Contact');
        Opportunity testOpportunity = [SELECT Id,stageName FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
        testOpportunity.ContractStartDate__c = System.today();
        testOpportunity.ContractEndDate__c = System.today();
        testOpportunity.ActivityCreated__c = true;
        update testOpportunity;
        Id contractRecId = ContractRecordTypeSelectionController.createDefaultRecord(ofRecordTypeId, testOpportunity.Id);
        Case testCase1 = new Case();
        testCase1.subject = 'Test subject Case status 1';
        testCase1.Contract__c= contractRecId;
        testCase1.RecordTypeId = OMRecordTypeId;
        testCase1.ContactId = myTestContact.id;
        testCase1.Status = 'Rejected';
        testCase1.ReasonforRejection__c = 'Incorrect Data Entry';
        insert testCase1;
        Test.startTest();

        Contract testContract = new Contract(id=contractRecId,ContractRejectionPastDue__c = TRUE,Fastrack__c = true);
        update testContract;
        Case caseStatus = [Select id,status from case where id=:testCase1.id];
        Opportunity oppStage = [Select stageName from Opportunity where id=:testOpportunity.id];
        system.assertEquals('Canceled', caseStatus.Status);
        system.assertEquals('5-Contracting', oppStage.StageName);
        Test.stopTest();        
    }
    
        //-----------------------------
    // @author: Ankita Singh
    // @date: 26 April 2018
    // @description: Test method to test negative scenario updateCaseAndOppoStatusContract method on contractMethod
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    public static void testupdateCaseAndOppoStatusContractNegativeTest() {
        Id ofRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id OMRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Order Management').getRecordTypeId();
        Id RenewalRecordTypeId = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Account ihsMarkitAccount = TestUtility.createTestAccountWithAddress('IHS Markit', 
                                                                  '4th floor Ropemaker Place, 25 Ropemaker Street',
                                                                  'London', '', 'GB', true);
        String testEmail = 'dgtest@ihsmarkit.com';
        Contact myTestContact = TestUtility.createContact(ihsMarkitAccount.Id, testEmail, true, 'Test', 'Contact');
        
        Opportunity testOpportunity = [SELECT Id,stageName, recordTypeId FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
       
        Id contractRecId = ContractRecordTypeSelectionController.createDefaultRecord(ofRecordTypeId, testOpportunity.Id);
        Case testCase1 = new Case();
        testCase1.subject = 'Test subject Case status 1';
        testCase1.Contract__c= contractRecId;
        testCase1.RecordTypeId = OMRecordTypeId;
        testCase1.ContactId = myTestContact.id;
        testCase1.Status = 'New';
        insert testCase1;
        Test.startTest();

        Contract testContract = new Contract(id=contractRecId,ContractRejectionPastDue__c = TRUE,Fastrack__c = true);
        update testContract;
         
        system.assertNotEquals('Closed - Canceled', testCase1.Status);
        system.assertNotEquals('5-Contracting', testOpportunity.StageName);
        Test.stopTest();
        
    }

    //-----------------------------
    // @author: Vishnu Vardhan Chowdary
    // @date: 11 May 2018
    // @description: Test method to test createOrModifyOMCasesForOrderFormContracts method on contractMethod
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    public static void testOMCaseCreationForOrderFormContract() {
        Id ofRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id OMRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Order Management').getRecordTypeId();
        Id RenewalRecordTypeId = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Account ihsMarkitAccount = TestUtility.createTestAccountWithAddress('IHS Markit', 
                                                                  '4th floor Ropemaker Place, 25 Ropemaker Street',
                                                                  'London', '', 'GB', true);
        String testEmail = 'dgtest@ihsmarkit.com';
        Contact myTestContact = TestUtility.createContact(ihsMarkitAccount.Id, testEmail, true, 'Test', 'Contact');

        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
        Id contractRecId = ContractRecordTypeSelectionController.createDefaultRecord(ofRecordTypeId, testOpportunity.Id);

        Test.startTest();
        Contract testContract = [Select id, status, Fastrack__c, AutoRenewal__c from contract where Id=: contractRecId];
        testContract.Status = 'ReadyForProcessing';
        testContract.ContractStatus__c = 'Signed by Customer';
        testcontract.Fastrack__c = true;
        testcontract.AutoRenewal__c = true;
        testcontract.PriceIncreaseClause__c = 'Standard Contract Price Increase';
        testContract.NoInternalApprovalNeeded__c = true;
        update testContract;
        system.debug('testContract--->'+testContract);
        List<Case> caseList = [select recordType.Name, id, Status, AutoRenewal__c from case where contract__c =:testContract.id];       
        system.debug('caseList--->'+caseList);
        System.assertEquals(caseList.size(),1);
        
        Case cas = caseList.get(0);
        System.assert(cas.AutoRenewal__c);        

        testContract.Status = 'Generation';
        testcontract.AutoRenewal__c = false;
        testContract.ContractStatus__c = 'Signed By Customer';
        update testContract;
        
        cas.Status = 'Rejected';
        cas.ReasonForRejection__c = 'EU Company VAT #';
        update cas;

        testContract.Status = 'ReadyForProcessing';
        update testContract;
        
        //If case is rejected then status should be Updated and rest of the fields to be copied.
        caseList = [select recordType.Name, id, Status, AutoRenewal__c from case where contract__c =:testContract.id];
        System.assertEquals(caseList.size(),1);
        cas = caseList.get(0);
        System.assertEquals(false,cas.AutoRenewal__c);
        System.assertEquals('Updated',cas.Status);
        Test.stopTest();
    }
    //-----------------------------
    // @author: Sruti Srivastava
    // @date: 12 May 2018
    // @description: Test method to test updateOppTo6WPClosedWonOPWhenOrderFormIsCompleted method on contractMethods class
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    static void testUpdateOppTo6WPClosedWonOPWhenOrderFormIsCompleted() {
        //Order Management profile
        Profile p = [SELECT Id ,name FROM Profile WHERE Name like '%Order management%' limit 1];
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', firstName='test',HRManager__c='manager',LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123@ihsihs.com',ADID__c='test'+system.now().millisecond(),EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
        insert u;
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        //Creating Contract
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract = TestUtility.createContractWithInsertOptional(testAccount.Id, legalEntity.Id, country.Id, standardId,FALSE);
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        contract.recordtypeid = orderFormRecordTypeId;
        insert contract;
        //creating an Opportunity 
        Id ofRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Opportunity testOpportunity = [SELECT Id,stageName FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
        testOpportunity.ContractStartDate__c = System.today();
        testOpportunity.ContractEndDate__c = System.today().addDays(30);
        testOpportunity.CloseDate = System.today().addDays(35);
        testOpportunity.ActivityCreated__c = true;
        testOpportunity.RecordTypeId = OppRecordTypeId;
        testOpportunity.ContractBeingRenewed__c = contract.Id;
        update testOpportunity;
            
        Test.startTest();
        //when Contract is updated by OM profile, opportunity should be updated
        System.runAs(u) {
            Id contractRecId = ContractRecordTypeSelectionController.createDefaultRecord(ofRecordTypeId, testOpportunity.Id);
            Contract testContract = new Contract(id=contractRecId,ContractRejectionPastDue__c = TRUE,Fastrack__c = true, 
                                                 Status='Complete');
            update testContract;
        }
        Test.stopTest();
        //Verifying if Opportunity stage is updated correctly
        Opportunity oppStage = [Select stageName from Opportunity where id=:testOpportunity.id];
        system.assertEquals( oppStage.StageName.contains('6WP'), true);
    }

    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 22 May 2018
    // @description: Test method for updateCountersignatureFields Contract method on Master Agreement record type
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    public static void testUpdateCountersignatureFieldsForMasterAgreement() {
        Id masterAgreementRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Master Agreement').getRecordTypeId();
        
        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
        Id contractRecId = ContractRecordTypeSelectionController.createDefaultRecord(masterAgreementRecordTypeId, testOpportunity.Id);

        Test.startTest();
        Contract testContract = [Select Id, Status, ContractStatus__c, Fastrack__c, AutoRenewal__c from contract where Id=: contractRecId];
        System.debug('SFDC1-7680 Contract Stage: ' + testContract.Status);
        testContract.Status = 'ReadyForProcessing';
        testContract.ContractStatus__c = 'Signed By Customer';
        testcontract.Fastrack__c = true;
        testcontract.AutoRenewal__c = true;
        testContract.NoInternalApprovalNeeded__c = true;
        testcontract.PriceIncreaseClause__c = 'Standard Contract Price Increase';
        update testContract;
        
        testContract = [Select id, status, CountersignatureStatus__c, CountersignatureOwner__c from contract where Id=: contractRecId];
        // assertion for SFDC1-7680
        System.assertEquals('New', testContract.CountersignatureStatus__c);
        System.assertEquals(UserInfo.getUserId(), testContract.CountersignatureOwner__c);

        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 22 May 2018
    // @description: Test method for updateCountersignatureFields Contract method on Order Form record type
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    public static void testUpdateCountersignatureFieldsForOrderForm() {
        Id oderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        
        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
        Id contractRecId = ContractRecordTypeSelectionController.createDefaultRecord(oderFormRecordTypeId, testOpportunity.Id);

        Test.startTest();
        Contract testContract = [Select Id, Status, ContractStatus__c, Fastrack__c, AutoRenewal__c from contract where Id=: contractRecId];
        System.debug('SFDC1-7680 Contract Status: ' + testContract.ContractStatus__c);
        testContract.ContractStatus__c = 'Validated PO Pending';
        testcontract.Fastrack__c = true;
        testcontract.AutoRenewal__c = true;
        update testContract;
        
        testContract = [Select id, status, CountersignatureStatus__c, CountersignatureOwner__c from contract where Id=: contractRecId];
        // assertion for SFDC1-7680
        System.assertEquals('New', testContract.CountersignatureStatus__c);
        System.assertEquals(UserInfo.getUserId(), testContract.CountersignatureOwner__c);

        testContract.ContractStatus__c = 'Validated';
        update testContract;
        
        testContract = [Select id, status, CountersignatureStatus__c, CountersignatureOwner__c from contract where Id=: contractRecId];
        // assertion for SFDC1-8252
        System.assertEquals('Complete', testContract.Status);
        
        Test.stopTest();
    }
         //-----------------------------
    // @author: Prachi Bhasin
    // @date: 25 May 2018
    // @description: Test method to test updateOppTo6WPClosedWonOPWhenOrderFormIsCompleted method in contractMethods class
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    static void testUpdateNoticeAddressFieldsOnContractFromLegalEntity() {
        Id ofRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Account acc = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        acc.DataGovernanceStatus__c = 'Approved';
        insert acc;
        
        LegalEntity__c legalEntity = new LegalEntity__c();
        legalEntity.Name = 'test';
        legalEntity.CurrencyIsoCode = 'USD';
        legalEntity.Status__c = 'Active';
        legalEntity.AddressLine1__c = 'street1';
        legalEntity.AddressLine2__c = 'street2';
        legalEntity.AddressLine3__c = 'street3';
        legalEntity.City__c = 'city';
        legalEntity.StateOrProvinceNew__c = 'IA';
        insert legalEntity;
        Test.startTest();
        Opportunity testOpportunity = TestUtility.createOpportunity(acc.Id, 'test Opppy', true);
        Id contractRecId = ContractRecordTypeSelectionController.createDefaultRecord(ofRecordTypeId, testOpportunity.Id);   
        Contract defaultContract = [Select id, accountId from contract where Id=: contractRecId];
        defaultContract.IHSMarkitLegalEntity__c = legalEntity.id;
        defaultContract.Fastrack__c = true;
        update defaultContract;
        String state = [Select id, accountId,IHSMarkitLegalEntityStateProvinceNew__c from contract where Id=: contractRecId].IHSMarkitLegalEntityStateProvinceNew__c;
        System.assertEquals(state,'Iowa');
        
        defaultContract.IHSMarkitLegalEntity__c = NULL;
        update defaultContract;
        state = [Select id, accountId,IHSMarkitLegalEntityStateProvinceNew__c from contract where Id=: contractRecId].IHSMarkitLegalEntityStateProvinceNew__c;
        System.assertEquals(String.isBlank(state),true);
        Test.stopTest();
    }
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 25 May 2018
    // @description: Test method to test updateOppTo6WPClosedWonOPWhenOrderFormIsCompleted method in contractMethods class
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    static void testUpdateAddressOnRenewalOppty() {
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        //Creating Contract
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract = TestUtility.createContractWithInsertOptional(testAccount.Id, legalEntity.Id, country.Id, standardId,FALSE);
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        contract.recordtypeid = orderFormRecordTypeId;
        insert contract;
        //creating an Opportunity 
        Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', false);
        testOpportunity.ContractStartDate__c = System.today();
        testOpportunity.StageName= '3-Renewal Pending';
        testOpportunity.ContractEndDate__c = System.today().addDays(30);
        testOpportunity.CloseDate = System.today().addDays(35);
        testOpportunity.ActivityCreated__c = true;
        testOpportunity.RecordTypeId = OppRecordTypeId;
        testOpportunity.ContractBeingRenewed__c = contract.Id;
        insert testOpportunity;
        contract.BillToCity__c = 'city1';
        contract.Fastrack__c = true;
        contract.BillToClientName__c = 'client name 1';
        update contract;
        Opportunity opp = [Select id, BillToCity__c from Opportunity where id =: testOpportunity.id];
        System.assertEquals(opp.BillToCity__c ,'city1');
    }
    
    //-----------------------------
    // @author: Ankita Singh
    // @date: 14 June 2018
    // @description: Test method to test validateLegalEntityOnContract method in contractMethods class
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    static void testValidateLegalEntityOnConsultingContract() {
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        //Creating Contract
        Id consultingRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Consulting').getRecordTypeId();
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        LegalEntity__c legalEntityWithEligibleFields = TestUtility.createLegalEntityWithEligibleFields('testLegalEntity1','USD',TRUE);
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract = TestUtility.createContractWithInsertOptional(testAccount.Id, legalEntity.Id, country.Id, standardId,FALSE);  
        contract.recordtypeid = consultingRecordTypeId;
        insert contract;    
        // Updating Contract
        contract.BillToCity__c = 'city1';
        contract.Fastrack__c = true;
        contract.BillToClientName__c = 'client name 1';
        contract.IHSMarkitLegalEntity__c = legalEntityWithEligibleFields.id;
        try {
            //Verify that update will fail, as LegalEntity selected for contract is not availble for this record type
            update contract;
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(Label.LegalEntityErrorOnContract) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
        //-----------------------------
    // @author: Ankita Singh
    // @date: 14 June 2018
    // @description: Test method to test validateLegalEntityOnContract method in contractMethods class
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    static void testValidateLegalEntityOnTrailContract() {
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        //Creating Contract
        Id trialRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        LegalEntity__c legalEntityWithEligibleFields = TestUtility.createLegalEntityWithEligibleFields('testLegalEntity1','USD',TRUE);
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract = TestUtility.createContractWithInsertOptional(testAccount.Id, legalEntity.Id, country.Id, standardId,FALSE);      
        contract.recordtypeid = trialRecordTypeId;
        insert contract;    
        // Updating Contract
        contract.BillToCity__c = 'city1';
        contract.Fastrack__c = true;
        contract.BillToClientName__c = 'client name 1';
        contract.IHSMarkitLegalEntity__c = legalEntityWithEligibleFields.id;
        try {
            //Verify that update will fail, as LegalEntity selected for contract is not availble for this record type
            update contract;
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(Label.LegalEntityErrorOnContract) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
        //-----------------------------
    // @author: Ankita Singh
    // @date: 14 June 2018
    // @description: Test method to test validateLegalEntityOnContract method in contractMethods class
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    static void testValidateLegalEntityOnConLetterContract() {
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        //Creating Contract
        Id continuationLetterRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Continuation Letter').getRecordTypeId();
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        LegalEntity__c legalEntityWithEligibleFields = TestUtility.createLegalEntityWithEligibleFields('testLegalEntity1','USD',TRUE);
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract = TestUtility.createContractWithInsertOptional(testAccount.Id, legalEntity.Id, country.Id, standardId,FALSE);      
        contract.recordtypeid = continuationLetterRecordTypeId;
        insert contract;
        // Updating Contract
        contract.BillToCity__c = 'city1';
        contract.Fastrack__c = true;
        contract.BillToClientName__c = 'client name 1';
        contract.IHSMarkitLegalEntity__c = legalEntityWithEligibleFields.id;
        try {
            //Verify that update will fail, as LegalEntity selected for contract is not availble for this record type
            update contract;
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(Label.LegalEntityErrorOnContract) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
        //-----------------------------
    // @author: Ankita Singh
    // @date: 14 June 2018
    // @description: Test method to test validateLegalEntityOnContract method in contractMethods class
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    static void testValidateLegalEntityOnDPAContract() {
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        //Creating Contract
        Id DPARecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('DPA').getRecordTypeId();
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        LegalEntity__c legalEntityWithEligibleFields = TestUtility.createLegalEntityWithEligibleFields('testLegalEntity1','USD',TRUE);
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract = TestUtility.createContractWithInsertOptional(testAccount.Id, legalEntity.Id, country.Id, standardId,FALSE);
        contract.recordtypeid = DPARecordTypeId;
        insert contract;    
        // Updating Contract
        contract.BillToCity__c = 'city1';
        contract.Fastrack__c = true;
        contract.BillToClientName__c = 'client name 1';
        contract.IHSMarkitLegalEntity__c = legalEntityWithEligibleFields.id;
        try {
            //Verify that update will fail, as LegalEntity selected for contract is not availble for this record type
            update contract;
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(Label.LegalEntityErrorOnContract) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
        //-----------------------------
    // @author: Ankita Singh
    // @date: 14 June 2018
    // @description: Test method to test validateLegalEntityOnContract method in contractMethods class
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    static void testValidateLegalEntityOnMSTContract() {
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        //Creating Contract
        Id MSTRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Managed Service Terms (MST)').getRecordTypeId();
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        LegalEntity__c legalEntityWithEligibleFields = TestUtility.createLegalEntityWithEligibleFields('testLegalEntity1','USD',TRUE);
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract = TestUtility.createContractWithInsertOptional(testAccount.Id, legalEntity.Id, country.Id, standardId,FALSE);
        contract.recordtypeid = MSTRecordTypeId;
        insert contract;    
        //Updating Contract
        contract.BillToCity__c = 'city1';
        contract.Fastrack__c = true;
        contract.BillToClientName__c = 'client name 1';
        contract.IHSMarkitLegalEntity__c = legalEntityWithEligibleFields.id;
        try {
            //Verify that update will fail, as LegalEntity selected for contract is not availble for this record type
            update contract;
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(Label.LegalEntityErrorOnContract) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
        //-----------------------------
    // @author: Ankita Singh
    // @date: 14 June 2018
    // @description: Test method to test validateLegalEntityOnContract method in contractMethods class
    // @param: 
    // @return: void
    //-----------------------------
    @isTest
    static void testValidateLegalEntityOnMasterContract() {
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        //Creating Contract
        Id masterAgreementRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Master Agreement').getRecordTypeId();
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        LegalEntity__c legalEntityWithEligibleFields = TestUtility.createLegalEntityWithEligibleFields('testLegalEntity1','USD',TRUE);
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract = TestUtility.createContractWithInsertOptional(testAccount.Id, legalEntity.Id, country.Id, standardId,FALSE);
        contract.recordtypeid = masterAgreementRecordTypeId;
        insert contract;
        // Updating Contract
        contract.BillToCity__c = 'city1';
        contract.Fastrack__c = true;
        contract.BillToClientName__c = 'client name 1';
        contract.IHSMarkitLegalEntity__c = legalEntityWithEligibleFields.id;
        try {
            //Verify that update will fail, as LegalEntity selected for contract is not availble for this record type
            update contract;
        } catch (Exception e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains(Label.LegalEntityErrorOnContract) ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 26 Jun 2018
    // @description: SFDC1-8533 Test method for UpdateTotalAnnualContractValueOnOpp() method in ContractMethods class
    // @param: None
    // @return: None
    //-----------------------------
    @isTest
    private static void testUpdateTotalAnnualContractValueOnOpp() {
        //TEST SCENARIO: For NEW BUSINESS Opportunity        
        //Test Opportunity of New Business record type
        Opportunity testOpportunity = [SELECT Id,AccountId,RecordType.Name FROM Opportunity WHERE Name='test Opppy' LIMIT 1];        
        
        //Create test Order Form contract for New Business test opportunity        
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id orderFormContractId = ContractRecordTypeSelectionController.createDefaultRecord(orderFormRecordTypeId, testOpportunity.Id);
        Contract testContract = [Select Id,(Select Id,FirstYear__c From Contract_Line_Items__r) 
                                 From contract Where Id=: orderFormContractId];        
        
        //Update prices on Contract Line Items
        if(testContract!=null && testContract.Contract_Line_Items__r!=null && testContract.Contract_Line_Items__r.size()>0) {            
            testContract.Contract_Line_Items__r[0].FirstYear__c = 100;            
            update testContract.Contract_Line_Items__r[0];
            
            Opportunity oppOutput1 = [Select Id,TotalAnnualContractValue__c From Opportunity Where Id =:testOpportunity.Id];            
            System.assertEquals(100,oppOutput1.TotalAnnualContractValue__c);
        }
        
        
        
        //TEST SCENARIO: For RENEWAL Opportunity
        //Insert another test Account
        Account testAccount = TestUtility.createTestAccount('Test Account', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;        
        
        //Create test Contact
        Contact testContact = TestUtility.createContact(testAccount.Id, 'test2contact2ihsmarkit@testihsmarkit.com',true, 'Test2', 'Contact2');        
        
        //Create Product Data
        Product2 testProd = TestUtility.createProduct('Test Product', false);
        testProd.FormerIpOwner__c = 'IHS Markit Global Inc.';
        //testProd.Family__c = testProdFam.Id;
        //testProd.ProfitCenters__c = testProfitCenter.Id;
        //testProd.ProductStatus__c = testPlantStatus.Id;
        insert testProd;
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);                
        
        //Create Renewal Opportunity        
        Id renewalOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Opportunity testOpportunity2 = TestUtility.createOpportunity(testAccount.Id, 'test Renewal Opportunity', false);
        testOpportunity2.RecordTypeId = renewalOppRecordTypeId;
        testOpportunity2.StageName = '3-Renewal Pending';
        testOpportunity2.ContractBeingRenewed__c = testContract.Id;
        testOpportunity2.AutoRenewal__c = true;
        testOpportunity2.SAPContractNumber__c = 'testSAPContract123';
        testOpportunity2.ContractStartDate__c = Date.Today().addDays(-30);
        testOpportunity2.ContractEndDate__c = Date.Today().addDays(30);
        insert testOpportunity2;
        
        //Set Primary Contact on Renewal Opportunity        
        OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId = testOpportunity2.Id, ContactId = testContact.Id, IsPrimary=true);
        insert ocr;
        
        Test.startTest();
        
        //Creating Opportunity Line Items, Product Schedule,Opportunity Line Item Schedule        
        OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity2.Id, testPBE, true);
        
        //Create Contract for Renewal Opportunity        
        Id testContract2Id = ContractRecordTypeSelectionController.createDefaultRecord(orderFormRecordTypeId, testOpportunity2.Id);
        Contract testContract2 = [Select id, status, Fastrack__c,RecordType.Name,(Select Id,FirstYear__c From Contract_Line_Items__r) 
                                 from contract where Id=: testContract2Id];        
        
        //Update Contract Line Item prices
        if(testContract2.Contract_Line_Items__r!=null && testContract2.Contract_Line_Items__r.size()>0) {            
            testContract2.Contract_Line_Items__r[0].FirstYear__c = 100;                            
            update testContract2.Contract_Line_Items__r[0];
            
            Opportunity oppOutput2 = [Select Id,TotalAnnualContractValue__c From Opportunity Where Id =:testOpportunity2.Id];            
            System.assertEquals(200,oppOutput2.TotalAnnualContractValue__c);
        }
        
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 27 Jun 2018
    // @description: SFDC1-8533 Test method for setOpptyOwnerEmail() method in ContractMethods class
    // @param: None
    // @return: None
    //-----------------------------
    @isTest
    private static void testSetOpptyOwnerEmail() {
        //Test Opportunity of New Business record type
        Opportunity testOpportunity = [SELECT Id,AccountId,Opportunity.OwnerId,Opportunity.Owner.Email,RecordType.Name FROM Opportunity WHERE Name='test Opppy' LIMIT 1];                
        
        //Create test Order Form contract for New Business test opportunity        
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id orderFormContractId = ContractRecordTypeSelectionController.createDefaultRecord(orderFormRecordTypeId, testOpportunity.Id);
        Contract testContract = new Contract(Id=orderFormContractId);
        //Set CancelRequestReceivedDate__c on test Contract
        testContract.Fastrack__c = true;
        testContract.CancelRequestReceivedDate__c = System.today() + 10;
        update testContract;        
        System.assertEquals(testOpportunity.Owner.Email,[Select Id,OpptyOwnerEmail__c From Contract Where Id=:testContract.Id].OpptyOwnerEmail__c );
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 27 Jun 2018
    // @description: SFDC1-8533 Test method for updateOpptyContractStartEndDates() method in ContractMethods class
    // @param: None
    // @return: None
    //-----------------------------
    @isTest
    private static void testUpdateOpptyContractStartEndDates() {
        //Test Opportunity of New Business record type
        Opportunity testOpportunity = [SELECT Id,StageName,AccountId FROM Opportunity WHERE Name='test Opppy' LIMIT 1];                
                        
        //Create test Order Form contract for New Business test opportunity        
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id orderFormContractId = ContractRecordTypeSelectionController.createDefaultRecord(orderFormRecordTypeId, testOpportunity.Id);
        Contract testContract = new Contract(Id=orderFormContractId);
        
        //Update Contract Stage to Ready For Processing
        testContract.Fastrack__c = true;
        testContract.PriceIncreaseClause__c = 'Standard Contract Price Increase';
        testContract.Status = 'ReadyForProcessing';
        testContract.ContractStatus__c = 'Signed By Customer';
        testContract.NoInternalApprovalNeeded__c = true;
        update testContract;
        
        Test.startTest();
        
        //Setting opportunity as Won
        testOpportunity.StageName = '6W-Closed Won';
        update testOpportunity;        
        
        //Create child opportunity of Contract
        Opportunity testChildOpportunity = TestUtility.createOpportunity(testOpportunity.AccountId, 'Test Child Opportunity for Contract', false);
        testChildOpportunity.ContractId = testContract.Id;
        insert testChildOpportunity;        
        
        testContract.StartDate = System.today();
        testContract.EndDate = System.today()+365;
        update testContract;        
        
        Opportunity outputRecord = [Select Id,ContractStartDate__c,ContractEndDate__c From Opportunity Where Id =:testChildOpportunity.Id];        
        System.assertEquals(testContract.StartDate, outputRecord.ContractStartDate__c);
        System.assertEquals(testContract.EndDate, outputRecord.ContractEndDate__c);
        
        
        //Setting Opportunity as Lost
        testOpportunity.StageName = '6L-Closed Lost';
        testOpportunity.LostReasonCode__c='Competition';
        testOpportunity.LostReasonDescription__c='Test Loss Reason Description';
        update testOpportunity;
        
        testContract.StartDate = System.today()+10;
        testContract.EndDate = System.today()+70;
        update testContract;
        
        Opportunity outputRecord2 = [Select Id,ContractStartDate__c,ContractEndDate__c From Opportunity Where Id =:testChildOpportunity.Id];        
        System.assertEquals(testContract.StartDate, outputRecord2.ContractStartDate__c);
        System.assertEquals(testContract.EndDate, outputRecord2.ContractEndDate__c);
        
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 28 Jun 2018
    // @description: SFDC1-8533 Test method #1 for updateStageOnOpp() method in ContractMethods class - Test Scenarios for 'New Business' and 'Renewal' opportunity for 'Order Form' type Contract
    // @param: None
    // @return: None
    //-----------------------------
    @isTest
    private static void testUpdateStageOnOppOrderFormContract1() {
        //TEST SCENARIO: NEW BUSINESS Opportunity
        //Test Opportunity
        Opportunity testOpportunity = [SELECT Id,StageName,AccountId FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
                        
        //Create test Order Form contract for New Business test opportunity        
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();        
        Id orderFormContractId = ContractRecordTypeSelectionController.createDefaultRecord(orderFormRecordTypeId, testOpportunity.Id);        
        Contract testContract = [Select Id From contract Where Id=: orderFormContractId];
        
        Test.startTest();
        
        //Update Contract Stage to Ready For Processing
        testContract.Fastrack__c = true;
        testContract.NoInternalApprovalNeeded__c = true;
        testcontract.PriceIncreaseClause__c = 'Standard Contract Price Increase';
        testContract.Status = 'ReadyForProcessing';
        testContract.ContractStatus__c = 'Signed By Customer';
        update testContract;
        
        Opportunity outputRecord = [Select Id,StageName FROM Opportunity WHERE Id = :testOpportunity.Id];        
        System.assertEquals('6W-Closed Won', outputRecord.StageName);                
        
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 28 Jun 2018
    // @description: SFDC1-8533 Test method #2 for updateStageOnOpp() method in ContractMethods class - Test Scenarios for 'Renewal' opportunity for 'Order Form' type Contract
    // @param: None
    // @return: None
    //-----------------------------
    @isTest
    private static void testUpdateStageOnOppOrderFormContract2() {
        //TEST SCENARIO: RENEWAL Opportunity
        //Test Opportunity
        Opportunity testOpportunity = [SELECT Id,StageName,AccountId FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
        
        //Setting up renewal opportunity
        Id renewalOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        testOpportunity.RecordTypeId = renewalOppRecordTypeId;
        testOpportunity.StageName = '3-Renewal Pending';        
        testOpportunity.AutoRenewal__c = true;
        testOpportunity.SAPContractNumber__c = 'testSAPContract123';
        update testOpportunity;
        
        Test.startTest();
        
        //Create test Order Form contract for New Business test opportunity        
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();        
        Id orderFormContractId = ContractRecordTypeSelectionController.createDefaultRecord(orderFormRecordTypeId, testOpportunity.Id);        
        Contract testContract = [Select Id From contract Where Id=: orderFormContractId];
        
        //Update Contract Stage to Ready For Processing
        testContract.Fastrack__c = true;
        testContract.NoInternalApprovalNeeded__c = true;
        testcontract.PriceIncreaseClause__c = 'Standard Contract Price Increase';
        testContract.Status = 'ReadyForProcessing';
        testContract.ContractStatus__c = 'Signed By Customer';
        update testContract;
        
        Opportunity outputRecord2 = [Select Id,StageName FROM Opportunity WHERE Id = :testOpportunity.Id];        
        System.assertEquals('6W-Renewal Won', outputRecord2.StageName);
        
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 28 Jun 2018
    // @description: SFDC1-8533 Test method #3 for updateStageOnOpp() method in ContractMethods class - Test Scenarios for 'Forecasting Placeholder' and 'Gratis' opportunity for 'Order Form' type Contract
    // @param: None
    // @return: None
    //-----------------------------
    @isTest
    private static void testUpdateStageOnOppOrderFormContract3() {
        //TEST SCENARIO: FORECASTING PLACEHOLDER Opportunity
        //Setting up Forecasting Placeholder opportunity
        Opportunity testOpportunity = [SELECT Id,StageName,AccountId FROM Opportunity WHERE Name='test Opppy' LIMIT 1];        
        
        Id forecastingOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Forecasting Placeholder').getRecordTypeId();
        testOpportunity.RecordTypeId = forecastingOppRecordTypeId;  
        testOpportunity.StageName = '1-Open';
        update testOpportunity;
                        
        //Create test Order Form contract for New Business test opportunity        
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id orderFormContractId = ContractRecordTypeSelectionController.createDefaultRecord(orderFormRecordTypeId, testOpportunity.Id);
        Contract testContract = new Contract(Id = orderFormContractId);
                
        Test.startTest();
        
        //Update Contract Stage to Ready For Processing
        testContract.Fastrack__c = true;
        testContract.Status = 'ReadyForProcessing';
        testContract.ContractStatus__c = 'Signed By Customer';
        testContract.NoInternalApprovalNeeded__c = true;
        testcontract.PriceIncreaseClause__c = 'Standard Contract Price Increase';
        update testContract;
        
        Opportunity outputRecord = [Select Id,StageName FROM Opportunity WHERE Id = :testOpportunity.Id];        
        System.assertEquals('6W-Forecasting Placeholder', outputRecord.StageName);
        
        //TEST SCENARIO: GRATIS Opportunity    
        //Setting up Gratis opportunity
        Opportunity testGratisOpp = testOpportunity.clone(false, true, false, false);
        Id gratisOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Gratis').getRecordTypeId();   
        testGratisOpp.RecordTypeId = gratisOppRecordTypeId;
        testGratisOpp.Name = 'Test Gratis Opp';
        testGratisOpp.CloseDate = System.today()+30;
        testGratisOpp.FirstYearValue__c = 0;
        testGratisOpp.Amount = 0;
        testGratisOpp.StageName = '1-Open';     
        insert testGratisOpp;
        
        
        //Rolling back existing contract stage to '9-Generation'
        testContract.Status = 'Generation';
        testContract.Opportunity__c = testGratisOpp.Id;
        testContract.NoInternalApprovalNeeded__c = true;
        testcontract.PriceIncreaseClause__c = 'Standard Contract Price Increase';
        update testContract;
        
        //Update Contract Stage to Ready For Processing
        testContract.Status = 'ReadyForProcessing';
        
        update testContract;
        
        Opportunity outputRecord2 = [Select Id,StageName FROM Opportunity WHERE Id = :testGratisOpp.Id];
        System.assertEquals('6W-Closed Won', outputRecord2.StageName);
        
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 02 Jul 2018
    // @description: SFDC1-8955 Test method #4 for updateStageOnOpp() method in ContractMethods class - Test Scenarios for 'New Business' opportunity for 'Consulting' type Contract
    // @param: None
    // @return: None
    //-----------------------------
    @isTest
    private static void testUpdateStageOnOppForConsultingContract1() {
        //TEST SCENARIO: NEW BUSINESS Opportunity
        //Test Opportunity
        Opportunity testOpportunity = [SELECT Id,StageName,AccountId FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
                        
        //Create test Order Form contract for New Business test opportunity        
        Id consultingContractRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Consulting').getRecordTypeId();
        Id consultingContractId = ContractRecordTypeSelectionController.createDefaultRecord(consultingContractRecordTypeId, testOpportunity.Id);
        Contract testContract = new Contract(Id = consultingContractId);
        
        Test.startTest();
        
        //Update Contract Stage to Ready For Processing
        testContract.Fastrack__c = true;
        testContract.Status = 'ReadyForProcessing';
        testContract.ContractStatus__c = 'Signed By Customer';
        testContract.NoInternalApprovalNeeded__c = true;
        testcontract.PriceIncreaseClause__c = 'Standard Contract Price Increase';
        update testContract;        
        
        Opportunity outputRecord = [Select Id,StageName FROM Opportunity WHERE Id = :testOpportunity.Id];        
        System.assertEquals('6W-Closed Won', outputRecord.StageName);        
        
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 02 Jul 2018
    // @description: SFDC1-8955 Test method #5 for updateStageOnOpp() method in ContractMethods class - Test Scenarios for 'Renewal' opportunity for 'Consulting' type Contract
    // @param: None
    // @return: None
    //-----------------------------
    @isTest
    private static void testUpdateStageOnOppForConsultingContract2() {
        //TEST SCENARIO: RENEWAL Opportunity
        //Test Opportunity
        Opportunity testOpportunity = [SELECT Id,StageName,AccountId FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id orderFormContractId = ContractRecordTypeSelectionController.createDefaultRecord(orderFormRecordTypeId, testOpportunity.Id);
        Contract orderFormContract = new Contract(Id=orderFormContractId);
        orderFormContract.Fastrack__c = true;
        update orderFormContract;        
        
        Test.startTest();
        
        //Setting up renewal opportunity
        Id renewalOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        testOpportunity.RecordTypeId = renewalOppRecordTypeId;
        testOpportunity.StageName = '3-Renewal Pending';
        testOpportunity.ContractBeingRenewed__c = orderFormContractId;
        testOpportunity.AutoRenewal__c = true;
        testOpportunity.SAPContractNumber__c = 'testSAPContract123';
        update testOpportunity;        
        
        //Create test Order Form contract for New Business test opportunity                
        Id consultingContractRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Consulting').getRecordTypeId();        
        Id consultingContractId = ContractRecordTypeSelectionController.createDefaultRecord(consultingContractRecordTypeId, testOpportunity.Id);
        Contract testContract = new Contract(Id = consultingContractId);        
        
        //Update Contract Stage to Ready For Processing
        testContract.Fastrack__c = true;
        testContract.Status = 'ReadyForProcessing';
        testContract.ContractStatus__c = 'Signed By Customer';
        testContract.NoInternalApprovalNeeded__c = true;
        testcontract.PriceIncreaseClause__c = 'Standard Contract Price Increase';
        update testContract;        
        
        Opportunity outputRecord = [Select Id,StageName FROM Opportunity WHERE Id = :testOpportunity.Id];        
        System.assertEquals('6W-Renewal Won', outputRecord.StageName);
        
        Test.stopTest();
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 02 Jul 2018
    // @description: SFDC1-8955 Test method #6 for updateStageOnOpp() method in ContractMethods class - Test Scenarios for 'Forecasting Placeholder' opportunity for 'Consulting' type Contract
    // @param: None
    // @return: None
    //-----------------------------
    @isTest
    private static void testUpdateStageOnOppForConsultingContract3() {
        //TEST SCENARIO: FORECASTING Opportunity
        //Test Opportunity
        Opportunity testOpportunity = [SELECT Id,StageName,AccountId FROM Opportunity WHERE Name='test Opppy' LIMIT 1];        
        Id forecastingOppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Forecasting Placeholder').getRecordTypeId();
        testOpportunity.RecordTypeId = forecastingOppRecordTypeId;  
        testOpportunity.StageName = '1-Open';
        update testOpportunity;
        
        Test.startTest();
        
        //Create test Order Form contract for New Business test opportunity                
        Id consultingContractRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Consulting').getRecordTypeId();        
        Id consultingContractId = ContractRecordTypeSelectionController.createDefaultRecord(consultingContractRecordTypeId, testOpportunity.Id);
        Contract testContract = new Contract(Id = consultingContractId);        
        
        //Update Contract Stage to Ready For Processing
        testContract.Fastrack__c = true;
        testContract.Status = 'ReadyForProcessing';
        testContract.ContractStatus__c = 'Signed By Customer';
        testContract.NoInternalApprovalNeeded__c = true;
        testcontract.PriceIncreaseClause__c = 'Standard Contract Price Increase';
        update testContract;        
        
        Opportunity outputRecord = [Select Id,StageName FROM Opportunity WHERE Id = :testOpportunity.Id];        
        System.assertEquals('6W-Forecasting Placeholder', outputRecord.StageName);
        
        Test.stopTest();
    }
     
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 28 Jun 2018
    // @description: SFDC1-8533 Test method for updateCurrencyOnContractLineItems() method in ContractMethods class
    // @param: None
    // @return: None
    //-----------------------------
    @isTest
    private static void testUpdateCurrencyOnContractLineItems() {
        //Test Opportunity
        Opportunity testOpportunity = [SELECT Id,StageName,AccountId FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
                        
        //Create test Order Form contract for New Business test opportunity        
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id orderFormContractId = ContractRecordTypeSelectionController.createDefaultRecord(orderFormRecordTypeId, testOpportunity.Id);
        Contract testContract = [Select Id,CurrencyIsoCode,(Select Id,CurrencyIsoCode From Contract_Line_Items__r)
                                 From contract Where Id=: orderFormContractId];     
        
        testContract.Fastrack__c = true;
        testContract.CurrencyIsoCode = 'INR';        
        update testContract;
        
        for(ContractLineItem__c cli:[Select Id,CurrencyIsoCode From ContractLineItem__c Where Contract__c=:testContract.Id]) {
            System.assertEquals(testContract.CurrencyIsoCode, cli.CurrencyIsoCode);
        }
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 28 Jun 2018
    // @description: SFDC1-8533 Test method for updateAgreementEffectiveDateOnOrderFormAgreements() method in ContractMethods class
    // @param: None
    // @return: None
    //-----------------------------
    @isTest
    private static void testUpdateAgreementEffectiveDateOnOrderFormAgreements() {
        //Test Opportunity
        Opportunity testOpportunity = [SELECT Id,StageName,AccountId FROM Opportunity WHERE Name='test Opppy' LIMIT 1];        
        
        //Create Test Legal Entity
        LegalEntity__c testLegalEntity = new LegalEntity__c(Name='Test Legal Entity 123');
        insert testLegalEntity;
        
        //Create Master Agreement
        Id masterAgreementRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Master Agreement').getRecordTypeId();
        Contract masterAgreementContract = new Contract(RecordTypeId = masterAgreementRecordTypeId ,AccountId = testOpportunity.AccountId,IHSMarkitLegalEntity__c = testLegalEntity.Id, EffectiveDate__c = System.today(), ContractStatus__c = 'Executed');
        insert masterAgreementContract;        
        
        //Create test Order Form contract for New Business test opportunity        
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id orderFormContractId = ContractRecordTypeSelectionController.createDefaultRecord(orderFormRecordTypeId, testOpportunity.Id);
        Contract testContract = new Contract(Id = orderFormContractId);
        
        //Relate Master Agreement Contract with Order Form Contract
        testContract.GeneralAgreementType__c = 'IHS Markit Master Agreement';
        testContract.GeneralAgreement__c = masterAgreementContract.Id;
        update testContract;
        
        //Update Effective date on Master Agreement
        masterAgreementContract.EffectiveDate__c = System.today()+1;
        update masterAgreementContract;        
    }
    
    //-----------------------------
    // @author: Veriba
    // @company: VERTIBA
    // @date: 25 June 2018
    // @param: 
    // @description:  Test method to check if functionality is working.
    // @return: NA
    // @Modification : Updated code for new methods added for edit fucntionality.
    // @Modification date : Anjani Shukla:29 June2018 - SFDC1-7992 - Create OM Case on Contract Closed Lost Renewal.
    //-----------------------------
    
    static testMethod void testcreateOMCaseforOrignatngContract() {
        test.startTest();
        Id ofRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id OMRecordTypeId = Schema.Sobjecttype.Case.getRecordTypeInfosByName().get('Order Management').getRecordTypeId();
        Id RenewalRecordTypeId = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Account ihsMarkitAccount = TestUtility.createTestAccountWithAddress('IHS Markit', 
                                                                  '4th floor Ropemaker Place, 25 Ropemaker Street',
                                                                  'London', '', 'GB', true);
        String testEmail = 'dgtest@ihsmarkit.com';
        Contact myTestContact = TestUtility.createContact(ihsMarkitAccount.Id, testEmail, true, 'Test', 'Contact');

        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
        //Id contractRecId = ContractRecordTypeSelectionController.createDefaultRecord(ofRecordTypeId, testOpportunity.Id);
        
        
        Id standardId = Test.getStandardPricebookId();
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        LegalEntity__c legalEntityWithEligibleFields = TestUtility.createLegalEntityWithEligibleFields('testLegalEntity1','USD',TRUE);
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        
        Id contractRecId = ContractRecordTypeSelectionController.createDefaultRecord(ofRecordTypeId, testOpportunity.Id);

        
        Contract testContract = [Select id, status, Fastrack__c, AutoRenewal__c from contract where Id=: contractRecId];
        testContract.Status = 'Complete';
        testContract.ContractStatus__c = 'Scheduled Termination';
        testcontract.Fastrack__c = true;
        testcontract.AutoRenewal__c = false;
        testcontract.PriceIncreaseClause__c = 'Standard Contract Price Increase';
        update testContract;
        system.debug('testContract--->'+testContract);
        system.assertEquals([select Count() from case where Contract__c =: testContract.id limit 1],1 );
        system.assertEquals([select Contract__c from case where Contract__c =: testContract.id limit 1].contract__c, testContract.id);
        
        Test.stopTest();    
    }
	
	 //-----------------------------
    // @author: Veriba
    // @company: VERTIBA
    // @date: 24 July 2018
    // @param: 
    // @description:  Test method to check if functionality is working.
    // @return: NA
    // @Modification : Updated code for new methods added for edit fucntionality.
    // @Modification date : Anjani Shukla:29 June2018 - SFDC1-5864 - Cumulative Contract Value
    //-----------------------------
    
    static testMethod void testupdateDefaultContractCumulative() {
        test.startTest();
        Id ofRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        
        Id RenewalRecordTypeId = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Account ihsMarkitAccount = TestUtility.createTestAccountWithAddress('IHS Markit', 
                                                                  '4th floor Ropemaker Place, 25 Ropemaker Street',
                                                                  'London', '', 'GB', true);
        String testEmail = 'dgtest@ihsmarkit.com';
        Contact myTestContact = TestUtility.createContact(ihsMarkitAccount.Id, testEmail, true, 'Test', 'Contact');

        Opportunity testOpportunity = [SELECT Id FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
        
        
        
        Id standardId = Test.getStandardPricebookId();
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        LegalEntity__c legalEntityWithEligibleFields = TestUtility.createLegalEntityWithEligibleFields('testLegalEntity1','USD',TRUE);
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        
        Contract testContract = TestUtility.createContractWithInsertOptional(ihsMarkitAccount.id, legalEntity.id,
                                                                        country.id,standardId,false);

        
        testContract.Status = 'Creation';
        testContract.ContractStatus__c = 'Open';
        testcontract.Fastrack__c = true;
        testcontract.AutoRenewal__c = false;
        testcontract.PriceIncreaseClause__c = 'Standard Contract Price Increase';
        insert testContract;
        system.debug('testContract--->'+testContract);
        
        system.assertEquals([select AllAssociatedTotalOpportunityValue__c from Contract where id =: testContract.id limit 1].AllAssociatedTotalOpportunityValue__c, 0);
        
        Test.stopTest();    
    }
}