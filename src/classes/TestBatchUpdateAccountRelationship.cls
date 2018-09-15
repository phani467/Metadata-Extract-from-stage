/**
* @author Paras Dhingra
* @date 2nd August 2017
* @description SFDC1-775 test class for BatchUpdateAccountRelationship and BatchUpdateAccountRelationshipScheduler
* @param TriggerParameters
* @return void
* @companyname IHS Markit
* @lastmodifiedSprint : Sprint 9
* @lastmodifiedBy : Prachi for SFDC1-1154 validation rule
* @Last Modified By : Vinod Merwade
* @Last Modified Description : Corrected the Test class according to new validation rules on Opportunity
* @Last Modified Date : 19 Sept 2017
* @Last Modified By : Hemant Shukla
* @Last Modified Description : Removed the dependency of ContractExists__c field based on SFDC1-5701
* @Last Modified Date : 6-Nov-2017
* @lastmodified description: Primary Contact roles needs to be created before updating opprtunity to stage 3 and above as per  SFDC1-5782 AND SFDC1-5029
* @modifiedBy: Ankita Singh on 5th December,2017
*/
@isTest
private class TestBatchUpdateAccountRelationship {

    private static testMethod void testBatchUpdateAccountRelationshipClass() {
        //create test Data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);   
        Account testAccount1 = TestUtility.createTestAccountWithStreet('testAccount', 'Test Street 1', true);
        Contact testContact = TestUtility.createContact(testAccount1.Id, 'testihsmarkit@testihsmarkit.com', true, 'Test', 'Contact');
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContract(testAccount1.Id, legalEntity.Id, country.Id, standardId);
        Account assertAccount1 = [Select Id,Relationship__c from Account where Id =:testAccount1.Id];
        System.assertEquals('Prospect', assertAccount1.Relationship__c,'Checking relationship on account creation');
        
        //create test data for batch
        
        
        List<Account> lstAccountToBeInserted = new List<Account>();
        Account testAccount2 = TestUtility.createTestAccountWithStreet('testAccount prospect', 'Prospect Street', false);
        testAccount2.Relationship__c = '';
        lstAccountToBeInserted.add(testAccount2);
        
        Account testAccount3 = TestUtility.createTestAccountWithStreet('testAccount customer', 'Customer Street', false);
        testAccount3.DataGovernanceStatus__c = 'Approved';
        lstAccountToBeInserted.add(testAccount3);
        
        Account testAccount4 = TestUtility.createTestAccountWithStreet('testAccount previous customer', 'Previous Customer Street', false);
        testAccount4.DataGovernanceStatus__c = 'Approved';
        lstAccountToBeInserted.add(testAccount4);
        
        insert lstAccountToBeInserted;
        List<Opportunity> lstOppty = new List<Opportunity>();
        Opportunity testOpportunity1 = TestUtility.createOpportunity(testAccount3.Id, 'test Opppy customer', false);
        Opportunity testOpportunity2 = TestUtility.createOpportunity(testAccount4.Id, 'test Opppy PC', false);
        lstOppty.add(testOpportunity1);
        lstOppty.add(testOpportunity2);
        insert lstOppty;
        
        List<OpportunityLineItem> lstOpptyLineItem = new List<OpportunityLineItem>();
        OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(testOpportunity1.Id, testPBE, false);
        OpportunityLineItem testOLI2 = TestUtility.createOpportunityLineItem(testOpportunity2.Id, testPBE, false);
        lstOpptyLineItem.add(testOLI1);
        lstOpptyLineItem.add(testOLI2);
        insert lstOpptyLineItem;
        
        List<OpportunityContactRole> lstOppyContactRole = new List<OpportunityContactRole>();
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = testContact.Id;
        ocr.OpportunityId = testOpportunity1.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        lstOppyContactRole.add(ocr);
        OpportunityContactRole ocr2 = new OpportunityContactRole();
        ocr2.ContactId = testContact.Id;
        ocr2.OpportunityId = testOpportunity2.Id;
        ocr2.IsPrimary = TRUE;
        ocr2.Role = 'Decision Maker';
        lstOppyContactRole.add(ocr2);
        insert lstOppyContactRole;
        
        List<Opportunity> lstOppToBeUpdated = new List<Opportunity>();
        
        testOpportunity1.StageName = '6W-Closed Won';
        testOpportunity1.ContractId = contract1.id;
        testOpportunity1.ContractStartDate__c = Date.today();
        testOpportunity1.ContractEndDate__c = Date.today()+365;
        testOpportunity1.ActivityCreated__c = true;
        testOpportunity1.ReadyForProcessingContractExist__c  = true;
        lstOppToBeUpdated.add(testOpportunity1);
        //update testOpportunity1;
         //start test for batch
        Test.startTest();
        testOpportunity2.CloseDate = Date.today()-400;
        
        //update testOpportunity2;
        
        
        testOpportunity2.StageName = '6W-Closed Won';
        testOpportunity2.ContractId = contract1.id;
        testOpportunity2.ContractStartDate__c = Date.today();
        testOpportunity2.ContractEndDate__c = Date.today()+365;
        testOpportunity2.ActivityCreated__c = true;
        testOpportunity2.ReadyForProcessingContractExist__c  = true;
        //update testOpportunity2;
        lstOppToBeUpdated.add(testOpportunity2);
        update lstOppToBeUpdated;
        
        List<Account> lstAccToBeUpdated =  new List<Account>();
        testAccount3.Relationship__c ='';
        lstAccToBeUpdated.add(testAccount3);
        //update testAccount3;
        
        testAccount4.Relationship__c = '';
        lstAccToBeUpdated.add(testAccount4);
        //update testAccount4;
        update lstAccToBeUpdated;
       
        BatchUpdateAccountRelationship baur = new BatchUpdateAccountRelationship();
        baur.query = 'Select Id from Account';
        Id batchId = Database.executeBatch(baur, 10);
        
        Test.stopTest();
        
        Account assertAccount2 = [Select Id,Relationship__c from Account where Id =:testAccount2.Id];
        System.assertEquals('Prospect', assertAccount2.Relationship__c,'Checking relationship on account creation');
        
        Account assertAccount3 = [Select Id,Relationship__c from Account where Id =:testAccount3.Id];
        System.assertEquals('Customer', assertAccount3.Relationship__c,'Checking relationship on account creation');
        
        Account assertAccount4 = [Select Id,Relationship__c from Account where Id =:testAccount4.Id];
        //System.assertEquals('Previous Customer', assertAccount4.Relationship__c,'Checking relationship on account creation'); //this check is no longer valid
    }
    
    static testMethod void TestBatchUpdateAccountRelationshipScheduler(){
        Test.StartTest();        
        BatchUpdateAccountRelationshipScheduler ba = new BatchUpdateAccountRelationshipScheduler(); //Schedule apex class name
        String sch = '0 0 8 13 2 ?'; //schedule interval time
        String jobId = system.schedule('Run Job for BatchUpdateAccountRelationshipScheduler', sch, ba); //system method to schedule apex class
        System.assert(jobId!=null);
        Test.stopTest();
    }

}