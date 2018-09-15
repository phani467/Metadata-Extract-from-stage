//-----------------------------
// @author: Anjani Shukla
// @company: VERTIBA
// @date: 08 Feb 2018
// @param: 
// @description:  This test class is used in SFDC1-6657 & 6636
//                used for CampaignInfluenceTrigger code coverage and validates 
//                Campaign & Opportunity 90 days from closed date to display error message.
// @return: NA
//----------------------------- 
@isTest
private class TestCampaignInfluenceTrigger {
    //-----------------------------
    // @author: Anjani Shukla
    // @company: VERTIBA
    // @date: 08 Feb 2018
    // @param: 
    // @description: This test class is used in SFDC1-6657 & 6636
    //               used for CampaignInfluenceTrigger code coverage and validates 
    //               Campaign & Opportunity 90 days from closed date to display error message.
    // @return: NA
    //----------------------------- 
    private static testMethod void testCampaignInfluenceMethods() {
        test.startTest();
         //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
                
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        User u = TestUtility.createTestUser('IHSMarkit Sales: General', 'testUSer.testuser123@ihsmarkit.com.user',true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', true);
        
        OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, true);
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = testContact.Id;
        ocr.OpportunityId = testOpportunity.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        insert ocr;
         
        testOpportunity.StageName = '6W-Closed Won';
        testOpportunity.ContractId = contract1.id;
        testOpportunity.ContractStartDate__c = System.today();
        testOpportunity.ContractEndDate__c = System.today();
        testOpportunity.ActivityCreated__c = true;
        testOpportunity.ReadyForProcessingContractExist__c = true;
        testOpportunity.RecordTypeId = devRecordTypeId;
        testOpportunity.CloseDate = System.today()+90;
        update testOpportunity;         
        
        Id campaignRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Marketing Campaign').getRecordTypeId();
        Campaign Camp= new Campaign(Name='Test',recordTypeId=campaignRecordTypeId);
        insert Camp; 
        
        CampaignInfluenceModel testCampaignInfluenceModel = [SELECT DeveloperName FROM CampaignInfluenceModel limit 1];
        //insert testCampaignInfluenceModel;
        List<CampaignInfluence> campaignInfluLst = new List<CampaignInfluence>();
        CampaignInfluence testCampaignInfluence = new CampaignInfluence(ModelId = testCampaignInfluenceModel.id,CampaignId = Camp.id, OpportunityId = testOpportunity.id, ContactId = testContact.id); 
        campaignInfluLst.add(testCampaignInfluence);
        insert campaignInfluLst;
        system.assertEquals(1,campaignInfluLst.size());
        test.stopTest();
    }
    
    //-----------------------------
    // @author: Anjani Shukla
    // @company: VERTIBA
    // @date: 08 Feb 2018
    // @param: 
    // @description: This test class is used in SFDC1-6657 & 6636
    //               used for CampaignInfluenceTrigger duplicate 
    //               Campaign.
    // @return: NA
    //----------------------------- 
    private static testMethod void testCampaignInfluenceMethodsDupeCampInf() {
        test.startTest();
         //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
                
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        User u = TestUtility.createTestUser('IHSMarkit Sales: General', 'testUSer.testuser123@ihsmarkit.com.user',true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', true);
        
        OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, true);
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = testContact.Id;
        ocr.OpportunityId = testOpportunity.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        insert ocr;
         
        testOpportunity.StageName = '6W-Closed Won';
        testOpportunity.ContractId = contract1.id;
        testOpportunity.ContractStartDate__c = System.today();
        testOpportunity.ContractEndDate__c = System.today();
        testOpportunity.ActivityCreated__c = true;
        testOpportunity.ReadyForProcessingContractExist__c = true;
        testOpportunity.RecordTypeId = devRecordTypeId;
        testOpportunity.CloseDate = System.today()+90;
        update testOpportunity;         
        
        Id campaignRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Marketing Campaign').getRecordTypeId();
        Campaign Camp= new Campaign(Name='Test',recordTypeId=campaignRecordTypeId);
        insert Camp; 
        
        CampaignInfluenceModel testCampaignInfluenceModel = [SELECT DeveloperName FROM CampaignInfluenceModel limit 1];
        //insert testCampaignInfluenceModel;
        List<CampaignInfluence> campaignInfluLst = new List<CampaignInfluence>();
        CampaignInfluence testCampaignInfluenceDupeContact = new CampaignInfluence(ModelId = testCampaignInfluenceModel.id,CampaignId = Camp.id, OpportunityId = testOpportunity.id, ContactId = testContact.id); 
        campaignInfluLst.add(testCampaignInfluenceDupeContact);
        try {
        	insert campaignInfluLst;
        }catch(DMLException e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains('This Campaign Influence Record already exists on this Opportunity.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, false);    
        }
        campaignInfluLst.clear();
        test.stopTest();
    }
    
     //-----------------------------
    // @author: Anjani Shukla
    // @company: VERTIBA
    // @date: 08 Feb 2018
    // @param: 
    // @description: This test class is used in SFDC1-6657 & 6636
    //               used to check Opportunity 90 days from closed date to display error message.
    // @return: NA
    //----------------------------- 
    private static testMethod void testCampaignInfluenceMethodsOppty90Days() {
        
         //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
                
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        User u = TestUtility.createTestUser('IHSMarkit Sales: General', 'testUSer.testuser123@ihsmarkit.com.user',true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', true);
        
        OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, true);
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = testContact.Id;
        ocr.OpportunityId = testOpportunity.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        insert ocr;
        test.startTest(); 
        testOpportunity.StageName = '6W-Closed Won';
        testOpportunity.ContractId = contract1.id;
        testOpportunity.ContractStartDate__c = System.today();
        testOpportunity.ContractEndDate__c = System.today();
        testOpportunity.ActivityCreated__c = true;
        testOpportunity.ReadyForProcessingContractExist__c = true;
        testOpportunity.RecordTypeId = devRecordTypeId;
        testOpportunity.CloseDate = System.today()+91;
        update testOpportunity;         
        
        Id campaignRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Marketing Campaign').getRecordTypeId();
        Campaign Camp= new Campaign(Name='Test',recordTypeId=campaignRecordTypeId);
        insert Camp; 
        
        CampaignInfluenceModel testCampaignInfluenceModel = [SELECT DeveloperName FROM CampaignInfluenceModel limit 1];
        //insert testCampaignInfluenceModel;
        List<CampaignInfluence> campaignInfluLst = new List<CampaignInfluence>();
        
        CampaignInfluence testCampaignInfluence = new CampaignInfluence(ModelId = testCampaignInfluenceModel.id,CampaignId = Camp.id, OpportunityId = testOpportunity.id, ContactId = testContact.id); 
        campaignInfluLst.add(testCampaignInfluence);
        insert campaignInfluLst;
        system.assertEquals(1,campaignInfluLst.size());
        
        CampaignInfluence testCampaignInfluenceDupeContact = new CampaignInfluence(ModelId = testCampaignInfluenceModel.id,CampaignId = Camp.id, OpportunityId = testOpportunity.id, ContactId = testContact.id); 
        campaignInfluLst.add(testCampaignInfluenceDupeContact);
        try {
        	insert campaignInfluLst;
        }catch(DMLException e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains('This Campaign Influence Record already exists on this Opportunity.') ? true : false;
            System.AssertEquals(expectedExceptionThrown, false);    
        }
        campaignInfluLst.clear();
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        a.DataGovernanceStatus__c = 'Approved';
        insert a;
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'testSetCaseAdditionalFieldsObject';
        c.AccountId = a.Id;
        c.Phone = '12345';
        c.EmailUnknown__c = true;
		insert c;
        
        CampaignInfluence testCampaignInfluenceOpptyOver90Days = new CampaignInfluence(ModelId = testCampaignInfluenceModel.id,CampaignId = Camp.id, OpportunityId = testOpportunity.id, ContactId = c.id); 
        campaignInfluLst.add(testCampaignInfluenceOpptyOver90Days);
        try {
        	insert campaignInfluLst;
        }catch(DMLException e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains('Please verify - Opportunity Close Date is over 90 days. You cannot add New Campaign Influence Record') ? true : false;
            System.AssertEquals(expectedExceptionThrown, false);    
        }
        
        campaignInfluLst.clear();
        test.stopTest();
    }
    
    //-----------------------------
    // @author: Anjani Shukla
    // @company: VERTIBA
    // @date: 08 Feb 2018
    // @param: 
    // @description: This test class is used in SFDC1-8326
    //               when Campaign Influence record is created,then
    //               equal percentage attribution.
    // @return: NA
    //----------------------------- 
    private static testMethod void testCampaignInfluenceCreationwithEqualPercent() {
    	 //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
                
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        User u = TestUtility.createTestUser('IHSMarkit Sales: General', 'testUSer.testuser123@ihsmarkit.com.user',true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', true);
        
        OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, true);
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = testContact.Id;
        ocr.OpportunityId = testOpportunity.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        insert ocr;
        test.startTest(); 
        
        
        List<Campaign> insertCampaign = New List<Campaign>();
        
        Id campaignRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Marketing Campaign').getRecordTypeId();
        Campaign Camp1 = new Campaign(Name='Test 1',recordTypeId=campaignRecordTypeId);
        insertCampaign.add(Camp1); 
        
        Campaign Camp2 = new Campaign(Name='Test 2',recordTypeId=campaignRecordTypeId);
        insertCampaign.add(Camp2); 
        
        insert insertCampaign;
        
        CampaignInfluenceModel testCampaignInfluenceModel = [SELECT DeveloperName FROM CampaignInfluenceModel limit 1];
        List<CampaignInfluence> campaignInfluLst = new List<CampaignInfluence>();
        
        CampaignInfluence testCampaignInfluence = new CampaignInfluence(ModelId = testCampaignInfluenceModel.id,CampaignId = insertCampaign[0].id, OpportunityId = testOpportunity.id, ContactId = testContact.id); 
        campaignInfluLst.add(testCampaignInfluence);
        
        CampaignInfluence testCampaignInfluenceDupeContact = new CampaignInfluence(ModelId = testCampaignInfluenceModel.id,CampaignId = insertCampaign[1].id, OpportunityId = testOpportunity.id, ContactId = testContact.id); 
        campaignInfluLst.add(testCampaignInfluenceDupeContact);
        insert campaignInfluLst;
        
        system.assertEquals(2,campaignInfluLst.size());
		Set<Id> campaignInflIds = new Set<Id>();        
        campaignInflIds.add(campaignInfluLst[0].id);
        campaignInflIds.add(campaignInfluLst[1].id);
        List<CampaignInfluence> getCampInflDetails = [select influence from CampaignInfluence 
                                                      where ID IN: campaignInflIds] ;
        
        
        system.assertEquals(50, getCampInflDetails[0].influence);
        system.assertEquals(50, getCampInflDetails[1].influence);
        test.stopTest();
    } 
    
     //-----------------------------
    // @author: Anjani Shukla
    // @company: VERTIBA
    // @date: 08 Feb 2018
    // @param: 
    // @description: This test class is used in SFDC1-8326
    //               when Campaign Influence record is deleted from an opportunity
    //               then, percentage should be recalculated based on number of Camp Influence record count.
    // @return: NA
    //----------------------------- 
    private static testMethod void testCampaignInfluenceCreationonDelete() {
    	 //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
                
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        User u = TestUtility.createTestUser('IHSMarkit Sales: General', 'testUSer.testuser123@ihsmarkit.com.user',true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', true);
        
        OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, true);
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = testContact.Id;
        ocr.OpportunityId = testOpportunity.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        insert ocr;
        test.startTest(); 
        
        
        List<Campaign> insertCampaign = New List<Campaign>();
        
        Id campaignRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Marketing Campaign').getRecordTypeId();
        Campaign Camp1 = new Campaign(Name='Test 1',recordTypeId=campaignRecordTypeId);
        insertCampaign.add(Camp1); 
        
        Campaign Camp2 = new Campaign(Name='Test 2',recordTypeId=campaignRecordTypeId);
        insertCampaign.add(Camp2); 
        
        insert insertCampaign;
        
        CampaignInfluenceModel testCampaignInfluenceModel = [SELECT DeveloperName FROM CampaignInfluenceModel limit 1];
        List<CampaignInfluence> campaignInfluLst = new List<CampaignInfluence>();
        
        CampaignInfluence testCampaignInfluence = new CampaignInfluence(ModelId = testCampaignInfluenceModel.id,CampaignId = insertCampaign[0].id, OpportunityId = testOpportunity.id, ContactId = testContact.id); 
        campaignInfluLst.add(testCampaignInfluence);
        
        CampaignInfluence testCampaignInfluenceDupeContact = new CampaignInfluence(ModelId = testCampaignInfluenceModel.id,CampaignId = insertCampaign[1].id, OpportunityId = testOpportunity.id, ContactId = testContact.id); 
        campaignInfluLst.add(testCampaignInfluenceDupeContact);
        insert campaignInfluLst;
        
        system.assertEquals(2,campaignInfluLst.size());
        
        Set<Id> campaignInflIds = new Set<Id>();        
        campaignInflIds.add(campaignInfluLst[0].id);
        campaignInflIds.add(campaignInfluLst[1].id);
        
        List<CampaignInfluence> getCampInflDetails1 = [select influence from CampaignInfluence 
                                                      where ID IN: campaignInflIds] ;
        
        
        system.assertEquals(50, getCampInflDetails1[0].influence);
        system.assertEquals(50, getCampInflDetails1[1].influence);
        
        
        // Now delete
        delete campaignInfluLst[1];
        
        List<CampaignInfluence> getCampInflDetails2 = [select influence from CampaignInfluence 
                                                      where ID =: campaignInfluLst[0].id] ;
        
        
        system.assertEquals(100, getCampInflDetails2[0].influence);
        test.stopTest();
        
        
        
    }    
}