//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This class is a test class used in POLK WRF.
    // @return: NA
    //----------------------------- 
@isTest
private class TestPLCJobCloneMultipartUtility {
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static testMethod void testPLC() {
        PLCJob__c plc = new PLCJob__c(NumberofParts__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Week Days');
        insert plc;
        
        PLCJobCloneMultipartUtility controller = new PLCJobCloneMultipartUtility(new ApexPages.StandardController(plc));
        apexPages.currentPage().getParameters().put('id',plc.id);
        system.debug('\n\n'+controller.newJobs.size());
        system.assert(controller.newJobs.size()==9);    //9 cloned jobs + master part =10 total 
        controller.create_jobs();
        controller.cancel();
    }
}