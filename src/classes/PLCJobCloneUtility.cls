//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This class is used in POLK WRF.
    // @return: NA
    //----------------------------- 
public with sharing class PLCJobCloneUtility {
 
    public list<PLCJob__C> newJobs {get; set;}
    private final PLCJob__C masterPLC;
    private final PLCJob__C clonedPLC;
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: ApexPages.StandardController
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public PLCJobCloneUtility(ApexPages.StandardController controller) {

    masterPLC = (PLCJob__C) controller.getRecord();
    clonedPLC = [select id, ownerid, jobname__c, JobType__c, NumberofCycles__c, 
        cyclestart__c, cycle__c, opportunity__c, opportunityvalue__c, processtouse__c,
        totaljobestimate__c, othercostestimate__c, currencyisocode, peerreviewer__c, encryptionrequired__c,
        encryptionkey__c, ftprequired__c, ftpinformationinwrf__c, ftppath__c, ftpuserid__c, ftppassword__c
        from PLCJob__C where id = :masterPLC.ID];
        
    id cloneID = clonedPLC.ID;
    date nextDate = clonedPLC.cyclestart__c;
    string nextDateDOW;
    newJobs = new list<PLCJob__C>();
    
        for (integer i = 1; i <= masterPLC.NumberofCycles__c; i++) {

            PLCJob__C tempPLC = clonedPLC.clone(false);
    
            if (tempPLC.Cycle__c == 'Week Days' && i <> 1) {
                nextDate = nextDate.addDays(1);
            }
            
            else if (tempPLC.Cycle__c == 'Weekly' && i <> 1) {
                nextDate = nextDate.addDays(7);
            }
            
            else if (tempPLC.Cycle__c == 'Semi-Monthly' && i <> 1) {
                nextDate = nextDate.addDays(15);
            }
            
            else if (tempPLC.Cycle__c == 'Monthly' && i <> 1) {
                nextDate = nextDate.addMonths(1);
            }
            
            else if (tempPLC.Cycle__c == 'Six Week Cycle' && i <> 1) {
                nextDate = nextDate.addDays(42);
            }
            
            else if (tempPLC.Cycle__c == 'Quarterly' && i <> 1) {
                nextDate = nextDate.addMonths(3);
            }
            
            else if (tempPLC.Cycle__c == 'Semi-Annually' && i <> 1) {
                nextDate = nextDate.addMonths(6);
            }
            
            else if (tempPLC.Cycle__c == 'Annually' && i <> 1) {
                nextDate = nextDate.addYears(1);
            }
            
            else if (tempPLC.Cycle__c == 'Other'&& i <> 1 ) {
                nextDate = nextDate.addDays(0);
            }
            
            datetime nextDateTime = datetime.newInstance(nextDate.year(), nextDate.month(),nextDate.day());
            nextDateDOW = nextDateTime.format('EEEE');
            
            //Backdate if Saturday or Sunday
            
            if (nextDateDOW == 'Saturday') {
                nextDate = nextDate.addDays(-1);
            }
            
            if (nextDateDOW == 'Sunday') {
                nextDate = nextDate.addDays(-2);
            }
            
            tempPLC.cycleoccurance__c = i;
            tempPLC.StartDate__c = nextDate;
            tempPLC.NegotiatedDate__c = nextDate;
            tempPLC.RequestedDate__c = nextDate;
            tempPLC.OwnerID = tempPLC.OwnerID;
            tempPLC.WRFQuality__c = 'No Set-up Required';
            tempPLC.ParentJob__c = cloneID;
            
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
        
        PLCJob__C p = [Select id From PLCJob__C Where Id = :ApexPages.currentPage().getParameters().get('id')];
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
        
        PLCJob__C p = [Select id From PLCJob__C Where Id = :ApexPages.currentPage().getParameters().get('id')];
        PageReference backPage = Page.PLCJobEdit;
        backPage.getParameters().put('id',p.id);
        backPage.setRedirect(true);
        return backPage;     
            
    }
     
    
}