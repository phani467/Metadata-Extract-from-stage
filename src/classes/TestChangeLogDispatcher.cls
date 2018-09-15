//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This class is used in POLK WRF.
    // @return: NA
    //----------------------------- 
@isTest
private class TestChangeLogDispatcher {
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static testMethod void testupsert() {
        
        WorkRequestForm__c newWrf = new WorkRequestForm__c();
        newWrf.FormType__c = 'TLAS';
        insert newWrf;
        
        List<ChangeLog__c> clList = new List<ChangeLog__c>();

        ChangeLog__c c = new ChangeLog__c();
        c.ChangeDescription__c = 'Test';
        c.WorkRequestForm__c = newWrf.id;
        clList.add(c);
        insert clList;
        
        for(ChangeLog__c cl : clList){
        cl.ChangeDescription__c='test update';
        }
      update clList;

   WorkRequestForm__c newWrf1 = new WorkRequestForm__c();
        newWrf.FormType__c = 'TLAS';
        insert newWrf1;
        
        for(ChangeLog__c cl : clList){
        cl.WorkRequestForm__c= newWrf1.ID;
        }
      update clList;
    
    }
    
    
}