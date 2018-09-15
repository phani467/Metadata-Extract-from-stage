//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This is a test class is used in POLK WRF.
    // @return: NA
    //----------------------------- 
@isTest
private class TestPLCJobCloneCyclicalUtility {
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static testMethod void testPLC() {  
        PLCJob__c plc = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Week Days', CreatePeerReviewTask__c=true);
        insert plc;
        apexPages.currentPage().getParameters().put('id',plc.id);
        PLCJobCloneCyclicalUtility controller = new PLCJobCloneCyclicalUtility(new ApexPages.StandardController(plc));
        controller.Create_Jobs();
        system.assert(controller.newJobs.size()==9);
        controller.Cancel();
        
        PLCJob__c plc1 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Weekly');
        insert plc1;
        apexPages.currentPage().getParameters().put('id',plc1.id);
        PLCJobCloneCyclicalUtility controller1 = new PLCJobCloneCyclicalUtility(new ApexPages.StandardController(plc1));
        
        PLCJob__c plc2 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Semi-Monthly');
        insert plc2;
        apexPages.currentPage().getParameters().put('id',plc2.id);
        PLCJobCloneCyclicalUtility controller2 = new PLCJobCloneCyclicalUtility(new ApexPages.StandardController(plc2));
        
        PLCJob__c plc3 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Monthly');
        insert plc3;
        apexPages.currentPage().getParameters().put('id',plc3.id);
        PLCJobCloneCyclicalUtility controller3 = new PLCJobCloneCyclicalUtility(new ApexPages.StandardController(plc3));
        
        PLCJob__c plc4 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Six Week Cycle');
        insert plc4;
        apexPages.currentPage().getParameters().put('id',plc4.id);
        PLCJobCloneCyclicalUtility controller4 = new PLCJobCloneCyclicalUtility(new ApexPages.StandardController(plc4));
        
        PLCJob__c plc5 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Quarterly');
        insert plc5;
        apexPages.currentPage().getParameters().put('id',plc5.id);
        PLCJobCloneCyclicalUtility controller5 = new PLCJobCloneCyclicalUtility(new ApexPages.StandardController(plc5));
        
        PLCJob__c plc6 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Semi-Annually');
        insert plc6;
        apexPages.currentPage().getParameters().put('id',plc6.id);
        PLCJobCloneCyclicalUtility controller6 = new PLCJobCloneCyclicalUtility(new ApexPages.StandardController(plc6));
        
        PLCJob__c plc7 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Annually');
        insert plc7;
        apexPages.currentPage().getParameters().put('id',plc7.id);
        PLCJobCloneCyclicalUtility controller7 = new PLCJobCloneCyclicalUtility(new ApexPages.StandardController(plc7));
        
        PLCJob__c plc8 = new PLCJob__c(NumberofCycles__c = 10, CycleStart__c = date.newInstance(2000,1,1), Cycle__c = 'Other');
        insert plc8;
        apexPages.currentPage().getParameters().put('id',plc8.id);
        PLCJobCloneCyclicalUtility controller8 = new PLCJobCloneCyclicalUtility(new ApexPages.StandardController(plc8));
        
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    @isTest
    public static void testUpdateJobTaskTrigger() {
        PLCJob__c p = new PLCJob__c(
            StartDate__c = System.today(), 
            NegotiatedDate__c=System.today()
        );
        insert p;
        
        JobTask__c j = new JobTask__c(PLCJob__c=p.id, TaskName__c='Test');
        insert j;
        
        List<JobTask__c> badTasks;
        //change start date
        p.StartDate__c = System.today() + 7;
        update p;
        badTasks = [
            SELECT Id 
            FROM JobTask__c 
            WHERE PLCJob__c = :p.id
            AND   StartDate__c <> :p.StartDate__c
        ];
        System.assert(badTasks.size() == 0);
        
        //change negotiated/due dat
        p.NegotiatedDate__c = System.today() + 7;
        update p;
        badTasks = [
            SELECT Id 
            FROM JobTask__c 
            WHERE PLCJob__c = :p.id
            AND   DueDate__c <> :p.NegotiatedDate__c
        ];
        System.assert(badTasks.size() == 0);
        
        //change job status override
        p.JobStatusOverride__c = 'Job On Hold';
        update p;
        badTasks = [
            SELECT Id 
            FROM JobTask__c 
            WHERE PLCJob__c = :p.id
            AND   JobStatusOverride__c <> :p.JobStatusOverride__c
        ];
        System.assert(badTasks.size() == 0);
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    @isTest
    public static void testUpdateJobTaskTriggerBulk() { 
        //bulk test
        Integer batchSize=101;
        List<PLCJob__c> bulkPLCs = new List<PLCJob__c>();
        for(Integer i = 0; i < batchSize; i++) {
            bulkPLCs.add(new PLCJob__c(StartDate__c = System.today(), NegotiatedDate__c=System.today()));
        }
        insert bulkPLCs;
        
        //ensure that all the child deliverable tasks were created
        List<JobTask__c> allTasks = [
            SELECT Id
            FROM JobTask__c
            WHERE PLCJob__c IN :bulkPLCs
        ];
        System.assert(allTasks.size() == bulkPLCs.size());
        
        //update PLCs
        for(PLCJob__c p : bulkPLCs) {
            p.StartDate__c = System.today() + 7;
            p.NegotiatedDate__c = System.today() + 7;
            p.JobStatusOverride__c = 'Job On Hold';
        }
        update bulkPLCs;
        
        //ensure all the child tasks updated as well
        List<JobTask__c> badTasks = [
            SELECT Id, JobStatusOverride__c, StartDate__c, DueDate__c 
            FROM JobTask__c 
            WHERE PLCJob__c IN :bulkPLCs
            AND  (
                JobStatusOverride__c <> 'Job On Hold' OR
                StartDate__c <> :System.today() +7 OR
                DueDate__c <> :System.today() + 7
            )
        ];
        
        System.assert(badTasks.size() == 0);
    }
 
}