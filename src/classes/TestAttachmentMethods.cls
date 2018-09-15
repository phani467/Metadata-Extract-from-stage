// @author: Uttam Arya
// @date: 31 Aug 2017
// @param: NA
// @description: Test class for Attachment trigger methods 
// @return: NA
//-----------------------------

@isTest
private class TestAttachmentMethods {
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 31 Aug 2017
    // @param: NA
    // @description: SFDC1-2243 Test method for Attachment trigger methods populateAttachmentAddedInOpportunityWhenAttachmentIsInserted on insert
    // @return: NA
    // @Modifiedby: Mohit Modi
    // @Modified Description: 06 Nov 2017 : Updated Test Method logic to capture the attahment added on Opportunity Attachment as well.
    //-----------------------------
    private static testMethod void testpopulateAttachmentAddedInOpportunityWhenAttachmentIsInserted() {
        
        Account acct = TestUtility.createTestAccount('Test Attachmnet Insertion', true);
        Opportunity oppt = TestUtility.createOpportunity(acct.Id, 'Test Oppy Attachment', true);
        
        OpportunityAttachment__c oppAtt = new OpportunityAttachment__c(AttachmentType__c = 'Final Proposal',Opportunity__c =oppt.id );
        insert oppAtt ;
        
        Blob attachBody = Blob.valueOf('attachment body');
        Attachment attach = new Attachment(Name = 'TestAttachment', ParentId = oppt.Id, Body = attachBody);
        Attachment attach1 = new Attachment(Name = 'TestAttachment1', ParentId = oppAtt.Id, Body = attachBody);
        insert new list<Attachment>{attach,attach1};
        
        //Assert if MIS field is inserted
        Opportunity opp = [select MISAttachmentAdded__c from Opportunity where Id =: oppt.Id];
        
        System.assertNotEquals(opp.MISAttachmentAdded__c, null);
        
    }
}