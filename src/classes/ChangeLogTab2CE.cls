/** -----------------------------------------------------------
* Class Name: ChangeLogTab2CE 
* -----------------------------------------------------------
* Description: POLK-WRF- This class is also used 
*               used in WRF application.
* @Last Modified Date and By - 04/13/2018- Anjani Shukla - SFDC1-7933 - Class Maintenance
*/
public with sharing class ChangeLogTab2CE {
      
    public WorkRequestForm__c wrf {get; set;}
    public ChangeLog__c c;
    Public Attachment myfile;
    Public String wrfid {get; set;}
    Public String delid {get; set;}
    Public String clid {get; set;}
    public List<ChangeLog__c> ChangelogList;
    public MultiAttachmentController aMultiAttachmentController { get; set; }
    public string changeLogId { get; set; }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017 
    // @description: This method is used in WRF POLK.
    // @return: NA
    //----------------------------- 
    public ChangeLogTab2CE(){
        wrfid='';
        aMultiAttachmentController = new MultiAttachmentController ();
        changeLogId = ApexPages.currentPage ().getParameters ().get ( 'id' );
    }
    
    private ApexPages.StandardController con;
    
     
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017 
    // @description: (Constructor) Getting the current change log record- This method is used in WRF POLK.
    // @return: NA
    // @Modification date : 10th Nov,2017
    // @Modification : Added condition inside if statement to check for null.
    // @Modified by : Ankita Singh
    //----------------------------- 
    public ChangeLogTab2CE(ApexPages.StandardController controller) {
        con=controller;
        c=(ChangeLog__c)controller.getRecord();

        aMultiAttachmentController = new MultiAttachmentController ();
        if(ApexPages.currentPage ().getParameters ().get ( 'id' ) != null){
            changeLogId = ApexPages.currentPage ().getParameters ().get ( 'id' );
            system.debug('changeLogId from url ***'+changeLogId);
        } else{
        	changeLogId = c.id;
            system.debug('changeLogId from controller ***'+changeLogId);
            
        }
        //changeLogId = wrf.id;

        if ( string.valueOf ( ApexPages.currentPage () ).contains ( '/apex/ChangeLog' ) || changeLogId != null )
        {
            ChangeLog__c aChangeLog = 
            [
                SELECT c.id,c.WorkRequestForm__c, c.CreateDate__c, c.OwnerID, c.Status__c, c.Name, c.RevisedRequestDate__c,
                       c.ChangeDocumentedBy__c, c.ChangeDescription__c, ( SELECT Id, Name, Description, BodyLength FROM Attachments )
                  FROM ChangeLog__c c
                 WHERE Id = : changeLogId
            ];

            aMultiAttachmentController.idAttachmentListMap.put ( aChangeLog.Id, aChangeLog.Attachments );
        }
        system.debug ( 'a map - ' + aMultiAttachmentController.idAttachmentListMap );
    }

    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017 
    // @description: Displays a form message if a work request has been submitted.     - This method is used in WRF POLK.
    // @return: NA
    //-----------------------------    
   
    public String getPmsg() {
        if(c<>null && c.Status__c <> 'Rejected' && c.Status__c <> 'Approval Pending' && c.Status__c <> 'Approved'){    
        return 'PLEASE NOTE: Production comments are required when rejecting a Change Log. ';
        }else{
            return 'This change log is '+ c.Status__c.toLowerCase() + '.' ;
        }
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017 
    // @description: Refreshes the change log list- This method is used in WRF POLK.
    // @return: NA
    //-----------------------------    
   
    // Refreshes the change log list
    public PageReference reset() {
        if(wrf<>null){wrfid=wrf.id;}
        ChangelogList = [Select c.WorkRequestForm__c, c.CreateDate__c, c.OwnerID, c.Status__c, c.Name, c.RevisedRequestDate__c, 
        c.ChangeDocumentedBy__c, c.ChangeDescription__c,(select id,name,description,bodylength from Attachments) From ChangeLog__c c
                        where workrequestForm__c=:wrfid order by c.name];
        
        for ( ChangeLog__c each : ChangelogList )
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
    // @description: When you add a change log from a WRF Record- This method is used in WRF POLK.
    // @return: NA
    //-----------------------------    
   
   
    public PageReference add() {
        // get current WRF associated w/ change log
        workrequestform__c w = [select id, ownerid, changelogs__c from workrequestform__c where id =: wrfid];
        
        // if there are no change logs in the WRF, set the number of existing change logs to 0
        if (w.ChangeLogs__c == null)
        {
                w.ChangeLogs__c = 0;
        
        // if there are there are less than 20 change logs, the user can add another
        // this is an imposed limit on the number of change logs so they are not used as WRF's  
        }else if (w.ChangeLogs__c < 20) {
        
            // create new change log
            ChangeLog__c c = new ChangeLog__c(Status__c='Draft',OwnerID=userinfo.getuserid(),workrequestForm__c=wrfid,
            ChangeDocumentedBy__c=userinfo.getuserid());
                    upsert c;
            
            // refreshes the page
                    reset();
                    
            
            // gets the # of change logs associated with the current WRF
            w.ChangeLogs__c = [select count() from ChangeLog__c where workrequestform__c =: wrfid];            

            upsert w;
            
        } else {
   
        
        // standard 4 line redirect
        PageReference pageRef = Page.WREdit;
        pageRef.getParameters().put('ID',w.id);
        pageRef.setRedirect(True);
        return pageRef;

        }               

        // don't return anything
        return null;
        
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017 
    // @description: Method when someone clicks the Approve & Create Job Button- This method is used in WRF POLK.
    // @return: NA
    //-----------------------------    
   
      public PageReference crApproveCreate() {
        //save all current changes (product comments, programmer assigned)
        con.save();
        c.status__c='Approved';
        
        //Figure out who we should assign the job to
        if (c.Programmer__c == NULL) {
            c.OwnerId = UserInfo.getuserid();
        }
        else {
            
           c.OwnerId = c.Programmer__c;
        }
        
        PLCJob__c newJob;
        
        workrequestform__c wrf = [select id, changelogsplc__c, opportunityname__c, name, jobnumber__c, cycle__c, 
                                    cyclestart__c, jobtype__c, requeststatus__c, programmerassigned__c, ownerID 
                                    from workrequestform__c where id =: c.WorkRequestForm__c ];
        
        // How many jobs have been created from change logs -> wrf.ChangeLogs_PLC__c
        // This field is displayed on the PLC as part of the job number.  It is not displayed on WRF
        if (wrf.changelogsplc__c == null) {
                wrf.ChangeLogsPLC__c = 1;
        }              
        else {
                wrf.ChangeLogsPLC__c++;
        }
        
        upsert wrf;
        
        newJob = new PLCJob__c();
        newJob.RequestedDate__c = c.RevisedRequestDate__c;
        newJob.Opportunity__c = wrf.OpportunityName__c;
        newJob.JobName__c = wrf.Name;
        // Number of PLC jobs created from changes assigned
        newJob.ChangeCounter__c = wrf.ChangeLogsPLC__c;
        newJob.JobType__c = wrf.JobType__c;
        newJob.WorkRequestForm__c = wrf.ID;
        newJob.OwnerID = c.OwnerID;
        newJob.Cycle__c = wrf.Cycle__c;
        newJob.CycleStart__c = wrf.CycleStart__c;
        // # cycles is not copied from WRF into PLC from change logs
        //newJob.Number_of_Cycles__c = wrf.Number_of_Cycles__c;
        newJob.JobNumber__c = wrf.JobNumber__c;
        //Added Change Log reference to PLC
        newJob.ChangeLog__c = c.Id;
        newJob.SubmittedDate__c = c.SubmittedDateTime__c;
            
            
        insert newJob;  
        //Added this to tag the change request w/ the job it was created from. 
        c.PLCJob__c = newJob.Id;
        upsert c;
    
        //Increment up the change logs plc field
        
        if (wrf.changelogsplc__c == null) {
                wrf.ChangeLogsPLC__c = 1;
        }      
        
        else {
                wrf.ChangeLogsPLC__c++;
        }
        upsert wrf;
        
        // standard 4 page redirect lines
        PageReference jobPage = Page.plcjobedit;
        jobPage.getParameters().put('ID',newJob.ID);
        jobPage.setRedirect(True);
        return jobPage;
    }
        
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017 
    // @description: Save method - This method is used for POLK WRF.
    // @return: NA
    //-----------------------------    
   
    public void save() {
        
      ChangeLog__c tobeSaved = null;
      
      
      for(ChangeLog__c c : ChangelogList)
                        if (c.Id == clid) {
                        tobeSaved = c;          
       }
       
       tobeSaved.Status__c = 'Draft';
       
       upsert tobeSaved;
       reset();
       
       
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017 
    // @description: This is the save used on the Change Log page when you're looking at a single change log.This method is used for POLK WRF.
    // @return: NA
    //----------------------------- 
   
   
    public void newSave() {
        con.save();
        
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017 
    // @description: Reject a change request - same as WRF logic.This method is used for POLK WRF.
    // @return: NA
    //----------------------------- 
    
    public PageReference crReject() {
        
        //save all current changes (product comments, programmer assigned)
        con.save();

        ChangeLog__c cToUpdate = [select id, ownerid, createdbyid, status__c from ChangeLog__c where id =: c.id];        
        
        if(c.ProductionComments__c <> ''){

        cToUpdate.Status__c = 'Rejected';
        cToUpdate.OwnerId = cToUpdate.CreatedByid;
                update cToUpdate;  
        }
        
        PageReference pageRef  = Page.ChangeLog;
        pageRef.getParameters().put('ID',cToUpdate.ID);
        pageRef.setRedirect(True);
        return pageRef;
        
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017 
    // @description: Approve a work requestThis method is used for POLK WRF.
    // @return: NA
    //----------------------------- 
    public PageReference crApprovePending() {
        
        //save all current changes (product comments, programmer assigned)
        con.save();

        c.Status__c = 'Approval Pending';
        if (c.Programmer__c == NULL) {
            c.OwnerId = UserInfo.getuserid();
        }
        else {   
            c.OwnerId = c.Programmer__c;
        }
                update c;       
                PageReference pageRef  = Page.ChangeLog;
        pageRef.getParameters().put('ID',c.ID);
        pageRef.setRedirect(True);
        return pageRef;
        
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017 
    // @description: Approve a work requestThis method is used for POLK WRF.
    // @return: NA
    //----------------------------- 
    
    public PageReference crApprove() {
        con.save();
        string cl;
        cl = con.getId();
        
        ChangeLog__c clToUpdate = [select id, ownerid, programmer__c, createdbyid, status__c from ChangeLog__c where id =: cl];
        clToUpdate.Status__c = 'Approved';
        clToUpdate.OwnerId = clToUpdate.CreatedByid;

                if (cltoUpdate.Programmer__c == NULL) {
            clToUpdate.OwnerId = UserInfo.getuserid();
        }
        
        else {
            
            clToUpdate.OwnerId = clToUpdate.Programmer__c;
        }
                update clToUpdate;              
                
        PageReference pageRef  = Page.ChangeLog;
        pageRef.getParameters().put('ID',clToUpdate.ID);
        pageRef.setRedirect(True);
        return pageRef;
        
    } 
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017 
    // @description:  Delete Button.This method is used for POLK WRF.
    // @return: NA
    //----------------------------- 
    public PageReference crDelete() {
        workrequestform__c w = [select id, ownerid, changelogs__c from workrequestform__c where id =: c.WorkRequestForm__c];
        
        //Wrap this in try/catch to capture permissions issues and inform the user
        try {
            delete c;   
        } catch (DMLException e) {
            //get the type of DML issue that occurred
            //if it is an insufficient access error, then the user doesn't have permission to delete
            if(e.getDmlType(0) == StatusCode.INSUFFICIENT_ACCESS_OR_READONLY)
                c.addError('You do not have permissions to Delete this Change Log.');
            else //just print the raw message for everything else (unlikely to happen)
                ApexPages.addMessages(e);
            //stay on the same page if there was an issue
            return null;
        }
        
        w.ChangeLogs__c = [select count() from ChangeLog__c where workrequestform__c =: w.id];  
        upsert w;
            
        //after delete, go back to WRF Redirect page to be routed to the proper WREdit page
        PageReference pageRef = Page.WRFRedirect;
        pageRef.getParameters().put('id',c.WorkRequestForm__c);
        pageRef.setRedirect(True);
        return pageRef;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017 
    // @description:  This method is used for POLK WRF.
    // @return: NA
    //----------------------------- 
    
    public PageReference Submit() {
        
              // if for any reason we are missing the reference 
                if (clid== null) {
                        return null;
                }

                        ChangeLog__c tobeSaved = null;
      
                        for(ChangeLog__c c : ChangelogList)
                                                if (c.Id == clid) {
                        tobeSaved = c;          
                        }
                        
                        //Original Query
                        //workrequestform__c w = [select id, ownerid,Mapping__c,Data_Extract_Global_VIO_PARC__c,PARC_Data_Files__c, Loyalty__c, form_type__c from workrequestform__c where id =: tobeSaved.workrequestform__c];
                        
                        
                        //New Query
                        workrequestform__c w = 
                            [select id, ownerid, formtype__c,
                             AdhocCustom__c, AutoTrackerReport__c, AutoNews__c, PolkInsightProductionMessage__c, 
                             CARB__c, ChinaCV__c, ChinaDataRequests__c, CompletePrefixFile__c, Custom__c, CVINA__c, 
                             DataExtractnewreg__c, DataExtractGlobalVIOPARC__c, ReportDataFile__c, DMS__c, 
                             DrivewayCalculator__c, FileCleanse__c, FleetFind__c, ListRequest__c, Loyalty__c, 
                             Mapping__c, MarketInsightSystem__c, PARCDataFiles__c, MINICPF__c, 
                             ModelSegmentation__c, NewRegSystem__c, NewRegNewFor__c, PS__c, PARCGlobal__c, 
                             PCCVINA__c, PCVINA__c, PCVIS__c, PolkInsightChinaSystem__c, Profile__c, Recall__c, 
                             Recover__c, AdHocReport__c, SalesMatch__c, SmartLink__c, TableauVisualization__c, 
                             TIPNetNewTrailer__c, TIPNetNewTruck__c, TIPNetSystem__c, TIPNetVehiclesinOperation__c, 
                             TLAS__c, ScrappageMedianAge__c, Vfacts__c, VINPrefixFile__c, VINPrice__c, VINTelligence__c, 
                             VINTrace__c, VINVerification__c, VINA__c, Vindicator__c, VIS__c, VOS__c, WorldviewVIO__c,
                             Analytics__c, PolkConnectSystem__c
                             from workrequestform__c 
                             where id =: tobeSaved.WorkRequestForm__c];
                        //End New Query
                        
                        
                        ID queueID = XedeUtility.ProductionQueue(w);
                        tobeSaved.OwnerID = queueID;
                        tobeSaved.Status__c = 'Submitted';
                        tobeSaved.SubmittedDateTime__c = datetime.now();
                        
                        upsert tobeSaved;

        // standard 4 line redirect
        
        PageReference pageRef = Page.WRFRedirect;
        pageRef.getParameters().put('ID', tobeSaved.WorkRequestForm__c);
        pageRef.setRedirect(True);
        return pageRef;
    } 
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017 
    // @description:  This method is used for POLK WRF.
    // @return: NA
    //----------------------------- 
    public List<ChangeLog__c> getChangelogs() {
        if(ChangelogList==null){
            reset();
        }
        return ChangelogList;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017 
    // @description:  This method is used for POLK WRF.
    // @return: NA
    //----------------------------- 
   
    public PageReference DeleteAccount()
   {
      // if for any reason we are missing the reference 
      if (delid== null) {
         return null;
      }
      // find the account record within the collection
      ChangeLog__c tobeDeleted = null;
      for(ChangeLog__c c : ChangelogList)
       if (c.Id == delid) {
          tobeDeleted = c;
          break;
       }
      id clwrfid = tobeDeleted.WorkRequestForm__c; 
      //if account record found delete it
      if (tobeDeleted != null) {
       Delete tobeDeleted;
      }
      
      workrequestform__c w = [select id, ownerid, changelogs__c from workrequestform__c where id =: clwrfid];
      w.ChangeLogs__c = [select count() from ChangeLog__c where workrequestform__c =: wrfid];  
      upsert w;

      PageReference pageRef = Page.WREdit;
      pageRef.getParameters().put('ID',w.id);
      pageRef.setRedirect(True);
      return pageRef;

   } 
  
}