// @author: Uttam Arya
// @date: 31 Aug 2017
// @param: NA
// @description: Test class for ContentDocumentLink trigger methods 
// @return: NA
//-----------------------------

@isTest
private class TestContentDocumentLinkMethods {
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 31 Aug 2017
    // @param: NA
    // @description: SFDC1-2243 Test method for ContentDocumentLink trigger methods populateMISAttachmentAddedInOpportunityWhenAttachmentIsInsertedInLightning on insert
    // @return: NA
    // @Modifiedby: Mohit Modi
    // @Modified Description: 06 Nov 2017 : Updated Test Method logic to capture the attahment added on Opportunity Attachment as well.
    //-----------------------------
    private static testMethod void testpopulateMISAttachmentAddedInOpportunityWhenAttachmentIsInsertedInLightning() {
        
        Account acct = TestUtility.createTestAccount('Test Attachmnet Insertion', true);
        Opportunity oppt = TestUtility.createOpportunity(acct.Id, 'Test Oppy Attachment', true);
        
        OpportunityAttachment__c oppAtt = new OpportunityAttachment__c(AttachmentType__c = 'Final Proposal',Opportunity__c =oppt.id );
        insert oppAtt ;
        
        string before = 'Testing base 64 encode';            
        Blob beforeblob = Blob.valueOf(before);
        
        //Insert contentdocument data
        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData = beforeblob;          
        insert cv;         
        
        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
        
        //insert new ContentDocumentLink
        ContentDocumentLink newFileShare = new ContentDocumentLink();
        newFileShare.contentdocumentid = testcontent.contentdocumentid;
        newFileShare.LinkedEntityId = oppt.Id;
        newFileShare.ShareType= 'V';
        
        //insert new ContentDocumentLink
        ContentDocumentLink newFileShareOppAtt = new ContentDocumentLink();
        newFileShareOppAtt.contentdocumentid = testcontent.contentdocumentid;
        newFileShareOppAtt.LinkedEntityId = oppAtt.Id;
        newFileShareOppAtt.ShareType= 'V';
        
        insert new List<ContentDocumentLink>{newFileShare,newFileShareOppAtt};
        
        //Assert if MIS field is inserted
        Opportunity opp = [select MISAttachmentAdded__c from Opportunity where Id =: oppt.Id];
        
        System.assertNotEquals(opp.MISAttachmentAdded__c, null);
        
    }
    
}