//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: Test class for CaseTakeOwnershipCE
// @return: NA
//-----------------------------
@isTest
public class TestCaseTakeOwnershipCE {
    public static testMethod void testTakeOwnership() {
        Profile p = [select id from Profile where name = 'System Administrator'];
        User u = [SELECT Id FROM User WHERE ProfileId =:p.Id and Id != :UserInfo.getUserId() and isActive = true limit 1];
        
        // insert a Case
        Case myCase = new Case ();
        insert myCase;
        
        myCase = [select id, ownerid from Case where Id = :myCase.Id];
        System.assertNotEquals(myCase.OwnerId, u.Id); // verify the case is not already owned by our retrieved test user
        
        System.runAs(u){
            CaseTakeOwnershipCE controller = new CaseTakeOwnershipCE(new ApexPages.StandardController(myCase));
            controller.takeOwnership();   // change ownership to our test user
        }
        System.assertEquals(myCase.OwnerId, u.Id); // verify the case is now owned by our retrieved test user
    }
}