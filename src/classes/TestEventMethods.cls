// @author: Uttam Arya
// @date: 31 Aug 2017
// @param: NA
// @description: Test class for Event trigger methods 
// @return: NA
//-----------------------------

@isTest
private class TestEventMethods {
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 31 Aug 2017
    // @param: NA
    // @description: SFDC1-2243 Test method for Event trigger methods populateEventAddedInOpportunityWhenEventIsInserted on insert
    // @return: NA
    //-----------------------------
    private static testMethod void testpopulateEventAddedInOpportunityWhenEventIsInserted() {
        
        Account acct = TestUtility.createTestAccount('Test populateAdditionalFiledsLookupInAccount', true);
        Opportunity oppt = TestUtility.createOpportunity(acct.Id, 'Test Oppy Event', true);
        
        Event e = new Event(Account__c = acct.Id, Subject = 'Test Event', DurationInMinutes = 60, ActivityDateTime = Datetime.now(), WhatId = oppt.Id);
        
        insert e;
        
        //Assert if MIS is inserted
        Opportunity opp = [select MISActivityAdded__c from Opportunity where Id =: oppt.Id];
        
        System.assertNotEquals(opp.MISActivityAdded__c,null);
        
    }
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 18 Jun 2018
    // @param: NA
    // @description: SFDC1-8541 Test method for Event trigger method setActivityTypeFromType() on insert and update
    // @return: NA
    //-----------------------------
    private static testMethod void testSetActivityTypeFromType() {        
        
        //Insert Event        
        Event e = new Event(Subject = 'Test Event 123', DurationInMinutes = 60, ActivityDateTime = Datetime.now(), Type='Test Type 1');
        insert e;
        System.assertEquals('Test Type 1', [Select Id,ActivityType__c From Event Where Id=:e.Id].ActivityType__c);
        
        //Update Event
        e.Type = 'Test Type 2';
        update e;
        System.assertEquals('Test Type 2', [Select Id,ActivityType__c From Event Where Id=:e.Id].ActivityType__c);
    }    
}