/**
* @author: Uttam Arya
* @date: 26th Oct 2017 
* @description: SFDC1-5493 Test Controller class for Opportunity Attachment Aura Component
* @company: IHS Markit
*/
@isTest
public class TestCreateOpportunityAttachment {
    @isTest
    static void testConntroller() {
        Test.startTest();
        Id newBusinessRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Account acc = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        acc.DataGovernanceStatus__c = 'Approved';
        insert acc;
        Opportunity testOpportunity = TestUtility.createOpportunity(acc.Id, 'test Opppy', true);
        testOpportunity.RecordTypeId = newBusinessRecordTypeId;
        
        update testOpportunity;
        
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);        
        OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, true);
        update testOpportunity;
        
        System.assertEquals((String) Schema.SObjectType.OpportunityAttachment__c.getRecordTypeInfosByName().get('New Business').getRecordTypeId(), CreateOpportunityAttachmentController.getRecordTypeId(testOpportunity.Id));

        Test.stopTest();
    }
    
}