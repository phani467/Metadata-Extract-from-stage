//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: SFDC1-817 Controller class for CaseTakeOwnershipAction - Enables user to take ownership of case from Quick Action button
// @return: NA
//-----------------------------
public with sharing class CaseTakeOwnershipCE {
    private Case caseRec;
    ApexPages.StandardController sc;

    public CaseTakeOwnershipCE(ApexPages.StandardController controller) {
        sc = controller;
        caseRec = (Case)controller.getRecord();
    }

    public void takeOwnership() {
        caseRec.OwnerId = System.Userinfo.getUserId();
        try{
          sc.save();
        }catch(Exception e) {
            // note as standard controller the error is automatically added to pageMessages and displayed in component
        }
    }   
}