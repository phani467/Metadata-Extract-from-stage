/******
 * @author Uttam Arya
 * @date 24th May 2017
 * @description This is a test class for trigger framework related classes. 
 *******/

@isTest
public with sharing class TestTriggerFramework { 
    
    public static testMethod void testAccountTrigger() {
        
        Account acct = TestUtility.createTestAccount('testacct1', true);
        
        //Insert successful
        System.assert(acct.Id != null);

        Account acct1 = [SELECT Id, Name FROM Account WHERE Name = 'testacct1'];
        acct1.Name = 'testacct2';
        update acct1;
        
        Account acct2 = [SELECT Id, Name FROM Account WHERE Name = 'testacct2'];
        
        //Update successful 
        System.assertEquals(acct.Id, acct2.Id);
        
        delete acct1;
        
        list <Account> acctList = [SELECT Id, Name FROM Account WHERE Name = 'testacct2'];
        
        //Delete successful 
        System.assert(acctList.isEmpty()); 
    }
}