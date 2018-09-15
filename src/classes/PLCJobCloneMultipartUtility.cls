//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This class is used in POLK WRF.
    // @return: NA
    //----------------------------- 
public with sharing class PLCJobCloneMultipartUtility { //PLCJobCloneMultipartUtility
        
        public list<plcjob__c> newJobs {get; set;}
        private final plcjob__c masterPLC;
        private final plcjob__c clonedPLC;
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: ApexPages.StandardController
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------     
    public PLCJobCloneMultipartUtility(ApexPages.StandardController controller) {

        masterPLC = (plcjob__c) controller.getRecord();
        clonedPLC = [select id, ownerid, jobname__c, JobType__c, NumberofCycles__c, 
                cyclestart__c, cycle__c, opportunity__c, opportunityvalue__c, processtouse__c,
                currencyisocode, peerreviewer__c, encryptionrequired__c,
                encryptionkey__c, ftprequired__c, ftpinformationinwrf__c, ftppath__c, 
                ftpuserid__c, ftppassword__c, workrequestform__c, jobnumber__c,
                //ELS added 7/17/12
                StartDate__c, NegotiatedDate__c,RequestedDate__c,ChangeLog__c, submitteddate__c
                from plcjob__c where id = :masterPLC.ID]; 
                
        id cloneID = clonedPLC.ID;
        
        date nextDate = clonedPLC.StartDate__c;
        date negDate =  clonedPLC.NegotiatedDate__c ;
        date reqDate =  clonedPLC.RequestedDate__c ;        
        
        
        string nextDateDOW;
        newJobs = new list<plcjob__c>();
        integer totalJobs; 
        totalJobs = integer.valueOf(masterPLC.NumberofParts__c);
                        
                for (integer i = 2; i <= totalJobs; i++) {

                        plcjob__c tempPLC = clonedPLC.clone(false);
        
                        tempPLC.multipartnum__c = i;
                        tempPLC.StartDate__c = nextDate;
                        tempPLC.NegotiatedDate__c = negDate;
                        tempPLC.RequestedDate__c = reqDate;
                        tempPLC.OwnerID = tempPLC.OwnerID;
                        tempPLC.WRFQuality__c = 'No Set-up Required';
                        tempPLC.ParentJob__c = cloneID;        
                        tempPLC.isMultipart__c = True;                  
                        newJobs.add (tempPLC);
                        
        }
    
    }
        //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: PageReference 
    //----------------------------- 
        public PageReference Cancel() {
        
        plcjob__c p = [Select id From plcjob__c Where Id = :ApexPages.currentPage().getParameters().get('id')];
        PageReference backPage = Page.PLCJobEdit;
        backPage.getParameters().put('id',p.id);
        backPage.setRedirect(true);
        return backPage;     
    } 
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return:PageReference  
    //----------------------------- 
        public PageReference Create_Jobs() {
                
        plcjob__c originalPLC = masterPLC.clone(true);
        originalPLC.isMultipart__c = True;      
        update originalPLC;
        
        insert newJobs;
        
        plcjob__c p = [Select id From plcjob__c Where Id = :ApexPages.currentPage().getParameters().get('id')];
        PageReference backPage = Page.PLCJobEdit;
        backPage.getParameters().put('id',p.id);
        backPage.setRedirect(true);
        return backPage;     
                
    } 
   
    
}