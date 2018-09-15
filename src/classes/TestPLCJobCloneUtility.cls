//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This is a test class used in POLK WRF.
    // @return: NA
    //----------------------------- 
@isTest
private class TestPLCJobCloneUtility {
   //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static testMethod void testPLC() {
        PLCJob__c plc = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Week Days');
        
        insert plc;
        
        PLCJobCloneUtility controller = new PLCJobCloneUtility(new ApexPages.StandardController(plc));
        apexPages.currentPage().getParameters().put('id',plc.id);
        
        PLCJob__c plc1 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Weekly');
        system.assert(controller.newJobs.size()==10);
        insert plc1;
        
        PLCJobCloneUtility controller1 = new PLCJobCloneUtility(new ApexPages.StandardController(plc1));
        apexPages.currentPage().getParameters().put('id',plc1.id);
        
        PLCJob__c plc2 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Semi-Monthly');
        insert plc2;
        
        PLCJobCloneUtility controller2 = new PLCJobCloneUtility(new ApexPages.StandardController(plc2));
        apexPages.currentPage().getParameters().put('id',plc2.id);
        
        PLCJob__c plc3 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Monthly');
        insert plc3;
        
        PLCJobCloneUtility controller3 = new PLCJobCloneUtility(new ApexPages.StandardController(plc3));
        apexPages.currentPage().getParameters().put('id',plc3.id);
        
        PLCJob__c plc4 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Six Week Cycle');
        insert plc4;
        
        PLCJobCloneUtility controller4 = new PLCJobCloneUtility(new ApexPages.StandardController(plc4));
        apexPages.currentPage().getParameters().put('id',plc4.id);
        
        PLCJob__c plc5 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Quarterly');
        insert plc5;
        
        PLCJobCloneUtility controller5 = new PLCJobCloneUtility(new ApexPages.StandardController(plc5));
        apexPages.currentPage().getParameters().put('id',plc5.id);
        
        PLCJob__c plc6 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Semi-Annually');
        insert plc6;
        
        PLCJobCloneUtility controller6 = new PLCJobCloneUtility(new ApexPages.StandardController(plc6));
        apexPages.currentPage().getParameters().put('id',plc6.id);
        
        PLCJob__c plc7 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Annually');
        insert plc7;
        
        PLCJobCloneUtility controller7 = new PLCJobCloneUtility(new ApexPages.StandardController(plc7));
        apexPages.currentPage().getParameters().put('id',plc7.id);
        
        PLCJob__c plc8 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Other');
        insert plc8;
        
        PLCJobCloneUtility controller8 = new PLCJobCloneUtility(new ApexPages.StandardController(plc8));
        apexPages.currentPage().getParameters().put('id',plc8.id);
        
        controller.cancel();
        controller.create_jobs();
        
        
    }
}