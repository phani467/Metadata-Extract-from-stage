// @author: Uttam Arya
// @date: 31 Aug 2017
// @param: NA
// @description: Test class for Task trigger methods 
// @return: NA
//-----------------------------

@isTest
private class TestTaskMethods {
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 31 Aug 2017
    // @param: NA
    // @description: SFDC1-2243 Test method for Task trigger methods populateTaskAddedInOpportunityWhenTaskIsInserted on insert
    // @return: NA
    // 
    // @Updated by: Harshit Singhal
    // @Updated date: 15 Jun 2018
    // @Updated description: Updated to cover code changes made for SFDC1-8540 in populateTaskAddedInOpportunityWhenTaskIsInserted() method
    //-----------------------------
    private static testMethod void testpopulateTaskAddedInOpportunityWhenTaskIsInserted() {
        
        Account acct = TestUtility.createTestAccount('Test populateAdditionalFiledsLookupInAccount', true);
        Opportunity oppt = TestUtility.createOpportunity(acct.Id, 'Test Oppy Task', true);
        
        Task t = new Task(Account__c = acct.Id, Subject = 'Test Task', WhatId = oppt.Id);
        
        insert t;
        
        //Assert if MIS is inserted
        Opportunity opp = [select MISActivityAdded__c,ActivityCreated__c from Opportunity where Id =: oppt.Id];
        
        System.assertNotEquals(opp.MISActivityAdded__c,null);
        System.assertEquals(true,opp.ActivityCreated__c);        
    }
    
    //-----------------------------
    // @author: Mohit Modi
    // @date: 17 Jan 2018
    // @param: NA
    // @description: SFDC1-5027 Test method for Task trigger methods updateOpportunityActivityCheckOnTaskDeletion on Delete
    // @return: NA
    //-----------------------------
    private static testMethod void testupdateOpportunityActivityCheckOnTaskDeletion() {
        
        Account acct = TestUtility.createTestAccount('Test populateAdditionalFiledsLookupInAccount', true);
        
        Opportunity oppt1 = TestUtility.createOpportunity(acct.Id, 'Test Oppy Task', false);
        oppt1.ActivityCreated__c = true;
        Opportunity oppt2 = TestUtility.createOpportunity(acct.Id, 'Test Oppy Task', false);
        oppt2.ActivityCreated__c = true;
        insert new list<opportunity> {oppt1,oppt2};
        
        test.startTest();
        
        Task t1 = new Task(Account__c = acct.Id, Subject = 'Test Task', WhatId = oppt1.Id);
        Task t2 = new Task(Account__c = acct.Id, Subject = 'Test Task', WhatId = oppt1.Id);
        Task t3 = new Task(Account__c = acct.Id, Subject = 'Test Task', WhatId = oppt2.Id);
        insert new List<Task>{t1,t2,t3};
        
        set<id> setOppID = new set<id>{oppt1.Id,oppt2.Id};
        
        List<Opportunity> opp = [select ActivityCreated__c from Opportunity where Id in : setOppID ];
        System.assertEquals(opp[0].ActivityCreated__c ,true);
        System.assertEquals(opp[1].ActivityCreated__c ,true);
        
        delete new list<task>{t1,t3};
        
        // Assert that the opportunity's ActivityCreated__c should be false if the last task is deleted, else it should be true.
        opp = [select ActivityCreated__c from Opportunity where Id in : setOppID ];
        System.assertEquals(opp[0].ActivityCreated__c ,true);
        System.assertEquals(opp[1].ActivityCreated__c ,false);
        
        test.stopTest();
    }
    
}