//-----------------------------
// @author: Ankita Singh
// @date: 19 June 2018
// @param: NA
// @description: Test class for ContractAttachment trigger methods 
// @return: NA
//-----------------------------

@isTest
private class TestContractAttachmentMethods {
    
    //-----------------------------
    // @author: Ankita Singh
    // @date: 18 June 2018
    // @param: NA
    // @description: SFDC1-8559.Test method for ContactAttachment trigger methods updateFieldOnContract on insert and delete
    // @return: NA
    //-----------------------------
    private static testMethod void testupdateFieldOnContract() {
        
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        //Creating Contract
        Id OFRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract = TestUtility.createContractWithInsertOptional(testAccount.Id, legalEntity.Id, country.Id, standardId,FALSE);
        contract.recordtypeid = OFRecordTypeId;
        contract.POAttached__c = 'No';
        contract.Fastrack__c = true;
        insert contract;
        //Creating ContractAttachment
        Test.startTest();
        ContractAttachment__c ca = new ContractAttachment__c();
        ca.Name = 'Contract Attachment PO 1';
        ca.Contract__c = contract.id;
        ca.AttachmentType__c = 'Purchase Order';
        insert ca;
        // Assert output
        String c1 = [Select POAttached__c from contract where id=:contract.id][0].POAttached__c;
        system.assertEquals('Yes', c1);
        // deleting Contract Attachment 
        delete ca;
        // Assert Output
        String c2 = [Select POAttached__c from contract where id=:contract.id][0].POAttached__c;
        system.assertEquals('No', c2);
        Test.stopTest();
    }
    
}