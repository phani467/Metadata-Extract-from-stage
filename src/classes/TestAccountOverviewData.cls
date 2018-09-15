//-----------------------------
// @author: Jagadesh Kumar
// @date: 30 July 2018
// @param: NA
// @description: Test Class for AccountOverviewData
// @return: NA
//----------------------------
@isTest
public class TestAccountOverviewData {

    @isTest
    static void testAccountOverviewDataExclduleHierarchy() {
        Test.startTest();
        Account parentAccount = TestUtility.createTestAccount('BARCLAYS Parent',true);
        Account globalAcc = TestUtility.createTestAccount('Global Ultimate Account',true);
        Account a = TestUtility.createTestAccount('BARCLAYS PLC',false);
        a.ParentId = parentAccount.Id;
        a.GlobalUltimateAccount__c = globalAcc.Id;
        insert a;
        
        Opportunity opp = TestUtility.createOpportunity(a.id, 'BARCLAYS Opp',null,false);
        opp.RecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        opp.Probability = 0.50;
        opp.Amount = 100000;
        insert opp;
        
        Product2 testProd1 = TestUtility.createProduct('Test Product1', true);
        
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd1.Id, true);
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContractWithInsertOptional(a.Id, legalEntity.Id, country.Id, standardId,false);
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        contract1.recordtypeid = orderFormRecordTypeId;
        contract1.ContractApproved__c = true;
        insert contract1;
        
        RenewalatRisk__c opptyAtRisk = new RenewalatRisk__c();
        opptyAtRisk.OpportunityAtRisk__c = opp.Id;
        opptyAtRisk.Account__c = a.Id;
        opptyAtRisk.Comments__c = 'lost';
        opptyAtRisk.EstimatedValueatRisk__c = 500;
        opptyAtRisk.RiskProbability__c = 50;
        insert opptyAtRisk;
        
        AccountOverview__c ov = new AccountOverview__c();
        ov.Account1__c = a.Id;
        insert ov;
        
        Loop.ExternalData.QueryRequestInfo requestInfo = new Loop.ExternalData.QueryRequestInfo();
        requestInfo.RecordId = ov.Id;
        AccountOverviewData aod = new AccountOverviewData();
        aod.describeObjects(new List<String>(aod.getGlobalDescribe()));
        aod.getChildRelationships('AccountOverviewParameters');
        
        List<Loop.ExternalData.Relationship> Relationships = new List<Loop.ExternalData.Relationship>();
        for(String s: aod.getGlobalDescribe()){
            Loop.ExternalData.Relationship relationship = new Loop.ExternalData.Relationship();
            relationship.Name = s;
            Relationships.add(relationship);
        }
        requestInfo.Relationships = Relationships;
        
        Loop.ExternalData.QueryResultSet queryRS = aod.query(requestInfo);
        System.assert(queryRS!=null);
        
        Test.stopTest();
    }
    
    @isTest
    static void testAccountOverviewDataIncludeHierarchy() {
        Test.startTest();
        Account parentAccount = TestUtility.createTestAccount('BARCLAYS Parent',true);
        Account globalAcc = TestUtility.createTestAccount('Global Ultimate Account',true);
        Account a = TestUtility.createTestAccount('BARCLAYS PLC',false);
        a.ParentId = parentAccount.Id;
        a.GlobalUltimateAccount__c = globalAcc.Id;
        insert a;
        
        Opportunity opp = TestUtility.createOpportunity(a.id, 'BARCLAYS Opp',null,false);
        opp.RecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        opp.Probability = 0.50;
        opp.Amount = 100000;
        insert opp;
        
        Product2 testProd1 = TestUtility.createProduct('Test Product1', true);
        
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd1.Id, true);
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContractWithInsertOptional(a.Id, legalEntity.Id, country.Id, standardId,false);
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        contract1.recordtypeid = orderFormRecordTypeId;
        contract1.ContractApproved__c = true;
        insert contract1;
        
        RenewalatRisk__c opptyAtRisk = new RenewalatRisk__c();
        opptyAtRisk.OpportunityAtRisk__c = opp.Id;
        opptyAtRisk.Account__c = a.Id;
        opptyAtRisk.Comments__c = 'lost';
        opptyAtRisk.EstimatedValueatRisk__c = 500;
        opptyAtRisk.RiskProbability__c = 50;
        insert opptyAtRisk;
        
        AccountOverview__c ov = new AccountOverview__c();
        ov.Account1__c = a.Id;
        ov.ExcludeSubsidiaries__c = true;
        insert ov;
        
        Loop.ExternalData.QueryRequestInfo requestInfo = new Loop.ExternalData.QueryRequestInfo();
        requestInfo.RecordId = ov.Id;
        AccountOverviewData aod = new AccountOverviewData();
        aod.describeObjects(new List<String>(aod.getGlobalDescribe()));
        aod.getChildRelationships('AccountOverviewParameters');
        Loop.ExternalData.QueryResultSet queryRS = aod.query(requestInfo);
        System.assert(queryRS!=null);
        
        Test.stopTest();
    }
}