//----------------------------- 
// @Author : Legacy POLK 
// @date: 11 Oct 2017 
// @description: Migrated from Legacy POLK 
// @PROGRAMMER: Anjani Shukla 
//-----------------------------
@isTest
private class TestOrderReqTabCE {
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static testMethod void testOrderRequests() {
        
        WorkRequestForm__c newWrf = new WorkRequestForm__c();
        newWrf.FormType__c = 'TLAS';
        upsert newWrf;
        
        List<orderrequest__c> orList = new List<orderrequest__c>();

        OrderRequest__c o = new orderrequest__c();
        o.ProductionComments__c = 'Test';
        o.WorkRequestForm__c = newWrf.id;
        orList.add(o);
        upsert orList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        OrderReqTabCE myPageCon = new OrderReqTabCE(sc);
        myPageCon.wrf = newWrf;
        myPageCon.OrderRequestList = orList;
        myPageCon.getOrderRequests();
        myPageCon.delid = o.id;
        myPageCon.orid = o.id;
        
        myPageCon.newSave();
        myPageCon.crApprove();
        myPageCon.crReject();
        myPageCon.Submit();
        myPageCon.crApprovePending();
        myPageCon.crApproveCreate();
        myPageCon.crDelete();
        
        undelete o;
        o.Programmer__c = UserInfo.getuserid();
        upsert o;
        myPageCon.newSave();
        myPageCon.crApprove();
        myPageCon.crReject();
        myPageCon.Submit();
        myPageCon.crApprovePending();
        myPageCon.crApproveCreate();
        myPageCon.DeleteAccount();
        myPageCon.add();
        myPageCon.save();
   
        
        //OrderReqTabCE controller = new OrderReqTabCE();
        //controller.wrf = TestUtility.newWRF();
        
        //controller.wrfid = controller.wrf.Id;
        //controller.reset();
        //controller.add();
        //controller.OrderRequestList[0].Desired_Count__c=500;
        //controller.OrderRequestList[0].Cutback_Options__c='true';
        //controller.OrderRequestList[0].Custom_Description__c='test';
        //controller.save();
        //List<OrderRequest__c> testlist = [select id from OrderRequest__c where WorkRequestForm__c=:controller.wrf.id];
        //system.assert(testlist.size()==1,'ERROR SAVING orderRequests');
        //controller.delid=testlist[0].id;
        //controller.DeleteAccount();
        //List<OrderRequest__c> testlist2 = [select id from OrderRequest__c where WorkRequestForm__c=:controller.wrf.id];
        //system.assert(testlist2.size()==0,'ERROR DELETING orderRequests');        
        
        //controller.getOrderRequests();

   }
   //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
        public static testMethod void testOrderRequests2() {
        
        WorkRequestForm__c newWrf = new WorkRequestForm__c();
        newWrf.FormType__c = 'TLAS';
        upsert newWrf;
        
        List<orderrequest__c> orList = new List<orderrequest__c>();

        OrderRequest__c o = new orderrequest__c();
        o.ProductionComments__c = 'Test';
        o.WorkRequestForm__c = newWrf.id;
        orList.add(o);
        upsert orList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        OrderReqTabCE myPageCon = new OrderReqTabCE();

   
        

   }
    
}