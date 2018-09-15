//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This class is used in POLK WRF.
    // @return: NA
    //----------------------------- 
@isTest 
private class TestNotificationEmailTrigger {
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    static testMethod void myUnitTest() {
       User currentUser = [Select u.Username, u.UserType, u.UserRoleId, u.UserRole.name, profileid, profile.name, WRApprover__c from User u where id = :UserInfo.getuserid()];
       PageReference pageRef = Page.WREdit;
       
       Test.setCurrentPage(pageRef);
       WorkRequestForm__c wrf = new WorkRequestForm__c(
          name='test',
          jobtype__c='Ad-Hoc',
          Formtype__c='TLAS',
          internal__c=true,
          OutputType__c='Excel',
          SubmittedDate__c=date.newInstance(System.Today().year(),System.Today().Month(),system.today().Day()-5)
          );
       insert wrf;
       ApexPages.StandardController wrfcon = new ApexPages.StandardController(wrf);
        WRACE controller = new WRACE(wrfcon);
        //JR 5/28/2015 Updated this user  to include the standard usertype (to avoid a chatter or community user from getting selected)
        controller.wrf.programmerassigned__c =[select id from user where usertype='Standard' and id != :userinfo.getuserid() and isactive = true limit 1].id;
        controller.wrf.Internal__c=true;
        controller.wrf.JobType__c='Ad-Hoc';
        controller.wrf.FormType__c='TLAS';
        controller.wrf.name='TEST';
        controller.SaveDraft();
        controller.submit();
        string wrfid = wrf.id;
        system.debug('\n\nID='+wrfid);
        WRApprovalController appCON = new WRApprovalController();
            //JR 5/28/2015 Update this SOQL to include additional fields needed to test the additional methods being added
        appCON.wrf=[select id,formtype__c,jobtype__c,internal__c,SubmittedDate__c,OutputType__c,RejectionComments__c,
                    PrimarySalesContact__c,programmerassigned__c, Name from WorkRequestForm__c where id=:wrfid LIMIT 1];
        system.debug(appCON.getPmsg());
            //JR 5/28/2015 ADDING tests for other methods in class
            //test for getcanapproverecords method.
            Boolean testcanApprove = appCON.getcanapproverecords();
            system.assertequals(currentUser.WRApprover__c,testcanApprove); //method should return same value as WRApprover
        WorkRequestForm__c checkapprove = [select id,requeststatus__c from WorkRequestForm__c where id=:appCON.wrf.id limit 1];
        //system.assert(checkapprove.requeststatus__c=='Approved');     
       
       //Test the Reject page button
        appCON.rejected();
        //Check to make sure the WRF was updated to rejected
        WorkRequestForm__c checkwrf = [select id,requeststatus__c from WorkRequestForm__c where id=:wrf.id limit 1];
        system.assertEquals('Rejected',checkwrf.requeststatus__c);

        //Test the Assigned Pending Button
        appCON.assigned_pending();
        WorkRequestForm__c checkwrf2 = [select id,requeststatus__c from WorkRequestForm__c where id=:wrf.id limit 1];
        system.assertEquals('Approval Pending',checkwrf2.requeststatus__c);

        //Test the Reject page button
        appCON.approved();
        //Check to make sure the WRF was updated to rejected
        WorkRequestForm__c checkwrf3 = [select id,requeststatus__c from WorkRequestForm__c where id=:wrf.id limit 1];
        system.assertEquals('Approved',checkwrf3.requeststatus__c);

        ChangeLogTab2CE controller2 = new ChangeLogTab2CE();
        controller2.wrf=[select id,formtype__c,jobtype__c,internal__c,Name from WorkRequestForm__c where id=:wrfid LIMIT 1];
        controller2.reset();
        system.debug('\n\n');
        system.debug('\n\n'+controller2.wrf);
        system.debug('\n\n');
        controller2.add();
        controller2.ChangelogList[0].RevisedRequestDate__c=System.Today();
        controller2.ChangelogList[0].ChangeDocumentedBy__c=userinfo.getuserid();
        controller2.ChangelogList[0].ChangeDescription__c='This is a test';
        //controller2.save();
        
    }

}