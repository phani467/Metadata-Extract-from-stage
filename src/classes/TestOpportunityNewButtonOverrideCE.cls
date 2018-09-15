//-----------------------------
// @author Prachi Bhasin
// @date 7 July 2017
// @description:  Test class for OpportunityNewButtonOverrideCE class
// @return: NA
//-----------------------------
@isTest
private class TestOpportunityNewButtonOverrideCE {
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 7 July 2017
    // @param: NA
    // @description: Test method for PageLoad method
    // @return: NA
    //-----------------------------
    private static testMethod void testPageLoad() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'testSetCaseAdditionalFieldsObject';
        c.AccountId = a.Id;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', firstName='test',HRManager__c='manager',LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123@ihs456789.com',ADID__c='test'+system.now().millisecond(),EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
        insert u;
        
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId=a.id;
        opp.RecordTypeId = devRecordTypeId;
        opp.CloseDate = System.today()+2;
        opp.Amount = 123;
        opp.GAM__c = u.id;       
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        OpportunityNewButtonOverrideCE oppCntrl = new OpportunityNewButtonOverrideCE(sc);
        
        PageReference pg = oppCntrl.PageLoadEvent();
        
        Id renewalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Opp';
        opp1.AccountId=a.id;
        opp1.RecordTypeId = renewalRecordTypeId;
        opp1.CloseDate = System.today()+2;
        opp1.Amount = 123;
        opp1.GAM__c = u.id;     
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(opp1);
        OpportunityNewButtonOverrideCE oppCntrl1 = new OpportunityNewButtonOverrideCE(sc1);
        
        PageReference pg1 = oppCntrl1.PageLoadEvent();
        
        Id placeholderRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Forecasting Placeholder').getRecordTypeId();
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test Opp';
        opp2.AccountId=a.id;
        opp2.RecordTypeId = placeholderRecordTypeId;
        opp2.CloseDate = System.today()+2;    
        
        ApexPages.StandardController sc2 = new ApexPages.StandardController(opp2);
        OpportunityNewButtonOverrideCE oppCntrl2 = new OpportunityNewButtonOverrideCE(sc2);
        
        PageReference pg2 = oppCntrl2.PageLoadEvent();
    }
}