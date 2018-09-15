//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This class is used in POLK WRF.

    //----------------------------- 
public with sharing class PLCJobUtility {

    public PLCJob__C p {get; set;} 
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: String
    //----------------------------- 
    public String showMessage {

                get;
                set;

        }

    public ApexPages.StandardController con;
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: ApexPages.StandardController
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public PLCJobUtility(ApexPages.StandardController controller) {
        con  = controller;
        this.p = (PLCJob__C)Controller.getRecord();
        
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: PageReference 
    //----------------------------- 
    public PageReference save_and_edit() {
        
        showMessage = 'False';
        boolean valid = XedeUtility.ValidatePLC(p);
        
        if (valid) {
                //System.debug('In Valid:'+valid);
                //return con.save();
                
                if(p.JobCompletedDelivered__c)
                    closeTask();
                
                upsert p;
                //PageReference pageRef = ApexPages.currentPage();
                PageReference pageRef = Page.PLCJobView;
                pageRef.getParameters().put('id',con.getId());
                pageRef.setRedirect(true);
                return pageRef;
                
        }
                
        else {
                //System.debug('In Else:'+valid);
                //upsert p;
                PageReference pageRef = ApexPages.currentPage();
                return pageRef;

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
    private void closeTask() {
        List<JobTask__c> tasks = [
            SELECT Id, Status__c
            FROM JobTask__c
            WHERE Status__c <> 'Complete'
            AND PLCJob__c = :p.Id
        ];
        
        if(tasks.size() > 0) {
            tasks[0].Status__c='Complete';
            update tasks[0];
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
    public PageReference edit(){
        con.save();
        
        PLCJob__C p = [Select id From PLCJob__C Where Id = :ApexPages.currentPage().getParameters().get('id')];
        PageReference editPage = Page.PLCJobEdit;
        editPage.getParameters().put('id',p.id);
        editPage.setRedirect(true);
        return editPage; 
        
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: PageReference 
    //----------------------------- 
    public pageReference CreateTasks(){
        
        con.save();
        
        PLCJob__C p = [Select id, ownerid,CreateSetupMeetingTask__c, 
                        CreateDocumentationTask__c, CreatePeerReviewTask__c //,
                        From PLCJob__C 
                        Where Id = :ApexPages.currentPage().getParameters().get('id')];
        
        if (p.CreateSetupMeetingTask__c == true) {
        
        XedeUtility.CreatePLCTask(p, 'Setup Meeting');
        
        }
        
        if (p.CreateDocumentationTask__c == true) {
        
        XedeUtility.CreatePLCTask(p, 'Documentation');
        
        }
        
        if (p.CreatePeerReviewTask__c == true) {
        
        XedeUtility.CreatePLCTask(p, 'Peer Review');
        
        }
        
                p.CreateDocumentationTask__c = false;
                p.CreatePeerReviewTask__c = false;
                p.CreateSetupMeetingTask__c = false;
                upsert p;
                showMessage = 'True';
                PageReference pageRef = ApexPages.currentPage();
                return pageRef;

    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: PageReference 
    //----------------------------- 
    public PageReference Create_Cyclical_Jobs() {
        
        con.save();
        PLCJob__C p = [Select id From PLCJob__C Where Id = :ApexPages.currentPage().getParameters().get('id')];

        PageReference nextPage = Page.PLCJobCloneCyclical;
        nextPage.getParameters().put('id',p.id);
        nextPage.setRedirect(true);
        return nextPage;     
    } 
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: PageReference 
    //----------------------------- 
    public PageReference Create_Multipart_Jobs() {
        
        con.save();
        PLCJob__C p = [Select id From PLCJob__C Where Id = :ApexPages.currentPage().getParameters().get('id')];

        PageReference nextPage = Page.PLCJobCloneMultipart;
        nextPage.getParameters().put('id',p.id);
        nextPage.setRedirect(true);
        return nextPage;     
    } 

}