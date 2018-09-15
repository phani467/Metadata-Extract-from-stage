/**
 * @author Paras Dhingra adapted from Tran's code
 * @date 08th Aug 2017
 * @description SFDC1-1081 Test class for unit testing on Lead Methods
 * @companyname IHS Markit
 **/
@isTest 
public class TestLeadMethods {
    static testMethod void TestUpdateCountryLookup() {
        // Test data setup
        TestUtility.loadCountryData();
        Lead testLead = TestUtility.createLead('Roger', 'Smith', 'Test Company', 'IN', false);
        testLead.CountryCode = 'IN';
        testLead.Email  = 'roger@test.ihsm.com';
        
        Test.startTest();
        insert testLead;

        //assert the lead
        Lead assertLead = [Select id, Country__r.CountryCode__c from Lead where id =: testLead.Id];
        System.assertEquals('IN', assertLead.Country__r.CountryCode__c);
        
        testLead.CountryCode = 'IT';
        update testLead;
        
        assertLead = [Select id, Country__r.CountryCode__c from Lead where id =: testLead.Id];
        System.assertEquals('IT', assertLead.Country__r.CountryCode__c);
        
        Test.stopTest();
    }
    
    static testMethod void testUpdateLeadDescriptionOnOpty() {
        // Test data setup
        Account acc = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        acc.DataGovernanceStatus__c = 'Approved';
        insert acc;
        
        Contact con = TestUtility.createContact(acc.id,'testemail1@test.com',false,'TestFirstName','TestLastName');
        con.Phone = '123423';
        con.Fax = '321412321';
        
        insert con;
            
        Test.startTest();
        Opportunity testOpportunity = TestUtility.createOpportunity(acc.Id, 'test Opppy', true);
        
        
        TestUtility.loadCountryData();
        Lead testLead = TestUtility.createLead('Roger', 'Smith', 'Test Company', 'IN', false);
        testLead.CountryCode = 'IN';
        testLead.Email  = 'roger@test.ihsm.com';
        testLead.Description ='test';
        testLead.BudgetRange__c = '< 25,000';
        insert testLead;
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(testLead.id);
        lc.setAccountId(acc.id);
        lc.setContactId(con.id);
        lc.setConvertedStatus('Converted');
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        System.assertnotEquals(lcr.opportunityid,null);
        System.assertEquals([select description from opportunity where id =: lcr.opportunityid ].description,testLead.Description);
        System.assertEquals([select CloseDateOriginal__c from opportunity where id =: lcr.opportunityid ].CloseDateOriginal__c,System.today() + 14);
        
        
       
        Test.stopTest();
    }
    
       
    
    
    
    
    //SFDC1-5436 - Move all Lead Process Builder to Trigger
    static testMethod void testupdatetoNewLeadSourcefieldPB() {
    	// Test data setup
        Account acc = TestUtility.createTestAccount('Account testCloseSourceCaseOnLead', false);
        acc.DataGovernanceStatus__c = 'Approved';
        insert acc;
        
        Contact con = TestUtility.createContact(acc.id,'testinglead@ihsmarkit.com',false,'TestFirstLeadName','TestLastLeadName');
        con.Phone = '123423';
        con.Fax = '321412321';
        
        insert con;
            
        Test.startTest();
        Opportunity testOpportunity = TestUtility.createOpportunity(acc.Id, 'test LeadOpppy', true);
        
        ProductGroup__c pg = new ProductGroup__c();
        pg.Name = 'NRG';
        insert pg;
        
        String ProfileName = 'IHSMarkit Sales: General';
        Profile p = [SELECT Name FROM Profile WHERE Name LIKE '%General%'];
        
        User testSalesUser = new User(Alias = 'standt', Email='testSalesGeneral-999@ihsmarkit.com', 
                                  EmailEncodingKey='UTF-8', firstName='testFirstName', HRManager__c='testManager', LastName='testLastName',
                                  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,
                                  TimeZoneSidKey='America/Los_Angeles', UserName='testSalesGeneral-999@ihsmarkit.com', ADID__c='test'+system.now().millisecond(),								EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)) );
         
         insert testSalesUser;
        
        TestUtility.loadCountryData();
        Lead testLead;
        system.runAs(testSalesUser) {
            testLead = TestUtility.createLead('Roger', 'Smith', 'Testing Company', 'IN', false);
            testLead.CountryCode = 'IN';
            testLead.Email  = 'rogerleadtest@ihsmarkit.com';
            testLead.Description ='test';
            testLead.BudgetRange__c = '< 25,000';
            testLead.LeadSource = 'Rep Generated';
            insert testLead;
        }       
        system.assertEquals([select leadsource from lead where id=: testLead.id ].leadsource,'Rep Generated');
        test.stopTest();
     } 
    
    //SFDC1-5436 - Move all Lead Process Builder to Trigger
    static testMethod void testupdatetoNewLeadSourcefieldMarketPB() {
    	// Test data setup
        Account acc = TestUtility.createTestAccount('Account testCloseSourceCaseOnLead', false);
        acc.DataGovernanceStatus__c = 'Approved';
        insert acc;
        
        Contact con = TestUtility.createContact(acc.id,'testinglead@ihsmarkit.com',false,'TestFirstLeadName','TestLastLeadName');
        con.Phone = '123423';
        con.Fax = '321412321';
        
        insert con;
        
        Profile pMarket = [SELECT Id,Name FROM Profile WHERE Name LIKE '%Marketing%' limit 1];
        User testSalesUser = new User(Alias = 'standt', Email='testMarketing-999@ihsmarkit.com', 
                                  EmailEncodingKey='UTF-8', firstName='testFirstName', HRManager__c='testManager', LastName='testLastName',
                                  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = pMarket.Id,
                                  TimeZoneSidKey='America/Los_Angeles', UserName='testMarketing-999@ihsmarkit.com', ADID__c='test'+system.now().millisecond(),                                  EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
         
         insert testSalesUser;
        
        Test.startTest();
        Opportunity testOpportunity = TestUtility.createOpportunity(acc.Id, 'test LeadOpppy', true);
        
        ProductGroup__c pg = new ProductGroup__c();
        pg.Name = 'NRG';
        insert pg;
                
        TestUtility.loadCountryData();
        Lead testLead;
        system.runAs(testSalesUser) {
            testLead = TestUtility.createLead('Roger', 'Smith', 'Testing Company', 'IN', false);
            testLead.CountryCode = 'IN';
            testLead.Email  = 'rogerleadtest@ihsmarkit.com';
            testLead.Description ='test';
            testLead.BudgetRange__c = '< 25,000';
            testLead.LeadSource = 'Marketing Generated';
            insert testLead;
        }       
        system.assertEquals([select leadsource from lead where id=: testLead.id ].leadsource,'Marketing Generated');
        test.stopTest();
     } 
    
    //SFDC1-5436 - Move all Lead Process Builder to Trigger
    static testMethod void testupdatetoNewLeadSourcefieldCCPB() {
    	// Test data setup
        Account acc = TestUtility.createTestAccount('Account testCloseSourceCaseOnLead', false);
        acc.DataGovernanceStatus__c = 'Approved';
        insert acc;
        
        Contact con = TestUtility.createContact(acc.id,'testinglead@ihsmarkit.com',false,'TestFirstLeadName','TestLastLeadName');
        con.Phone = '123423';
        con.Fax = '321412321';
        
        insert con;
            
        Test.startTest();
        Opportunity testOpportunity = TestUtility.createOpportunity(acc.Id, 'test LeadOpppy', true);
        
        ProductGroup__c pg = new ProductGroup__c();
        pg.Name = 'NRG';
        insert pg;
        
        //User testSalesGeneralUser = TestUtility.createTestUser('IHSMarkit Sales: General', 'testUser.SalesGeneral@ihsmarkit.com.user',true);
        //User testUser1 = TestUtility.createTestUser('IHSMarkit Sales: General', 'testUSer.testuser123@ihsmarkit.com.user',true);
        String ProfileName = 'IHSMarkit Sales: General';
        Profile p = [SELECT Name FROM Profile WHERE Name LIKE '%Customer Care%' limit 1];
        
        User testSalesUser = new User(Alias = 'standt', Email='testCustomerCare-999@ihsmarkit.com', 
                                  EmailEncodingKey='UTF-8', firstName='testFirstName', HRManager__c='testManager', LastName='testLastName',
                                  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,
                                  TimeZoneSidKey='America/Los_Angeles', UserName='testCustomerCare-999@ihsmarkit.com', ADID__c='test'+system.now().millisecond(),                                  EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
         
         insert testSalesUser;
        
        TestUtility.loadCountryData();
        Lead testLead;
        system.runAs(testSalesUser) {
            testLead = TestUtility.createLead('Roger', 'Smith', 'Testing Company', 'IN', false);
            testLead.CountryCode = 'IN';
            testLead.Email  = 'rogerleadtest@ihsmarkit.com';
            testLead.Description ='test';
            testLead.BudgetRange__c = '< 25,000';
            testLead.LeadSource = 'Customer Care';
            insert testLead;
        }       
        system.assertEquals([select leadsource from lead where id=: testLead.id ].leadsource,'Customer Care');
        test.stopTest();
     } 
    
     //SFDC1-8326 - On lead Conversion, associated campaign should created Campaign INfluence records with same count.
     static testMethod void testCampaignInflCreationOnLeadConvert() {
     	// Test data setup
        Account acc = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        acc.DataGovernanceStatus__c = 'Approved';
        insert acc;
        
        Contact con = TestUtility.createContact(acc.id,'testemail1@test.com',false,'TestFirstName','TestLastName');
        con.Phone = '123423';
        con.Fax = '321412321';
        
        insert con;
            
        Test.startTest();
        Opportunity testOpportunity = TestUtility.createOpportunity(acc.Id, 'test Opppy', true);
        
         List<Campaign> insertCampaign = New List<Campaign>();
        
        TestUtility.loadCountryData();
        Lead testLead = TestUtility.createLead('Roger', 'Smith', 'Test Company', 'IN', false);
        testLead.CountryCode = 'IN';
        testLead.Email  = 'roger@test.ihsm.com';
        testLead.Description ='test';
        testLead.BudgetRange__c = '< 25,000';
        insert testLead; 
         
         
        Id campaignRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Marketing Campaign').getRecordTypeId();
        Campaign Camp1 = new Campaign(Name='Test 1',recordTypeId=campaignRecordTypeId);
        //camp1.
        insertCampaign.add(Camp1); 
        
        Campaign Camp2 = new Campaign(Name='Test 2',recordTypeId=campaignRecordTypeId);
        insertCampaign.add(Camp2); 
         
         insert insertCampaign;  
        
         List<CampaignMember> campMemberLst = new List<CampaignMember>();
         CampaignMember campMembr1 = new CampaignMember();
         campMembr1.CampaignId = insertCampaign[0].id;
         campMembr1.LeadId = testLead.id;
         campMembr1.Status = 'Sent';
         campMembr1.CurrencyIsoCode = 'USD';
         campMemberLst.add(campMembr1);
         CampaignMember campMembr2 = new CampaignMember();
         campMembr2.CampaignId = insertCampaign[1].id;
         campMembr2.LeadId = testLead.id;
         campMembr2.Status = 'Sent';
         campMembr2.CurrencyIsoCode = 'USD';
         campMemberLst.add(campMembr2);
         
         insert campMemberLst; 
         
       
         
         
        
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(testLead.id);
        lc.setAccountId(acc.id);
        lc.setContactId(con.id);
        //lc.setOpportunityId(testOpportunity.id);
        lc.setConvertedStatus('Converted');
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
     }    
     
}