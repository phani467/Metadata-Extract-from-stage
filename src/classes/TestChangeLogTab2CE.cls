//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This class is used in POLK WRF.
    // @return: NA
    // @Last Modified Date and By - 04/13/2018- Anjani Shukla - SFDC1-7933 - Class Maintenance
    //----------------------------- 
@isTest(seeAllData=false)
private class TestChangeLogTab2CE {
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static testMethod void testReset() {
        
        WorkRequestForm__c newWrf = new WorkRequestForm__c();
        newWrf.FormType__c = 'TLAS';
        upsert newWrf;
        
        List<ChangeLog__c> clList = new List<ChangeLog__c>();

        ChangeLog__c c = new ChangeLog__c();
        c.ChangeDescription__c = 'Test';
        c.WorkRequestForm__c = newWrf.id;
        clList.add(c);
        upsert clList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        ChangeLogTab2CE myPageCon = new ChangeLogTab2CE(sc);
        myPageCon.wrf = newWrf;
        myPageCon.ChangelogList = clList;
        myPageCon.getChangelogs();
        myPageCon.delid = c.id;
        myPageCon.clid = c.id;

        //myPageCon.add();
        myPageCon.newSave();
        myPageCon.crApprove();
        myPageCon.crReject();
        myPageCon.Submit();
        myPageCon.crApprovePending();
        myPageCon.crApproveCreate();
        myPageCon.crDelete();

        newWRF.ChangeLogs__c = null;
        newWRF.ChangeLogsPLC__c = null;
        upsert newWRF;
        undelete c;     
        c.Programmer__c = UserInfo.getuserid();
        upsert c;
        myPageCon.newSave();
        myPageCon.crApprove();
        myPageCon.crReject();
        myPageCon.Submit();
        myPageCon.crApprovePending();
        myPageCon.crApproveCreate();
        myPageCon.DeleteAccount();

        //List<ChangeLog__c> clList = controller.getChangelogs();
        //system.debug('changeloglist = ' + controller.changeloglist);
        //controller.add();
        //system.debug('changeloglist = ' + controller.changeloglist);
        //controller.ChangelogList[0].Revised_Request_Date__c=System.Today();
        //controller.ChangelogList[0].Change_Documented_By__c=userinfo.getuserid();
        //controller.ChangelogList[0].Change_Description__c='This is a test';
        //controller.newsave();
        //List<ChangeLog__c> testlist = [select id from ChangeLog__c where WorkRequestForm__c=:controller.wrf.id];
        //system.assert(testlist.size()==1,'ERROR SAVING CHANGE LOG');
        //system.debug('changeloglist = ' + controller.changeloglist);
        //controller.delid=testlist[0].id;
        //controller.crdelete();
        //List<ChangeLog__c> testlist2 = [select id from ChangeLog__c where WorkRequestForm__c=:controller.wrf.id];
        //system.assert(testlist2.size()==0,'ERROR DELETING CHANGE LOG');
    //}
    
    }
}