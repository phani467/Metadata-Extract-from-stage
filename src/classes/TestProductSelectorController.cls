/**
* @Author : Mohit Modi
* @Date : 14 Nov 2017
* @Description : Test Class for accessCheckController
* @company : Vertiba
*/
    @isTest
    private class TestProductSelectorController {

    private static testMethod void testcheckRecordAccessforUser () {
            
            Account acc = TestUtility.createTestAccount('Account testAccountforOpp', true);
        	Product2 testProd = TestUtility.createProduct('Test Product', true);
            Id standardId = Test.getStandardPricebookId();
            LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
            List<Country__c> lstCountry = TestUtility.loadCountryData();
            Country__c country = lstCountry.get(0);
            Contract contract = TestUtility.createContractWithInsertOptional(acc.Id, legalEntity.Id, country.Id, standardId,FALSE);
            Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
            contract.recordtypeid = orderFormRecordTypeId;
            insert contract;
    		List<Opportunity> oppyList = new List<Opportunity>();
            Opportunity testOpportunity1 = TestUtility.createOpportunity(acc.Id,'first test Oppy', false);
            testOpportunity1.Amount = 1000;
        	oppyList.add(testOpportunity1);
        	User u = TestUtility.createTestUser('IHSMarkit Sales: General','standardrollupuser@testorg.com',true);
        	Id RecordTypeIdOppty = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Inner Year').getRecordTypeId();
        	Opportunity testOpportunity2 = TestUtility.createOpportunity(acc.Id,'Rollup test Oppy', false);
            testOpportunity2.recordtypeid = RecordTypeIdOppty;
        	testOpportunity2.ContractBeingRenewed__c = contract.Id;
        	testOpportunity2.AutoRenewal__c = true;
        	oppyList.add(testOpportunity2);
        	insert oppyList;
        	
            test.startTest();
                ProductSelectorController.ProductSelectorValidatorWrapper assertAccess = ProductSelectorController.checkRecordAccessforUser (userinfo.getuserID(),testOpportunity1.id,'Add Products');
                System.assertEquals(true, assertAccess.isSuccess );
                System.runAs(u) {
                   ProductSelectorController.ProductSelectorValidatorWrapper assertAccess2 = ProductSelectorController.checkRecordAccessforUser (u.Id,testOpportunity2.id,'Add Products');
                   System.assertEquals(false, assertAccess2.isSuccess );
                }
            test.stopTest();
        }
    }