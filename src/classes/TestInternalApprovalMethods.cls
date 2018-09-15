//-----------------------------
// @author: Jagadesh Kumar
// @date: 06 June 2018
// @param: NA
// @description: Test class for Internal Approval trigger methods 
// @return: NA
//-----------------------------
@isTest
public class TestInternalApprovalMethods {
	//-----------------------------
    // @author: Jagadesh Kumar
    // @date: 06 June 2018
    // @param: NA
    // @description: Test method for Internal Approval trigger methods populateContractOwner on insert
    // @return: NA
    //-----------------------------
    private static testMethod void testpopulateContractOwner() {
        Test.startTest();
        Account a = TestUtility.createTestAccount('Internal Approval Account', true);
        Contact c1 = new Contact();
        c1.firstname = 'Internal1';
        c1.lastname = 'Approval1';
        c1.Email = 'Internal.Approval@ihsmarkit.com';
        c1.AccountId = a.Id;
        insert c1;
        
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContractWithInsertOptional(a.Id, legalEntity.Id, country.Id, standardId,TRUE);
        
        InternalApproval__c inApproval = new InternalApproval__c();
        inApproval.Contact__c = c1.Id;
        inApproval.Contract__c = contract1.Id;
        inApproval.ApprovalType__c = 'Business Line Leader';
        insert inApproval;
        InternalApproval__c ia = [SELECT Id,ContractOwner__c FROM InternalApproval__c WHERE ID =: inApproval.Id];
        System.assert(ia.ContractOwner__c != null);
        Test.stopTest();
    }
    
}