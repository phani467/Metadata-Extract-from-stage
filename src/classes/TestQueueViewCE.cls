//----------------------------- 
// @Author : Legacy POLK 
// @date: 11 Oct 2017 
// @description: Migrated from Legacy POLK 
// @PROGRAMMER: Anjani Shukla 
//-----------------------------
@isTest(SeeAllData=true)
private class TestQueueViewCE {
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    static testMethod void myUnitTest() {
        Queue__c q = new queue__c();
        q.Queues__c = 'Market Reporting - Analytics';       
        ApexPages.StandardController sc = new ApexPages.StandardController(q);
        QueueViewCE myPageCon = new QueueViewCE(sc);  
        workrequestform__c w = new workrequestform__c();
        w.FormType__c = 'Analytics';
        upsert w;
        myPageCon.updateView();
        myPageCon.getWRFRecords();
        myPageCon.getCLRecords();
        myPageCon.getORRecords();
        
        
        
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
      static testMethod void myUnitTest2() {
        Queue__c q = new queue__c();
        q.Queues__c = null;       
        ApexPages.StandardController sc = new ApexPages.StandardController(q);
        QueueViewCE myPageCon = new QueueViewCE(sc);  
        workrequestform__c w = new workrequestform__c();
        w.FormType__c = 'Analytics';
        upsert w;
        myPageCon.updateView();
        myPageCon.getWRFRecords();
        myPageCon.getCLRecords();
        myPageCon.getORRecords();
        
        
        
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
         static testMethod void myUnitTest3() {
        Queue__c q = new queue__c();
        q.Queues__c = 'All';       
        ApexPages.StandardController sc = new ApexPages.StandardController(q);
        QueueViewCE myPageCon = new QueueViewCE(sc);  
        workrequestform__c w = new workrequestform__c();
        w.FormType__c = 'Analytics';
        upsert w;
        myPageCon.updateView();
        myPageCon.getWRFRecords();
        myPageCon.getCLRecords();
        myPageCon.getORRecords();
        
        
        
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    static testMethod void myUnitTest4() {
        Queue__c q = new queue__c();
        q.Queues__c = '';       
        ApexPages.StandardController sc = new ApexPages.StandardController(q);
        QueueViewCE myPageCon = new QueueViewCE(sc);  
        workrequestform__c w = new workrequestform__c();
        w.FormType__c = 'Analytics';
        upsert w;
        myPageCon.updateView();
        myPageCon.getWRFRecords();
        myPageCon.getCLRecords();
        myPageCon.getORRecords();
        
        
        
    }

}