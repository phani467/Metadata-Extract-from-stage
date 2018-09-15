//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This class is used in POLK WRF.
    // @return: NA
    //----------------------------- 

public with sharing class PLCJobCloneCyclicalUtility  {
        
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
    public PLCJobCloneCyclicalUtility (ApexPages.StandardController controller) {

        //Grab the current PLC record
        masterPLC = (plcjob__c) controller.getRecord();
        //We don't want to clone all fields, so here are the fields we'll clone.
        clonedPLC = [select 
                CreatePeerReviewTask__c, id, ownerid,jobname__c, 
                JobType__c, NumberOfCycles__c, cyclestart__c, cycle__c, opportunity__c, OpportunityValue__c, 
                processtouse__c, totaljobestimate__c, othercostestimate__c, currencyisocode, 
                peerreviewer__c, encryptionrequired__c, encryptionkey__c, ftprequired__c, 
                ftpinformationinwrf__c, ftppath__c, ftpuserid__c, ftppassword__c, jobnumber__c, 
                JobEstimatedHours__c, workrequestform__c, DeliverableEstimate__c, 
                //ELS added 7/17/12
                OrderRequest__c, SubmittedDate__c, StartDate__c, NegotiatedDate__c,RequestedDate__c,ChangeLog__c
                //ELS added 10/6/15
                ,Team1__c
                
                from plcjob__c where id = :masterPLC.ID];


        id cloneID = clonedPLC.ID;
        //Xede Original
        //date nextDate = clonedPLC.cyclestart__c;
        
        date nextDate = clonedPLC.StartDate__c;
        date negDate =  clonedPLC.NegotiatedDate__c ;
        date reqDate =  clonedPLC.RequestedDate__c ;
        
        
        //use cyclestart__c date if StartDate__c is not populated
        if (clonedPLC.StartDate__c == null ){
            nextDate = clonedPLC.cyclestart__c;
        }
        //use cyclestart__c date if NegotiatedDate__c is not populated
        if (clonedPLC.NegotiatedDate__c == null ){
            negDate = clonedPLC.cyclestart__c;
        }
        //use cyclestart__c date if RequestedDate__c is not populated
        if (clonedPLC.RequestedDate__c == null ){
            reqDate = clonedPLC.cyclestart__c;
        }
        
        
        double estimatedHours = clonedPLC.DeliverableEstimate__c;
        string nextDateDOW;
        string negDateDOW;
        string reqDateDOW;
        newJobs = new list<plcjob__c>();
        
        //Here we iterate through the number of cycles based on the # put in the PLC Job
        //First thing that happens to set the date of the cycle based on the cycle type.
        
        for (integer i = 1; i <= masterPLC.NumberOfCycles__c - 1; i++) {

                        plcjob__c tempPLC = clonedPLC.clone(false);
        
                        if (tempPLC.Cycle__c == 'Week Days' ){ //&& i <> 1) {
                                nextDate = nextDate.addDays(1);
                                negDate = negDate.addDays(1);
                                reqDate = reqDate.addDays(1);
                        }
                        
                        else if (tempPLC.Cycle__c == 'Weekly'  ){ //&& i <> 1) {
                                nextDate = nextDate.addDays(7);
                                negDate =  negDate.addDays(7);
                                reqDate =  reqDate.addDays(7);
                        }
                        
                        else if (tempPLC.Cycle__c == 'Semi-Monthly'  ){ //&& i <> 1) {
                                nextDate = nextDate.addDays(15);
                                negDate =  negDate.addDays(15);
                                reqDate =  reqDate.addDays(15);
                        }
                        
                        else if (tempPLC.Cycle__c == 'Monthly'  ){ //&& i <> 1) {
                                nextDate = nextDate.addMonths(1);
                                negDate =  negDate.addMonths(1);
                                reqDate =  reqDate.addMonths(1);
                        }
                        
                        else if (tempPLC.Cycle__c == 'Six Week Cycle'  ){ //&& i <> 1) {
                                nextDate = nextDate.addDays(42);
                                negDate =  negDate.addDays(42);
                                reqDate =  reqDate.addDays(42);
                        }
                        
                        else if (tempPLC.Cycle__c == 'Quarterly'  ){ //&& i <> 1) {
                                nextDate = nextDate.addMonths(3);
                                negDate =  negDate.addMonths(3);
                                reqDate =  reqDate.addMonths(3);
                        }
                        
                        else if (tempPLC.Cycle__c == 'Semi-Annually'  ){ //&& i <> 1) {
                                nextDate = nextDate.addMonths(6);
                                negDate =  negDate.addMonths(6);
                                reqDate =  reqDate.addMonths(6);
                        }
                        
                        else if (tempPLC.Cycle__c == 'Annually'  ){ //&& i <> 1) {
                                nextDate = nextDate.addYears(1);
                                negDate =  negDate.addYears(1);
                                reqDate =  reqDate.addYears(1);
                        }
                        
                        else if (tempPLC.Cycle__c == 'Other' ){ //&& i <> 1 ) {
                                nextDate = nextDate.addDays(0);
                                negDate =  negDate.addDays(0);
                                reqDate =  reqDate.addDays(0);
                        }
                        
                        datetime nextDateTime = datetime.newInstance(nextDate.year(), nextDate.month(),nextDate.day());
                        datetime negDateTime = datetime.newInstance(negDate.year(), negDate.month(),negDate.day());
                        datetime reqDateTime = datetime.newInstance(reqDate.year(), reqDate.month(),reqDate.day());
                        
                        nextDateDOW = nextDateTime.format('EEEE');
                        negDateDOW  = negDateTime.format('EEEE');
                        reqDateDOW = reqDateTime.format('EEEE');
                        
                        //Backdate if Saturday or Sunday                       
                        if (nextDateDOW == 'Saturday') {
                                nextDate = nextDate.addDays(-1);
                        }
                        
                        if (nextDateDOW == 'Sunday') {
                                nextDate = nextDate.addDays(-2);
                        }
                        
                        // Same backdate for negotiated date
                        if (negDateDOW == 'Saturday') {
                                negDate = negDate.addDays(-1);
                        }
                        
                        if (negDateDOW == 'Sunday') {
                                negDate = negDate.addDays(-2);
                        }
                        
                        // Same backdate for RequestedDate__c 
                        if (reqDateDOW == 'Saturday') {
                                reqDate = reqDate.addDays(-1);
                        }
                        
                        if (reqDateDOW == 'Sunday') {
                                reqDate = reqDate.addDays(-2);
                        }
                        
                        
                        
                        tempPLC.cycleoccurance__c = i;
                        tempPLC.StartDate__c = nextDate;
                        tempPLC.NegotiatedDate__c = negDate;
                        tempPLC.RequestedDate__c = reqDate;
                        tempPLC.OwnerID = tempPLC.OwnerID;
                        tempPLC.WRFQuality__c = 'No Set-up Required';
                        tempPLC.ParentJob__c = cloneID;
                        tempPLC.totaljobestimate__c = estimatedHours;
  
                        newJobs.add (tempPLC);
                        
                        //Since we want the next date to be based on the standard, not backdated next date, we'll reverse what we did
                        //For the next loop
                        
                        if (nextDateDOW == 'Saturday') {
                                nextDate = nextDate.addDays(1);
                        }
                        
                        if (nextDateDOW == 'Sunday') {
                                nextDate = nextDate.addDays(2);
                        }
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
    // @return: PageReference
    //----------------------------- 
    public PageReference Create_Jobs() {
        
        insert newJobs;
        //create extra tasks -- need IDs from insert statement
        CreateExtraTasks();
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
    // @return: NA
    //----------------------------- 
    private void CreateExtraTasks() {
        //System.debug('Creating extra tasks.');
        
        List<plcjob__c> toUpdate = new List<plcjob__c>();
        List<JobTask__c> jobTasks = new List<JobTask__c>();
        
        for (plcjob__c p : newJobs){
            //System.debug('Id: ' + p.id);
            boolean hasUpdate=false;
            if(p.CreatePeerReviewTask__c == true) {
                jobTasks.add(CreateJobTask(p, 'Peer Review', .25));
                p.CreatePeerReviewTask__c=false;
                hasUpdate=true;
                //System.debug('Created peer review task');
            } //else System.debug('No peer review task');
            
            if(hasUpdate) 
                toUpdate.add(p);
        }
        System.debug('PLCs Updated: ' + toUpdate.size());
        System.debug('New Job Tasks: ' + jobTasks.size());
        insert jobTasks;
        update toUpdate;

    } 
    
    /* Commented for code coverage. May be required in the future.
    private JobTask__c CreateJobTask(plcjob__c parent, String jobTitle) {
        return CreateJobTask(parent, jobTitle, 0.0);
    }
    */
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: plcjob__c , String,Decimal
    // @description:  This method is used in POLK WRF.
    // @return: JobTask__c 
    //----------------------------- 
    private JobTask__c CreateJobTask(plcjob__c parent, String jobTitle, Decimal estimatedHours) {
        
        JobTask__c newTask;
        
        newTask = new JobTask__c();
        newTask.TaskName__c = jobTitle;
        newTask.PLCJob__c = parent.id;
        newTask.Status__c = 'Open';
        newTask.Assignedto__c = parent.OwnerId;
        newTask.EstimatedHours__c = estimatedHours;
        
        return newTask;
    }

    
}