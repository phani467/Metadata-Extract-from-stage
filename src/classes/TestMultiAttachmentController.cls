/******************************************************
 * @author Ankita Singh
 * @date 10thOct 2017
 * @description Test class for unit testing on MultiAttachmentController
    ******************************************************/
    
@isTest(seeAllData=false)
private class TestMultiAttachmentController {  

    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------     
    public static testMethod void testMultiAttachment() {
        
        WorkRequestForm__c newWrf = new WorkRequestForm__c();
        newWrf.FormType__c = 'TLAS';
        upsert newWrf;
        
        List<orderrequest__c> orList = new List<orderrequest__c>();

        OrderRequest__c o = new orderrequest__c();
        o.ProductionComments__c = 'Test';
        o.WorkRequestForm__c = newWrf.id;
        insert o;
        
         MultiAttachmentController con = new MultiAttachmentController ();
        con.attacher = 'true';
        con.sobjId=o.id;
        
        //System.assertEquals ( 0, con.getAttachments ().size () );
        
        System.assertEquals ( 1, con.newAttachments.size () );
        
        con.addMore ();
        
    //    System.assertEquals ( 1 + NUM_ATTACHMENTS_TO_ADD, con.newAttachments.size () );
        
        // populate the first and third new attachments
        List < Attachment > newAtts = con.newAttachments;
        newAtts [ 0 ].Name = 'Unit Test 1';
        newAtts [ 0 ].Description = 'Unit Test 1';
        newAtts [ 0 ].Body = Blob.valueOf ( 'Unit Test 1' );

        newAtts [ 2 ].Name = 'Unit Test 2';
        newAtts [ 2 ].Description = 'Unit Test 2';
        newAtts [ 2 ].Body = Blob.valueOf ( 'Unit Test 2' );
        
        con.save ();
        

   
  Attachment attachments=[select id, name from Attachment where parent.id=:o.id Limit 1];     
  MultiAttachmentController.DeleteAttachment(attachments.id);
con.reset();
        con.done();

   }
    
}