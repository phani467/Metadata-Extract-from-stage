//-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This Class is related to Legacy POLK application.
// @return: NA
//----------------------------- 
public with sharing class InternalDataTabCE { 

    //public workrequestform__c wrf {get; set;}
    public workrequestform__c wrf {get; set;}
    public Attachment myfile;
    public String wrfid {get; set;}
    public String delid {get; set;}
    public List<InternalData__c> InternalDataList; 
    public map < string, list < Attachment > > internalDataAttachmentListMap { get; set; }
    public MultiAttachmentController aMultiAttachmentController { get; set; }
 //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This is a constructor method
// @return: NA
//-----------------------------    
     public InternalDataTabCE(){
         wrfid='';
         aMultiAttachmentController = new MultiAttachmentController();
    }
   //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method reset the files attached  to workrequestForm. 
// @return: NULL
//----------------------------- 
    public PageReference reset() {
        if(wrf<>null){wrfid=wrf.id;}
        
        InternalDataList = [Select i.RecordType__c, i.ProcessingSpecifications__c, i.Name, i.ManufacturerDivision__c, 
                    i.InternalDataType__c, i.ExpectedOutputQuanity__c,(select id,name,description,bodylength from Attachments) 
                    From InternalData__c i
                    where workrequestForm__c=:wrfid];
        
        for ( InternalData__c each : InternalDataList )
        {
            aMultiAttachmentController.idAttachmentListMap.put ( each.Id, new list < Attachment > () );
            
            if ( each.Attachments != null )
            {
                aMultiAttachmentController.idAttachmentListMap.put ( each.Id, each.Attachments );
            }
        }
        
        return null;
    }

   //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method adds  files to workrequestForm. 
// @return: NULL
//----------------------------- 
    public PageReference add() {
        InternalDataList.add(new InternalData__c(workrequestForm__c=wrfid));
        return null;
    } 

   //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method save the   files attached to workrequestForm. 
// @return: NULL
//----------------------------- 
    public PageReference save() {
        upsert InternalDataList;
        reset ();
        return null;
    }

   //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method adds  files to workrequestForm. 
// @return: List of of Internal Data
//----------------------------- 
    public List<InternalData__c> getinternalData() {
        if(InternalDataList==null){
            reset();
        }
        return InternalDataList;
    }
    
/*
    Public Attachment getmyfile(){
        myfile = new Attachment();
        return myfile;
    }*/
   
 /*   Public Pagereference Savedoc()
    {
        String wid = wrfid;

        Attachment a = new Attachment(parentId = wid, name=myfile.name, body = myfile.body);
         
         // insert the attachment 
         insert a;
        return NULL;
    }*/

   //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method deletes internal files . 
// @return: NA
//----------------------------- 
    public void DeleteAccount()
   {
      // if for any reason we are missing the reference 
      if (delid== null) {
      
         return;
      }
     
      // find the account record within the collection
      InternalData__c tobeDeleted = null;
      for(InternalData__c c : InternalDataList)
       if (c.Id == delid) {
          tobeDeleted = c;
          break;
       }
      
      //if account record found delete it
      if (tobeDeleted != null) {
       Delete tobeDeleted;
      }
     
      //refresh the data
      reset();
   }      

}