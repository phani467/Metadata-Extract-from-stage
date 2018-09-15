//-----------------------------
// @author: Prachi Bhasin
// @date: 24 Jan 2018
// @param: NA
// @description: Test Class for CloneOpportunityWithProducts 
// @return: NA
// @company: VERTIBA
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 6 March 2018
// @Last Modified Description: SFDC1-7234, If 'Auto Renewal' field is "yes" and the "Does this Auto Renew have changes" field is set to No â€” do not allow the user to change the currency on that opportunity.
// @Update Author : Mohit Modi
// @date : 14 March 2018
// @Description : SFDC1-7158 : Added the where clause in Opportunity Product only for New and Existing Status
//----------------------------
@isTest(SeeAllData = false)
private class TestCloneOpportunityWithProducts{
    static testMethod void testCloneOppWithProducts() {
        List<CloneOpportunityMapping__c> lstOppMapping = new List<CloneOpportunityMapping__c>();
        List<String> lstMappingNames = new List<String>{'StageName','BudgetRange__c','ACCOUNTID','Pricebook2Id','RECORDTYPEID','Amount','closedate','Name','CURRENCYISOCODE','CONTRACTENDDATE__C','CONTRACTSTARTDATE__C'};
        
        for(String str:lstMappingNames ) {
            lstOppMapping.add(new CloneOpportunityMapping__c(name=str));
        }
        insert lstOppMapping;
        
        List<CloneOpportunityProductMapping__c> lstOppProductMapping = new List<CloneOpportunityProductMapping__c>();
        List<String> lstMappingNamesProduct = new List<String>{'TotalPrice','DiscountType__c','UnitListPrice__c','Quantity'};
        
        for(String str:lstMappingNamesProduct) {
            lstOppProductMapping.add(new CloneOpportunityProductMapping__c(name=str));
        }
        insert lstOppProductMapping ;
        
        List<CloneOpportunityProductScheduleMapping__c> lstOppProductScheduleMapping = new List<CloneOpportunityProductScheduleMapping__c>();
        List<String> lstMappingNamesProductSchedule = new List<String>{'DiscountAmount__c','DiscountType__c','ExternalListPrice__c','Quantity__c'};
        
        for(String str:lstMappingNamesProductSchedule) {
            lstOppProductScheduleMapping.add(new CloneOpportunityProductScheduleMapping__c(name=str));
        }
        insert lstOppProductScheduleMapping ;
        
        Test.startTest();
            Product2 testProd = TestUtility.createProduct('Test Product', true);
            Id standardId = Test.getStandardPricebookId();
            PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
            
            Account testAccount = TestUtility.createTestAccount('testAccount', false);
            testAccount.DataGovernanceStatus__c = 'Approved';
            insert testAccount;

            Account assertAccount = [Select Id,Relationship__c from Account where Id =:testAccount.Id];
            System.assertEquals('Prospect', assertAccount.Relationship__c,'Checking relationship on account creation');
            
            Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', true);
            OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, false);
            testOLI.Status__c = 'New';
            insert testOLI;
           
            System.debug('testOpportunity.Id-----'+testOpportunity.Id);
            String oppCloned = CloneOpportunityWithProducts.cloneOpportunityRecord(testOpportunity.Id);
            System.assertNotEquals(oppCloned,NULL,'Opportunity not created');
            
            String clonedOppName = [Select id, name from opportunity where id=:oppCloned limit 1].name;
            System.assertEquals(clonedOppName,testOpportunity.name+' - Clone','Opportunity not cloned properly');
            
            OpportunityLineItem oppLineItemCloned = [Select id,TotalPrice from OpportunityLineItem where opportunityId =: testOpportunity.Id ];
            System.assertNotEquals(oppLineItemCloned ,NULL,'Opportunity product not cloned');
            
            System.assertEquals(oppLineItemCloned.TotalPrice,testOLI.TotalPrice,'Opportunity product not cloned');
        Test.stopTest();
    }
    
    static testMethod void testChangeOppCurrency() {
        List<CloneOpportunityMapping__c> lstOppMapping = new List<CloneOpportunityMapping__c>();
        List<String> lstMappingNames = new List<String>{'StageName','BudgetRange__c','ACCOUNTID','Pricebook2Id','RECORDTYPEID','Amount','closedate','Name','CURRENCYISOCODE','CONTRACTENDDATE__C','CONTRACTSTARTDATE__C'};
        
        for(String str:lstMappingNames ) {
            lstOppMapping.add(new CloneOpportunityMapping__c(name=str));
        }
        insert lstOppMapping;
        
        List<CloneOpportunityProductMapping__c> lstOppProductMapping = new List<CloneOpportunityProductMapping__c>();
        List<String> lstMappingNamesProduct = new List<String>{'TotalPrice','DiscountType__c','UnitListPrice__c','Quantity'};
        
        for(String str:lstMappingNamesProduct) {
            lstOppProductMapping.add(new CloneOpportunityProductMapping__c(name=str));
        }
        insert lstOppProductMapping ;
        
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        
        PricebookEntry testPBEUSD = TestUtility.createPriceBookEntry(standardId, testProd.Id, false);
        testPBEUSD.currencyIsoCode = 'USD';
        insert testPBEUSD;
        
        PricebookEntry testPBERUB = TestUtility.createPriceBookEntry(standardId, testProd.Id, false);
        testPBERUB.currencyIsoCode = 'RUB';
        insert testPBERUB;
       
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        
        Account assertAccount = [Select Id,Relationship__c from Account where Id =:testAccount.Id];
        System.assertEquals('Prospect', assertAccount.Relationship__c,'Checking relationship on account creation');
        
        Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', false);
        testOpportunity.CurrencyIsoCode = 'USD';
        insert testOpportunity;
        System.assertNotEquals(testOpportunity.id, NULL ,'Checking if opportunity is inserted');
            
          
            
            OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBEUSD, false);
            testOLI.Status__c = 'New';
            insert testOLI;
          
            System.debug('testOpportunity.Id-----'+testOpportunity.Id);
            String activeCurrencies = CloneOpportunityWithProducts.getActiveCurrencies();
            Test.startTest();
            String currencyChange = CloneOpportunityWithProducts.changeOpportunityCurrency('RUB',testOpportunity.id);
            
            Opportunity opp = [Select id, CurrencyIsoCode from opportunity where id =: testOpportunity.id];
            System.assertEquals('RUB', opp.CurrencyIsoCode ,'Checking if currency is updated');
        Test.stopTest();
    }
    
    static testMethod void testCheckUserAccess() {
        List<CloneOpportunityMapping__c> lstOppMapping = new List<CloneOpportunityMapping__c>();
        List<String> lstMappingNames = new List<String>{'StageName','BudgetRange__c','ACCOUNTID','Pricebook2Id','RECORDTYPEID','Amount','closedate','Name','CURRENCYISOCODE','CONTRACTENDDATE__C','CONTRACTSTARTDATE__C'};
        for(String str:lstMappingNames ) {
            lstOppMapping.add(new CloneOpportunityMapping__c(name=str));
        }
        insert lstOppMapping;
        
        List<CloneOpportunityProductMapping__c> lstOppProductMapping = new List<CloneOpportunityProductMapping__c>();
        List<String> lstMappingNamesProduct = new List<String>{'TotalPrice','DiscountType__c','UnitListPrice__c','Quantity'};
        
        for(String str:lstMappingNamesProduct) {
            lstOppProductMapping.add(new CloneOpportunityProductMapping__c(name=str));
        }
        insert lstOppProductMapping ;
        
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        
        PricebookEntry testPBEUSD = TestUtility.createPriceBookEntry(standardId, testProd.Id, false);
        testPBEUSD.currencyIsoCode = 'USD';
        insert testPBEUSD;
        
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract = TestUtility.createContractWithInsertOptional(testAccount.Id, legalEntity.Id, country.Id, standardId,FALSE);
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        contract.recordtypeid = orderFormRecordTypeId;
        insert contract;
        
        Test.startTest();
        
            Account assertAccount = [Select Id,Relationship__c from Account where Id =:testAccount.Id];
            System.assertEquals('Prospect', assertAccount.Relationship__c,'Checking relationship on account creation');
            
            Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', false);
            testOpportunity.CurrencyIsoCode = 'USD';
            testOpportunity.AutoRenewal__c = TRUE;
            testOpportunity.StageName = '3-Renewal Pending';
            testOpportunity.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        	testOpportunity.ContractBeingRenewed__c = contract.Id;
            insert testOpportunity;
            System.assertNotEquals(testOpportunity.id, NULL ,'Checking if opportunity is inserted');
            
            OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBEUSD, false);
            testOLI.Status__c = 'New';
            insert testOLI;
         
            System.debug('testOpportunity.Id-----'+testOpportunity.Id);
            String errorMessage = CloneOpportunityWithProducts.getOpptyAccess(testOpportunity.Id);
            System.assertEquals('autoRenewWithoutChange', errorMessage ,'Checking oppty is autorenewal without changes');

        Test.stopTest();
    }
}