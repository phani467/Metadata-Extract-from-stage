//-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This Class is related to Legacy POLK application.
// @return: NA
//----------------------------- 
public with sharing class InputFilesTabCE {
   
    public workrequestform__c wrf {get; set;}
    Public Attachment myfile;
    Public String wrfid {get; set;}
    Public String delid {get; set;}
    public List<InputFile__c> InputFileList;
    public MultiAttachmentController aMultiAttachmentController { get; set; }

    //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method is the contructor.
// @return: NA
//----------------------------- 
    public InputFilesTabCE ()
    { 
        aMultiAttachmentController = new MultiAttachmentController();
        wrfid='';
    }
      //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This is a  refrerence method to reset the attachment  value.
// @return: Null
//-----------------------------   
    public PageReference reset() {
        if(wrf<>null){wrfid=wrf.id;}
        InputFileList = [Select i.NumberofRecords__c, i.AdditionalInformation__c ,
                         (select id,name,description,bodylength from Attachments) From InputFile__c i
                        where workrequestForm__c=:wrfid];
        
        for ( InputFile__c each : InputFileList )
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
// @description:  This add methods a new file to the wrf
// @return: Null
//-----------------------------  

    public PageReference add() {
        system.debug ( 'work request form id - ' + wrfid );
        InputFileList.add(new InputFile__c(workrequestForm__c=wrfid));
        return null;
    }

      //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This is a save Input Files method
// @return: Null
//----------------------------- 
    public PageReference save() {
        upsert InputFileList;
        reset ();
        return null;
    }

      //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method helps retrieve input files
// @return: Input Files
//----------------------------- 
    public List<InputFile__c> getinputFiles() {
        if(InputFileList==null){
            reset();
        }
        return InputFileList;
    } 

    /*Public Attachment getmyfile(){
        myfile = new Attachment();
        return myfile;
    }
   
    Public Pagereference Savedoc()
    {
        String wid = wrfid;

        Attachment a = new Attachment(parentId = wid, name=myfile.name, body = myfile.body);
         */
         /* insert the attachment */
        /* insert a;
        return NULL;
    }*/

       //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method deletes input files
// @return: NA
//----------------------------- 
    public void DeleteAccount()
   {
      // if for any reason we are missing the reference 
      if (delid== null) {
      
         return;
      }
     
      // find the account record within the collection
      InputFile__c tobeDeleted = null;
      for(InputFile__c c : InputFileList)
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