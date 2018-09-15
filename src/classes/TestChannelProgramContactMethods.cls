//-----------------------------
// @author: Mohit Modi
// @date: 18 June 2018
// @param: NA
// @description: Test Class for methods related to Channel Program Contact 
//----------------------------------

@isTest
private class TestChannelProgramContactMethods {
    
    private static testMethod void testChannelProgramContactGeneralAutomation() {
        
        list<User> listUser = new list<user>();
        listUser.add(TestUtility.createAdminUser('testeamil1@ihsmarkit.com',false));
        listUser.add(TestUtility.createAdminUser('testeamil2@ihsmarkit.com',false));
        
        insert listUser;
        
        Test.startTest();
        
            ChannelProgramContact__c Cobj = new ChannelProgramContact__c();
            Cobj.SalesforceUser__c = listUser[0].id;
            insert Cobj;
            system.assertequals([select id, FullPhotoUrl,MediumPhotoUrl, SmallPhotoUrl from user where id =: listUser[0].id][0].FullPhotoUrl,[select id, SystemFullPhotoURL__c from ChannelProgramContact__c where id =: Cobj.id][0].SystemFullPhotoURL__c );
            
            Cobj.SalesforceUser__c = listUser[1].id;
            update Cobj;
            system.assertequals([select id, FullPhotoUrl,MediumPhotoUrl, SmallPhotoUrl from user where id =: listUser[1].id][0].FullPhotoUrl,[select id, SystemFullPhotoURL__c from ChannelProgramContact__c where id =: Cobj.id][0].SystemFullPhotoURL__c );
        
        Test.stopTest();
    
    }           
    
}