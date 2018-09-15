//-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This Class is related to Legacy POLK application.
// @return: NA
//----------------------------- 
public with sharing class MultiAttachmentController
{
    //-=PROPERTIES=-
    public Id sobjId { get; set; }
    
    public Id wrfId { get; set; }
    
    public String adelid { get; set; }
    
    public list < Attachment > attachmentList { get; set; }
    
    public map < string, list < Attachment > > idAttachmentListMap { get; set; }
    
    public List<Attachment> newAttachments { get; set; }
    
    public static final Integer NUM_ATTACHMENTS_TO_ADD=10;
    
    public string attacher { get; set; }

//-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method is a CONSTRUCTOR.
// @return: NA
//----------------------------- 
    public MultiAttachmentController ()
    {   
        sobjId = ApexPages.currentPage ().getParameters ().get ( 'soid' );
        
        wrfId = ApexPages.currentPage ().getParameters ().get ( 'wrfid' );
        
        attacher = ApexPages.currentPage ().getParameters ().get ( 'attacher' );
        
        attachmentList = new list < Attachment > ();
        
        idAttachmentListMap = new map < string, list < Attachment > > ();
        
        newAttachments = new List < Attachment > { new Attachment () };
            
        if ( idAttachmentListMap.containsKey ( sobjId ) )
            attachmentList = idAttachmentListMap.get ( sobjId );
        
        if ( attacher == 'true' & sobjId != null )
        {
            attachmentList = 
            [
                SELECT Id, ParentId, Name, Description, BodyLength 
                  FROM Attachment 
                 WHERE parentId=:sobjId
            ];
        }
    }
 //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method reset the attachements related to the parent id
// @return: NULL
//-----------------------------    
    public PageReference reset () 
    {
        if ( sobjId <> null )
        {
            attachmentList = 
            [
                SELECT Id, ParentId, Name, Description, BodyLength 
                  FROM Attachment 
                 WHERE parentId=:sobjId
            ];
        }
        
        return null;
    }
    
    /*public List < Attachment > getAttachmentList ()
    {
        //reset();
        
        return attachmentList;
    }
    
    public void setAttachmentList ( list < Attachment > anAttachmentList )
    {
        system.debug ( 'we are setting attachments' );
        attachmentList = new list < Attachment > ();
        attachmentList.addAll ( anAttachmentList );
        system.debug ( 'assigned value to attachmentList - ' + attachmentList );
    }*/
//-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method adds more attachment to the WRF
// @return: NA
//----------------------------- 
    public void addMore ()
    {
        for ( Integer idx = 0; idx < NUM_ATTACHMENTS_TO_ADD; idx++ )
            newAttachments.add ( new Attachment () );
    }    
  //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method saves attachment.
// @return: NA
//-----------------------------   
    public void save () 
    {
        List < Attachment > toInsert = new List < Attachment > ();
        
        for ( Attachment newAtt : newAttachments )
        {
            if ( newAtt.Body != null )
            {
                newAtt.parentId = sobjId;
                toInsert.add ( newAtt );
            }
        }
        
        insert toInsert;
        
        newAttachments.clear ();
        
        newAttachments.add ( new Attachment () );
    }
    
    public PageReference done ()
    {
        return new PageReference ( '/apex/WRedit?id=' + wrfId );
    }
  //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method deletes attachment.
// @return: NA
//-----------------------------   
    @RemoteAction
    public static void DeleteAttachment ( string attachmentId )
    {
        system.debug ( attachmentId );
        
        try
        {
            delete new Attachment ( Id = attachmentId );     
        }
        catch ( dmlException de )
        {
            system.debug ( 'DML EXCEPTION - ' + de );   
        }
    }
    
    /*public void DeleteAttach()
    {
        string temp = ApexPages.currentPage ().getParameters ().get ( 'adelid' );
        
        /* if for any reason we are missing the reference
        if ( adelid == null )
            return;
     
        try
        {
            delete new Attachment ( Id = adelId );   
        }
        catch ( dmlException de )
        {
            
        }
        
        //return null;
        
        // find the account record within the collection
        /*for( Attachment a : idAttachmentListMap.get ( sobjId ) )
        {
            if ( a.Id.equals ( adelid ) ) 
            {
                tobeDeleted = a;
                
                break;
            }
        }
          
        //if account record found delete it
        if ( tobeDeleted != null ) 
        {
            Delete tobeDeleted;
            
            //reset();
        }
    }*/
    
    /******************************************************
    *
    * Unit Tests
    *
    *****************************************************/
 /*   Commenting this code as the test class is created separately 
    private static testMethod void testController ()
    {
        Account acc = new Account ( Name='Unit Test', BillingStreet='123 Four St', BillingCity='Chicago',BillingCountry='United States' );
        
        insert acc;
        
        MultiAttachmentController controller = new MultiAttachmentController ();
        
        controller.sobjId=acc.id;
        
        //System.assertEquals ( 0, controller.getAttachments ().size () );
        
        System.assertEquals ( 1, controller.newAttachments.size () );
        
        controller.addMore ();
        
        System.assertEquals ( 1 + NUM_ATTACHMENTS_TO_ADD, controller.newAttachments.size () );
        
        // populate the first and third new attachments
        List < Attachment > newAtts = controller.newAttachments;
        newAtts [ 0 ].Name = 'Unit Test 1';
        newAtts [ 0 ].Description = 'Unit Test 1';
        newAtts [ 0 ].Body = Blob.valueOf ( 'Unit Test 1' );

        newAtts [ 2 ].Name = 'Unit Test 2';
        newAtts [ 2 ].Description = 'Unit Test 2';
        newAtts [ 2 ].Body = Blob.valueOf ( 'Unit Test 2' );
        
        controller.save ();
        
        //System.assertEquals ( 2, controller.getAttachments ().size () );
        System.assertNotEquals ( null, controller.done () );
        
        /*controller.deleteAttach ();
        System.assertEquals ( null, controller.adelid );
    } */
}