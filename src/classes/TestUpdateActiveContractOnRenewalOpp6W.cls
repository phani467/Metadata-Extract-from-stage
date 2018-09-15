/**
// @author: Hemant Shukla
// @date: 20-Oct-2017
// @description: SFDC1-5421, This is Test class for UpdateActiveContractOnRenewalOpp6W
// @companyname : VERTIBA 
// @Last Modified By : Hemant Shukla
// @Last Modified Description : Removed the dependency of ContractExists__c field based on SFDC1-5701
// @Last Modified Date : 6-Nov-2017 
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 14 Dec 2017 Sprint 15
// @Last Modified Description: SFDC1-5851, Included Fastrack checkbox value for order form contracts**/
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 20 Dec 2017 Sprint 15
// @Last Modified Description: SFDC1-6411, Test class fix for OpportunityMethods class update**/
@isTest
public class TestUpdateActiveContractOnRenewalOpp6W {
    
    
    //-----------------------------
    //@author: Hemant Shukla
    //@date: 20-Oct-2017
    //@param: None
    //@description: SFDC1-5421, This is Test method for UpdateActiveContractOnRenewalOpp6W
    //@return: void
    //@companyname : VERTIBA 
    //@lastmodified description: Primary Contact roles needs to be created before updating opprtunity to stage 3 and above as per  SFDC1-5782 AND SFDC1-5029
    //@modifiedBy: Ankita Singh on 5th December,2017
    //-----------------------------
    static testMethod void testUpdateOriginatingContract() {
        
       //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        
        Id renewalRecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        
        Contract contract1 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        Contract contract2 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        Contract contract3 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        Contract contract4 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        
        List<Contract> contracts = new List<Contract>();
        contracts.add(new Contract(Id = contract1.Id, RecordTypeId = orderFormRecordTypeId, Fastrack__c = TRUE));
        contracts.add(new Contract(Id = contract3.Id, RecordTypeId = orderFormRecordTypeId, Fastrack__c = TRUE));
        
        //Updating contarct recordType to Order Form
        update contracts;
        
        //create renewal opportunities and attach ContractBeingRenewed
        Opportunity testOpportunity1 = TestUtility.createOpportunity(testAccount.Id, 'test Opppy1', false);
        testOpportunity1.ContractBeingRenewed__c = contract1.id;
        testOpportunity1.RecordTypeId = renewalRecordTypeId;
        testOpportunity1.StageName= '3-Renewal Pending';
        insert testOpportunity1;
        OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(testOpportunity1.Id, testPBE, true);
        
        Opportunity testOpportunity2 = TestUtility.createOpportunity(testAccount.Id, 'test Opppy2', false);
        testOpportunity2.ContractBeingRenewed__c = contract3.id;
        testOpportunity2.RecordTypeId = renewalRecordTypeId;
        testOpportunity2.StageName= '3-Renewal Pending';
        Test.startTest();
        insert testOpportunity2;
        OpportunityLineItem testOLI2 = TestUtility.createOpportunityLineItem(testOpportunity2.Id, testPBE, true);
        
        //Realting other order form contracts to Opportunity
        contracts.add(new Contract(id = contract2.Id, RecordTypeId = orderFormRecordTypeId, Fastrack__c = TRUE, Opportunity__c = testOpportunity1.id));
        contracts.add(new Contract(Id = contract4.Id, RecordTypeId = orderFormRecordTypeId, Fastrack__c = TRUE, Opportunity__c = testOpportunity2.id));
        
        update contracts;
        
        List<OpportunityContactRole> ocrList = new List<OpportunityContactRole>();
        OpportunityContactRole ocr1 = new OpportunityContactRole();
        ocr1.ContactId = testContact.Id;
        ocr1.OpportunityId = testOpportunity1.Id;
        ocr1.IsPrimary = TRUE;
        ocr1.Role = 'Decision Maker';
        
        OpportunityContactRole ocr2 = new OpportunityContactRole();
        ocr2.ContactId = testContact.Id;
        ocr2.OpportunityId = testOpportunity2.Id;
        ocr2.IsPrimary = TRUE;
        ocr2.Role = 'Decision Maker';
        ocrList.add(ocr1);
        ocrList.add(ocr2);
        insert ocrList;
        
        
        
        List<Opportunity> lstToUpdate = new List<Opportunity>();
        lstToUpdate.add(new Opportunity(id = testOpportunity1.id,
                                        StageName = '6W-Renewal Won',
                                        ContractId = contract1.id,
                                        ContractStartDate__c = System.today(),
                                        ContractEndDate__c = System.today(),
                                        ActivityCreated__c = true,
                                        ReadyForProcessingContractExist__c  = true
                                        )
                        );
                        
        lstToUpdate.add(new Opportunity(id = testOpportunity2.id,
                                        StageName = '6W-Renewal Won',
                                        ContractId = contract1.id,
                                        ContractStartDate__c = System.today(), 
                                        ContractEndDate__c = System.today(),
                                        ActivityCreated__c = true,
                                        ReadyForProcessingContractExist__c  = true
                                        )
                        );  
                        
        update lstToUpdate;
        
        //Do assert check if process builder fires. 
        if(GlobalConstants.hasUpdateActiveContractOnRenewalOpp6WProcessFired){
            
            System.assertEquals('Replaced', [select Id, ContractStatus__c from Contract where id = :contract1.id].ContractStatus__c, 'Status check');
            System.assertEquals(contract2.Id, [select Id, ReplacementContract__c from Contract where id = :contract1.id].ReplacementContract__c, 'replacement contract check');
            
            System.assertEquals('Replaced', [select Id, ContractStatus__c from Contract where id = :contract3.id].ContractStatus__c, 'Status check');
            System.assertEquals(contract4.Id, [select Id, ReplacementContract__c from Contract where id = :contract3.id].ReplacementContract__c, 'replacement contract check');
            
        }else{
            //manually call the method when process builder is not active.
            UpdateActiveContractOnRenewalOpp6W.updateOriginatingContract(new List<Id>{testOpportunity1.id, testOpportunity2.id});
        }    
        
        Test.StopTest();                
        
    }
    
}