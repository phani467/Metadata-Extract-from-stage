//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
public with sharing class OrderReqTabCE {
   
    public OrderRequest__c o;
    public workrequestform__c wrf {get; set;}
    public Attachment myfile;
    public String wrfid {get; set;}
    public String delid {get; set;}
    public String orid {get; set;}
    public List<OrderRequest__c> OrderRequestList;
    public map < string, list < Attachment > > orderRequestAttachmentListMap { get; set; }
    public MultiAttachmentController aMultiAttachmentController { get; set; }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public OrderReqTabCE(){
        wrfid='';
        aMultiAttachmentController = new MultiAttachmentController ();
    }
    
    private ApexPages.StandardController con;
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public OrderReqTabCE(ApexPages.StandardController controller) {
        con=controller;
        o=(OrderRequest__c)controller.getRecord();
        
        aMultiAttachmentController = new MultiAttachmentController ();
        wrfid = ApexPages.currentPage ().getParameters ().get ( 'id' );
        
        if ( string.valueOf ( ApexPages.currentPage () ).contains ( '/apex/OrderRequest' ) )
        {
            OrderRequestList = [Select o.Name,o.OwnerID, o.PreSort__c, o.status__c,o.PreSortDescription__c, o.WorkRequestForm__c, 
                                o.PostSort__c, o.PostSortDecription__c, o.OrderRequestAttachements__c, 
                                o.KeyfieldCode__c, o.JobQueryID__c, o.FormatOrder__c, o.DesiredCount__c, 
                                o.CutbackOptions__c, o.CustomDescription__c, 
                                o.CustPostProcessing__c, o.AvailabilityCount__c,(select id,name,description,bodylength from Attachments) 
                                From OrderRequest__c o
                                    where Id=:wrfid];
            system.debug ( 'the list - ' + OrderRequestList );
            for ( OrderRequest__c each : OrderRequestList )
            {
                aMultiAttachmentController.idAttachmentListMap.put ( each.Id, new list < Attachment > () );
                
                if ( each.Attachments != null )
                    aMultiAttachmentController.idAttachmentListMap.put ( each.Id, each.Attachments );
            }
        }
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public void newSave() {
        con.save();
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------     
    public PageReference crApprovePending() {

        o.Status__c = 'Approval Pending';
        if (o.Programmer__c == NULL) {
            o.OwnerId = UserInfo.getuserid();
        }
        else {   
            o.OwnerId = o.Programmer__c;
        }
                update o;       
                PageReference pageRef = Page.OrderRequest;
        pageRef.getParameters().put('ID',o.ID);
        pageRef.setRedirect(True);
        return pageRef;
        
    }

    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public PageReference crApprove() {
        con.save();
        string cl;
        cl = con.getId();
        
        OrderRequest__c clToUpdate = [select id, ownerid, programmer__c, createdbyid, status__c from OrderRequest__c where id =: cl];
        clToUpdate.Status__c = 'Approved';
        clToUpdate.OwnerId = clToUpdate.CreatedByid;

                if (cltoUpdate.Programmer__c == NULL) {
            clToUpdate.OwnerId = UserInfo.getuserid();
        }
        
        else {
            
            clToUpdate.OwnerId = clToUpdate.Programmer__c;
        }
                update clToUpdate;              
                
                PageReference pageRef = Page.OrderRequest;
        pageRef.getParameters().put('ID',clToUpdate.ID);
        pageRef.setRedirect(True);
        return pageRef;
        
    }

    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public PageReference crDelete() {
        
        OrderRequest__c o = [select id, ownerid, createdbyid, status__c, workrequestform__c from OrderRequest__c where id =: o.id];
        delete o;
        
        PageReference pageRef = Page.WREdit;
        pageRef.getParameters().put('ID',o.WorkRequestForm__c);
        pageRef.setRedirect(True);
        return pageRef;
    } 
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public PageReference crReject() {

        OrderRequest__c cToUpdate = [select id, ownerid, createdbyid, status__c from OrderRequest__c where id =: o.id];
        cToUpdate.Status__c = 'Rejected';
        cToUpdate.OwnerId = cToUpdate.CreatedByid;
                update cToUpdate;               
                
                PageReference pageRef = Page.OrderRequest;
        pageRef.getParameters().put('ID',cToUpdate.ID);
        pageRef.setRedirect(True);
        return pageRef;
        
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public PageReference reset() {
        if(wrf<>null){wrfid=wrf.id;}
        OrderRequestList = [Select o.Name,o.OwnerID, o.PreSort__c, o.status__c,o.PreSortDescription__c, o.WorkRequestForm__c, 
                            o.PostSort__c, o.PostSortDecription__c, o.OrderRequestAttachements__c, 
                            o.KeyfieldCode__c, o.JobQueryID__c, o.FormatOrder__c, o.DesiredCount__c, o.CutbackOptions__c, 
                            o.CustomDescription__c, 
                            o.CustPostProcessing__c, o.AvailabilityCount__c,(select id,name,description,bodylength from Attachments) 
                            From OrderRequest__c o
                            where workrequestForm__c=:wrfid];
        
        for ( OrderRequest__c each : OrderRequestList )
        {
            aMultiAttachmentController.idAttachmentListMap.put ( each.Id, new list < Attachment > () );
            
            if ( each.Attachments != null )
                aMultiAttachmentController.idAttachmentListMap.put ( each.Id, each.Attachments );
        }
        
        return null;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public PageReference Submit() {
        
              // if for any reason we are missing the reference 
                if (orid== null) {
                        return null;
                }

                        OrderRequest__c tobeSaved = null;
      
                        for(OrderRequest__c o : OrderRequestList)
                                                if (o.Id == orid) {
                        tobeSaved = o;          
                        }
                        
                        workrequestform__c w = [
                             select id, ownerid, formtype__c,
                             AdhocCustom__c, AutoTrackerReport__c, AutoNews__c, PolkInsightProductionMessage__c, 
                             CARB__c, ChinaCV__c, ChinaDataRequests__c, CompletePrefixFile__c, Custom__c, CVINA__c, 
                             DataExtractnewreg__c, DataExtractGlobalVIOPARC__c, ReportDataFile__c, DMS__c, 
                             DrivewayCalculator__c, FileCleanse__c, FleetFind__c, ListRequest__c, Loyalty__c, 
                             Mapping__c, MarketInsightSystem__c, PARCDataFiles__c, MINICPF__c, 
                             ModelSegmentation__c, NewRegSystem__c, NewRegNewFor__c, PS__c, PARCGlobal__c, 
                             PCCVINA__c, PCVINA__c, PCVIS__c, PolkInsightChinaSystem__c, Profile__c, Recall__c, 
                             Recover__c, AdHocReport__c, SalesMatch__c, SMARTLink__c, TableauVisualization__c, 
                             TIPNetNewTrailer__c, TIPNetNewTruck__c, TIPNetSystem__c, TIPNetVehiclesinOperation__c, 
                             TLAS__c, ScrappageMedianAge__c, Vfacts__c, VINPrefixFile__c, VINPrice__c, VINTelligence__c, 
                             VINTrace__c, VINVerification__c, VINA__c, Vindicator__c, VIS__c, VOS__c, WorldviewVIO__c,
                             Analytics__c, PolkConnectSystem__c
                             from workrequestform__c where id =: tobeSaved.WorkRequestForm__c];

                        ID queueID = XedeUtility.ProductionQueue(w);
                        tobeSaved.OwnerID = queueID;
                        tobeSaved.Status__c = 'Submitted';
                        tobeSaved.Requestor__c = userinfo.getuserid();
                        tobeSaved.SubmittedDateTime__c = datetime.now();
                        
                        upsert tobeSaved;

        PageReference pageRef = Page.WREdit;
        pageRef.getParameters().put('ID', tobeSaved.WorkRequestForm__c);
        pageRef.setRedirect(True);
        return pageRef;
    } 
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public PageReference add() {
        
        OrderRequest__c o = new OrderRequest__c(Status__c='Draft', OwnerID=userinfo.getuserid(), workrequestform__c = wrfid);
                upsert o;
                reset();
        return null;       
        
    }

     //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
        public PageReference crApproveCreate() {

        o.status__c='Approved';
        
        //Figure out who we should assign the job to
        if (o.Programmer__c == NULL) {
            o.OwnerId = UserInfo.getuserid();
        }
        else {
            
           o.OwnerId = o.Programmer__c;
        }
        
        PLCJob__c newJob;
        workrequestform__c wrf = [select id, changelogsplc__c, opportunityname__c, name, jobnumber__c, cycle__c, 
                                    cyclestart__c, jobtype__c, requeststatus__c, programmerassigned__c, ownerID 
                                    from workrequestform__c where id =: o.WorkRequestForm__c ];
               
        newJob = new PLCJob__c();
        newJob.Opportunity__c = wrf.OpportunityName__c;
        newJob.JobName__c = wrf.Name;
        newJob.JobType__c = wrf.JobType__c;
        newJob.WorkRequestForm__c = wrf.ID;
        newJob.OwnerID = o.OwnerID;
        newJob.Cycle__c = wrf.Cycle__c;
        newJob.CycleStart__c = wrf.CycleStart__c;
        //newJob.Number_of_Cycles__c = wrf.Number_of_Cycles__c;
        newJob.JobNumber__c = wrf.JobNumber__c;
        newJob.OrderRequest__c = o.Id;
        //DM Added Order Request reference to PLC       
        newJob.OrderRequest__c = o.Id;
        newJob.SubmittedDate__c = o.SubmittedDateTime__c;
    
        insert newJob;  
        //Added this to tag the change request w/ the job it was created from. 
        o.PLCJob__c = newJob.Id;
        upsert o;
           
        PageReference jobPage = Page.PLCJobEdit;
        jobPage.getParameters().put('ID',newJob.ID);
        jobPage.setRedirect(True);
        return jobPage;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public PageReference save() {
        upsert OrderRequestList;
        return null;
    }

    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public List<OrderRequest__c> getOrderRequests() {
        //if(OrderRequestList==null){
            //reset();
        //}
        
        reset ();
        
        return OrderRequestList;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public void DeleteAccount()
   {
      // if for any reason we are missing the reference 
      if (delid== null) {
      
         return;
      }
     
      // find the account record within the collection
      OrderRequest__c tobeDeleted = null;
      for(OrderRequest__c c : OrderRequestList)
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