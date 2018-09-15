/** -----------------------------------------------------------
 * Class Name: WRApprovalController
* -----------------------------------------------------------
* Description: Class which supports the approval, rejection, 
* and assign pending of submitted work requests.
* - ---------------------------------------------------------
* Created by: Xede Consulting Group, Inc.
* Modified by: 
* Date Modified: 
*/


public with sharing class WRApprovalController {
    
    public boolean isView{get; set;}
    public boolean rejected = false;
    public WorkRequestForm__c wrf {get; set;}
    public WRApprovalController(){
         
    }
    //Displays a form message if a work request has been submitted.     
    public String getPmsg() {
        if(wrf<>null && rejected == false){    
        return 'This '+wrf.FormType__c+' request ('+wrf.name+'), has been submitted for approval and processing.  It must be approved or rejected to proceed. \n PLEASE NOTE: Rejection comments are required when rejecting a WRF. ';
        }else if(wrf<>null && rejected == true) {
            return 'Error: Rejection comments are required when rejecting a WRF.';
        }else{
            return 'You have recieved this screen in error';
        }
    }

    //Checks to see if someone should see the approve, reject, approval pending buttons on a submitted work request.
   public boolean getcanApproveRecords() {
        boolean canApprove = false;
        User currentUser = new User();
        id currentUserID = UserInfo.getUserId();
        currentUser = [Select u.Username, u.UserType, u.UserRoleId, u.UserRole.name, profileid, profile.name, WRApprover__c from User u where id = :currentUserID];
        canApprove = (currentUser.wrapprover__c);
        system.debug('Testing: WRF ID::::' + wrf.OutputType__c);      
        return canApprove;       
    }
    
    //When someone "rejects" a work request submission, here's what happens.
    public PageReference rejected() {
        
        WorkRequestForm__c updatedWRF = [select id, requeststatus__c, programmerassigned__c, ownerID from WorkRequestForm__c where id = :wrf.id];
        
        rejected = true; 
        
        updatedWRF.requeststatus__c='Rejected';
        updatedWRF.RejectionComments__c = wrf.RejectionComments__c;
        
        string wrID = wrf.PrimarySalesContact__c;
        
        if(wrID == '' || wrID == null) {
            updatedWRF.ownerid = UserInfo.getUserId();
        }
        
        else {
            
            updatedWRF.ownerid=wrf.PrimarySalesContact__c;   
        }
        
        System.debug('The rejection comments value is: x' + wrf.RejectionComments__c + 'x');
        if(wrf.RejectionComments__c == '')
        {           
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Rejection comments are required when rejecting a WRF.'));
            //wrf.addError('WRF Status - Rejection comments are required when rejecting a WRF.');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Rejection comments are required when rejecting a WRF.');
            ApexPages.addMessage(myMsg);
            
            
            System.debug('The rejection comments are blank ' + wrf.RejectionComments__c + 'x');
            
            //PageReference wrForm = Page.wrEdit;
            //wrForm.getParameters().put('ID',wrf.ID);
            //wrForm.setRedirect(True);
            //return wrForm;
            
        } else
        {               
            
            System.debug('The rejection comments are not blank ' + wrf.RejectionComments__c + 'x');
            
            updatedWRF.isSubmitted__c = false;
            updatedWRF.SubmittedDate__c = null;
            update updatedWRF;
            

            
        }

        System.debug('I got here.');

            PageReference wrForm = Page.WRFRedirect;
            wrForm.getParameters().put('id',wrf.ID);
            wrForm.setRedirect(True);
            return wrForm;
             

    }
    

    
    
    //When someone chooses assign pending, here's what happens.
    public PageReference assigned_pending() {
        
        WorkRequestForm__c updatedWRF = [select id, requeststatus__c, programmerassigned__c, ownerID from WorkRequestForm__c where id = :wrf.id];
                
        updatedWRF.requeststatus__c='Approval Pending';
        if (wrf.ProgrammerAssigned__c == NULL) {
            updatedWRF.OwnerId = UserInfo.getuserid();
        }
        
        else {
            
            updatedWRF.OwnerId = wrf.ProgrammerAssigned__c;
        }
        updatedWRF.ProgrammerAssigned__c = null;
        //updatedWRF.Rejection_Comments__c = 'N/A';
        update updatedWRF;
        
        PageReference wrForm = Page.WRFRedirect;
        wrForm.getParameters().put('ID',wrf.ID);
        wrForm.setRedirect(True);
        return wrForm;
    }
    
    //When someone approves a work request, here's what happens.
    public PageReference approved() {
        
        WorkRequestForm__c updatedWRF = [select id, requeststatus__c, programmerassigned__c, ownerID from WorkRequestForm__c where id = :wrf.id];
        
        updatedWRF.requeststatus__c='Approved';
        updatedWRF.ownerid=UserInfo.getuserid();
        updatedWRF.ApprovalDate__c=system.today();
        
        //Figure out who we should assign the job to
        if (wrf.ProgrammerAssigned__c == NULL) {
            wrf.OwnerId = UserInfo.getuserid();
        }
        
        else {
            
           wrf.OwnerId = wrf.ProgrammerAssigned__c;
        }
        
        updatedWRF.ProgrammerAssigned__c = null;
        //updatedWRF.Rejection_Comments__c = 'N/A';
        PLCJob__c newJob;
        
        newJob = new PLCJob__c();
        newJob.RequestedDate__c = wrf.RequestedDueDate__c;
        newJob.Opportunity__c = wrf.OpportunityName__c;
        newJob.JobName__c = wrf.Name;
        newJob.JobType__c = wrf.JobType__c;
        newJob.WorkRequestForm__c = wrf.ID;
        newJob.OwnerID = wrf.OwnerID;
        newJob.Cycle__c = wrf.Cycle__c;
        newJob.CycleStart__c = wrf.CycleStart__c;
        newJob.NumberofCycles__c = wrf.NumberofCycles__c;
        newJob.JobNumber__c = wrf.Internal__c ? wrf.JobNumber__c : null;
        
        //convert to datetime, then assign to submitted date
        Datetime dt = datetime.newInstance(wrf.SubmittedDate__c.year(), wrf.SubmittedDate__c.month(),wrf.SubmittedDate__c.day());
        newJob.SubmittedDate__c = dt;
    
        
        
        //Here we set the job number from the opportunity, with the old/new number format, EU/US org merge, etc. we have some checking to do!

        //if (wrf.JobNumber__c.StartsWith('I')) {
        //  
        //  string newJobNumber = wrf.JobNumber__c;
        //  newJob.Job_Number__c = newJobNumber;

        //}     

        //else if (wrf.Opportunity_Number__c<> null && wrf.Opportunity_Number__c.length() == 12) {
        //   string newJobNumber = wrf.Opportunity_Number__c;
        //     newJob.Job_Number__c = newJobNumber.substring(4,12);
        //}  
        //  
        //else if (wrf.Opportunity_Number__c<> null && wrf.Opportunity_Number__c.length() == 8) {
        //   string newJobNumber = wrf.Opportunity_Number__c;
        //     newJob.Job_Number__c = newJobNumber;
        //     newJob.Job_Number__c = wrf.Opportunity_Number__c;
        //}
        
        //else if (wrf.Opportunity_Number__c<> null && wrf.Opportunity_Number__c.StartsWith('NA')) {
        //  string newJobNumber = wrf.Opportunity_Number__c;
        //    newJob.Job_Number__c = newJobNumber.Replace('NA', '');
            
        //}
        
        //else if (wrf.Opportunity_Number__c<> null && wrf.Opportunity_Number__c.StartsWith('EU')) {
        //  
        //  string newJobNumber = wrf.Opportunity_Number__c;
        //    newJobNumber = newJobNumber.Replace('-','0');
        //  newJobNumber = newJobNumber.Replace('EU', '');           
        //   
        //}
        
        //If we have something crazy 
        //else newJob.Job_Number__c = 'Other';
            
     
        insert newJob;        
        update updatedWRF;
        
        PageReference jobPage = Page.PLCJobEdit;
        jobPage.getParameters().put('ID',newJob.ID);
        jobPage.setRedirect(True);
        return jobPage; 
    }

  
}