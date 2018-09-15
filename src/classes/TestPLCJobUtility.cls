//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This is a test class  used in POLK WRF.
    // @return: NA
    //----------------------------- 
@isTest
private class TestPLCJobUtility {
      //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static testMethod void testPLC() {  
        PLCJob__c plc = new PLCJob__c(JobName__c = 'Test', Team1__c = 'Test');
        insert plc;
        PLCJob__c plc2 = new PLCJob__c();
        insert plc2;
        
        PLCJobUtility controller = new PLCJobUtility(new ApexPages.StandardController(plc));
        apexPages.currentPage().getParameters().put('id',plc.id);
        
        controller.p = plc;
        controller.p.CreateSetupMeetingTask__c=true;
        controller.p.CreateDocumentationTask__c=true;
        controller.p.CreatePeerReviewTask__c=true;
        controller.save_and_edit();
        controller.edit();
        controller.createTasks();
        JobTask__c[] jtlist = [select id from JobTask__c where plcjob__c =:plc.id];
        system.assert(jtlist.size()>0);
        controller.Create_Cyclical_Jobs();
        controller.Create_Multipart_Jobs();
        
        controller.p = plc2;
        controller.save_and_edit(); 
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static testMethod void testValidPLC() {
        PLCJob__c plc = TestUtility.newCompletedPLC(TestUtility.newWRF(true));
        PLCJobUtility controller = new PLCJobUtility(new ApexPages.StandardController(plc));
        apexPages.currentPage().getParameters().put('id',plc.id);
        controller.p = plc;
        System.assertEquals(true, XedeUtility.validatePLC(plc));
        controller.save_and_edit();
        List<JobTask__c> openTasks = [SELECT Id FROM JobTask__c WHERE PLCJob__c=:plc.id AND Status__c <> 'Complete'];
        System.assertEquals(0, openTasks.size());
    }
       
}