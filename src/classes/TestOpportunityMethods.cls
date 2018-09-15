//-----------------------------
// @author: Prachi Bhasin
// @date: 4 July 2017
// @param: NA
// @description: Test class for Opportunity trigger methods 
// @return: NA
// @Last Modified By : Vinod Merwade
// @Last Modified Description : Corrected the Test class according to new validation rules on Opportunity
// @Last Modified Date : 19 Sept 2017
// @Last Modified By : Hemant Shukla
// @Last Modified Description : Removed the dependency of ContractExists__c field based on SFDC1-5701
// @Last Modified Date : 6-Nov-2017
// @Last Modified By : Hemant Shukla
// @Last Modified Description : SFDC1-5857 : Removing an method testCheckEndUserCertificateAttachment() as the method is being removed from class. 
// @Last Modified Date : 21-Nov-2017
// @Last Modified By : Sonam Raju
// @Last Modified Description : SFDC1-6245 : Test method for Opportunity trigger method checkChannelManagerRoleonOpptyTeamforStage2andhigher on update
// @Last Modified Date : 3-Jan-2018
// @Last Modified By : Paras Dhingra
// @Last Modified Description : SFDC1-4723 : Test Method for OpportunityMethod.updateOpportunitySplitOnGamChange
// @Last Modified Date : 4-Jan-2018
// @Last Modified By: Sruti Srivastava
// @Last Modified Date: 9th April 2018
// @Last Modified Description: SFDC1-7027- Test method for updateContractStartDateAndEndDateOnOpportunityLineItem 
// @Last Modified By : Anjani Shukla
// @Last Modified Description : SFDC1-7667 : Test Method for OpportunityMethod.updateOpportunityRiskRecordStatus
// @Last Modified Date : 09-Apr-2018
// @Last Modified By : Jagadesh Kumar
// @Last Modified Description : SFDC1-5228 : Test Method for OpportunityMethod.setContactRolePrimary
// @Last Modified Date : 31 July 2018
//-----------------------------

@isTest
private class TestOpportunityMethods {
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 3 July 2017
    // @param: NA
    // @description: Test method for Opportunity trigger methods updateGAMOnOpportunityTeam on insert
    // @return: NA
    //-----------------------------
    private static testMethod void testUpdateGAMOnOpportunityTeamonInsert() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        a.DataGovernanceStatus__c = 'Approved';
        insert a;
        
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
        opp.StageName= '1-Sales Qualified';
        opp.RecordTypeId = devRecordTypeId;
        opp.CloseDate = System.today()+2;
        opp.Amount = 123;
        opp.GAM__c = u.id;
        opp.AccountId = a.id;
        insert opp;       
        
        System.assertEquals(opp.GAM__c, u.id);
        
        OpportunityTeamMember otm = new OpportunityTeamMember(); 
        otm =[Select id, name, userId from OpportunityTeamMember where OpportunityId=:opp.id and TeamMemberRole = 'Account Owner' limit 1];       
        System.assertEquals(opp.GAM__c, otm.userId);
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 3 July 2017
    // @param: NA
    // @description: Test method for Opportunity trigger methods updateGAMOnOpportunityTeam on update
    // @return: NA
    //-----------------------------
    private static testMethod void testUpdateGAMOnOpportunityTeamOnUpdate1() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        a.DataGovernanceStatus__c = 'Approved';
        insert a;
        
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
        opp.StageName= '1-Sales Qualified';
        opp.RecordTypeId = devRecordTypeId;
        opp.CloseDate = System.today()+2;
        opp.Amount = 123;
        opp.AccountId = a.id;
        insert opp;       
        
        opp.GAM__c = u.id;
        update opp;
        System.assertEquals(opp.GAM__c, u.id); 
        
        OpportunityTeamMember otm = new OpportunityTeamMember(); 
        otm =[Select id, name, userId from OpportunityTeamMember where OpportunityId=:opp.id and TeamMemberRole = 'Account Owner' limit 1];
        System.assertEquals(opp.GAM__c, otm.userId );      
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 3 July 2017
    // @param: NA
    // @description: Test method for Opportunity trigger methods updateGAMOnOpportunityTeam on update
    // @return: NA
    //-----------------------------
    private static testMethod void testUpdateGAMOnOpportunityTeamOnUpdate2() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        a.DataGovernanceStatus__c = 'Approved';
        insert a;
        
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
        
        User u1 = new User(Alias = 'standt1', Email='standarduser123@testorg.com', 
            EmailEncodingKey='UTF-8', firstName='test',HRManager__c='manager123',LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123123@ihs456789.com',ADID__c='test123'+system.now().millisecond(),EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
        insert u1;
        
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.StageName= '1-Sales Qualified';
        opp.RecordTypeId = devRecordTypeId;
        opp.CloseDate = System.today()+2;
        opp.Amount = 123;
        opp.GAM__c = u.id;
        opp.AccountId = a.id;
        insert opp;
        System.assertEquals(opp.GAM__c, u.id); 
        
        OpportunityTeamMember otm = new OpportunityTeamMember(); 
        otm =[Select id, name, userId from OpportunityTeamMember where OpportunityId=:opp.id and TeamMemberRole = 'Account Owner' limit 1];
        System.assertEquals(opp.GAM__c, otm.userId ); 
        
        opp.GAM__c = u1.id;  
        update opp; 
        
        OpportunityTeamMember otm1 = new OpportunityTeamMember(); 
        otm1 =[Select id, name, userId from OpportunityTeamMember where OpportunityId=:opp.id and TeamMemberRole = 'Account Owner' limit 1];
        System.assertEquals(opp.GAM__c, otm1.userId );  
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 3 July 2017
    // @param: NA
    // @description: Test method for Opportunity trigger methods updateGAMOnOpportunityTeam on update
    // @return: NA
    //-----------------------------
    private static testMethod void testCheckPrimaryContactOnNewBusinessOpportunityForSysAdmin() {
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        a.DataGovernanceStatus__c = 'Approved';
        insert a;
        
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
        opp.AccountId = a.Id;
        opp.Name = 'Test Opp';
        opp.StageName= '2-Sales Qualified';
        opp.RecordTypeId = devRecordTypeId;
        opp.CloseDate = System.today()+2;
        opp.Amount = 123;
        try{
            insert opp; 
        }
        catch(Exception e){
        }
        System.assertEquals(opp.Id,null);
        opp.StageName= '6L-Closed Lost';
        opp.LossReason__c = 'Price';
        opp.LostReasonCode__c='Unfavorable Pricing';
        opp.LostReasonDescription__c='Unfavorable Pricing';
        insert opp;
        System.assert(opp.Id!=null);
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 3 July 2017
    // @param: NA
    // @description: Test method for Opportunity trigger methods updateGAMOnOpportunityTeam on update
    // @return: NA
    // @update author : Mohit Modi
    // @Description : update the Test Class for updated logic
    //-----------------------------
    private static testMethod void testCheckPrimaryContactOnNewBusinessOpportunityForStandardUser() {
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        a.DataGovernanceStatus__c = 'Approved';
        insert a;
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'testSetCaseAdditionalFieldsObject';
        c.AccountId = a.Id;
        c.Phone = '12345';
        c.EmailUnknown__c = true;
            
        // Mohit : 13 Nov 2017 : Moved Query to Like Query as it is failing with Name of the Profile.   
        Profile p = [SELECT Id ,name FROM Profile WHERE Name like '%Global Account Manager%' limit 1];
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', firstName='test',HRManager__c='manager',LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123@ihs456789.com',ADID__c='test'+system.now().millisecond(),EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
        insert u;
        
        System.runAs(u) {
            Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
            Opportunity opp = new Opportunity();
            opp.AccountId = a.Id;
            opp.Name = 'Test Opp';
            opp.StageName= '1-Sales Qualified';
            opp.RecordTypeId = devRecordTypeId;
            opp.CloseDate = System.today()+2;
            opp.Amount = 123;
            opp.BudgetRange__c='25,000-50,000';
            insert opp;
            
            Test.Starttest();
            try {
                opp.StageName= '2-Need Confirmed';
                update opp;
            }catch(Exception e) {
                Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.OpportunityPrimaryContactValidationError) ? true : false;
                // Assert to check correct Error is thrown
                System.AssertEquals(expectedExceptionThrown, true);
            }
            
            //Inserting Contact and opportunity contact Role
            insert c;
            
            OpportunityContactRole oppContactRole = new OpportunityContactRole();
            oppContactRole.OpportunityID = opp.id;
            oppContactRole.ContactId = c.id;
            oppContactRole.IsPrimary = true;
            insert oppContactRole;
            
            try{
                opp.StageName= '2-Need Confirmed';
                update opp;
            }catch(Exception e) {
                Boolean expectedExceptionThrown =  e.getMessage().contains('Primary Contact needs an email address') ? true : false;
                // Assert to check correct Error is thrown
                System.AssertEquals(expectedExceptionThrown, true);
            }
            
            opp.StageName= '6L-Closed Lost';
            opp.LossReason__c = 'Price';
            opp.LostReasonCode__c='Unfavorable Pricing';
            opp.LostReasonDescription__c='Unfavorable Pricing';
            update opp;
            // Assert to check the Stage Name Should be updated
            System.assertEquals('6L-Closed Lost', [select id,StageName from Opportunity where id = :opp.id].StageName);
            Test.Stoptest();
        }
           
    }
    
     /**
     * @author Paras Dhingra
     * @date 31st July 2017
     * @description SFDC1-382 test class for OpportunityMethods.ChangeAccountOwnershipOnInsertUpdate
     * @param NA
     * @return void
     * @companyname IHS Markit
     */
     
     static testMethod void testChangeAccountOwnershipOnInsertUpdate() {
         //create test data
         Account testAccount = TestUtility.createTestAccount('testAccount', false);
         testAccount.DataGovernanceStatus__c = 'Approved';
         insert testAccount;
         
         User testUser1 = TestUtility.createTestUser('IHSMarkit Sales: General', 'testUSer.testuser123@ihsmarkit.com.user',true);
         User testUser2 = TestUtility.createTestUser('IHSMarkit Sales: General', 'testUser.test22343@ihsmarkit.com.usertest',true);
         
         //Now start test
         System.runAs(testUser1) {
             
             //create an Opportunity
             Opportunity testOpportunity1 = TestUtility.createOpportunity(testAccount.Id,'first test Oppy', false);
             testOpportunity1.Amount = 1000;
             insert testOpportunity1;
             // assert Account owner
             Account assertAccount1 = [Select id, OwnerId from Account where Id=:testAccount.Id];
             System.assertEquals(testUser1.Id, assertAccount1.OwnerId, 'Comparing Owner Id for Account and Opportunity');
         }
         System.runAs(testUser2) {
             //create an Opportunity
             Opportunity testOpportunity2 = TestUtility.createOpportunity(testAccount.Id,'first test Oppy', false);
             //Open opportunity of greater amount
             testOpportunity2.Amount = 100000;
             insert testOpportunity2;
             // assert Account owner
             Account assertAccount1 = [Select id, OwnerId from Account where Id=:testAccount.Id];
             System.assertEquals(testUser2.Id, assertAccount1.OwnerId, 'Comparing Owner Id for Account and Opportunity');
         }
     }
     
     /**
     * @author Paras Dhingra
     * @date 3rd Aug 2017
     * @description SFDC1-775 test class for OpportunityMethods.updateAccountRelationship
     * @param NA
     * @return void
     * @companyname IHS Markit
     * @lastmodifiedSprint : Sprint 9
     * @lastmodifiedBy : Prachi for SFDC1-1154 validation rule
     * @lastmodified description: Primary Contact roles needs to be created before updating opprtunity to stage 3 and above as per  SFDC1-5782 AND SFDC1-5029
     * @modifiedBy: Ankita Singh on 5th December,2017
     */
     static testMethod void testUpdateAccountRelationship() {
         //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        List<Account> lstAcc = new List<Account>();
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        Account testAccount1 = TestUtility.createTestAccount('testAccount 123', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        testAccount1.DataGovernanceStatus__c = 'Approved';
        lstAcc.add(testAccount);
        testAccount1.Phone = '1234';
        testAccount1.Website= 'www.abc-123.com';
        lstAcc.add(testAccount1);
        insert lstAcc ;
        Contact testContact = TestUtility.createContact(testAccount.Id, 'testihsmarkit@testihsmarkit.com',
                                                        true, 'Test', 'Contact');
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        Account assertAccount = [Select Id,Relationship__c from Account where Id =:testAccount.Id];
        System.assertEquals('Prospect', assertAccount.Relationship__c,'Checking relationship on account creation');
        
        //create related opportunity and close it
        Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', true);
        Opportunity testOpportunity1 = TestUtility.createOpportunity(testAccount1.Id, 'test Opppy1', true);
        Test.startTest();
        OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, true);
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = testContact.Id;
        ocr.OpportunityId = testOpportunity.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        insert ocr;
         
        testOpportunity.StageName = '6W-Closed Won';
        testOpportunity.ContractId = contract1.id;
        testOpportunity.ContractStartDate__c = System.today();
        testOpportunity.ContractEndDate__c = System.today();
        testOpportunity.ActivityCreated__c = true;
        testOpportunity.ReadyForProcessingContractExist__c = true;
        GlobalVariables.preventRecursiveExecution = true;  
        update testOpportunity;
        //assert again
        assertAccount = [Select Id,Relationship__c from Account where Id =:testAccount.Id];
        System.assertEquals('Customer', assertAccount.Relationship__c,'Checking relationship on account creation');
        testOpportunity1.StageName = '1-Sales Qualified';
        GlobalVariables.preventRecursiveExecution = true;  
        update testOpportunity1;
        assertAccount = [Select Id,Relationship__c from Account where Id =:testAccount1.Id];
        System.assertEquals('Prospect', assertAccount.Relationship__c,'Checking relationship on account creation');                
        Test.stopTest();
     }
     
      /**
      * @author Prachi Bhasin
      * @date 8th Sept 2017
      * @description SFDC1-1990 test class for OpportunityMethods.populateExternalSourceSystemOnOpportunity
      * @param TriggerParameters
      * @return void
      * @companyname Vertiba
      */
     static testMethod void testPopulateExternalSourceSystemOnOpportunity() {
         //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        Test.startTest();
        
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;

        Account assertAccount = [Select Id,Relationship__c from Account where Id =:testAccount.Id];
        System.assertEquals('Prospect', assertAccount.Relationship__c,'Checking relationship on account creation');
        
        //create related opportunity and close it
        Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', true);
        OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, true);
        update testOpportunity;
        
        Opportunity oppCloned = testOpportunity.clone(false, true, false, false);
        insert oppCloned;
        String oppSource = [select id,SourceSystem__c from opportunity where id=: oppCloned .id limit 1].SourceSystem__c;
        System.assertEquals('Clone',oppSource ,'Checking cloned opportunity');
        Test.stopTest();
     }
        
    /**
     * @author: Vishnu vardhan Chowdary Andra
     * @date: 13 September 2017
     * @description: This method tests the updateGAMOnOpportunityCreation by creating opportunity.
     * @companyname: VERTIBA 
     */ 
    private static testMethod void testupdateGAMOnOpportunityCreation() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', firstName='test',HRManager__c='manager',LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123@ihs456789.com',ADID__c='test'+system.now().millisecond(),EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
        insert u;
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        a.DataGovernanceStatus__c = 'Approved';
        a.GlobalAccountManager__c = u.id;
        insert a;
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'testSetCaseAdditionalFieldsObject';
        c.AccountId = a.Id;
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.StageName= '1-Sales Qualified';
        opp.RecordTypeId = devRecordTypeId;
        opp.CloseDate = System.today()+2;
        opp.Amount = 123;
        opp.AccountId = a.id;
        insert opp;       
        
        Test.startTest();
        Opportunity testopp = [Select id, GAM__c from opportunity where id =: opp.id];
        System.assertEquals(testopp.GAM__c, u.id);
        Test.stopTest();
    } 
    //-----------------------------
    // @author: Sonam Raju
    // @date: 15 December 2017
    // @param: NA
    // @description: Test method for Opportunity trigger method checkChannelManagerRoleonOpptyTeamforStage2andhigher on update
    // @return: NA
    //-----------------------------
    private static testMethod void testcheckChannelManagerRoleonOpptyTeamforStage2andhigher() {
        
        //Create System Administrator with Role assigned
        UserRole AdminRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User SysAdmin = TestUtility.createAdminUser('satest@satest.com',false);
        SysAdmin.UserRoleId = AdminRole.id;
        insert SysAdmin;
       
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
       
        system.runas(SysAdmin) {
            //Create account
            Account portalAccount1 = TestUtility.createTestAccount('Account testPartnerAccountforOpptyTeamMemberCheck', false);
            portalAccount1.DataGovernanceStatus__c = 'Approved';
            portalAccount1.Type ='Global Alliance';
            portalAccount1.AccountSubType__c ='Reseller';
            insert(portalAccount1);
                    
            //Create portal enabled contacts
            Contact portalcontact1 = TestUtility.createContact(portalAccount1.id,'test123@test.com',true,'Test','Test123');
            Contact portalcontact2 = TestUtility.createContact(portalAccount1.id,'test567@test.com',true,'Test','Test567');
            
            //Create portal user with portal user profile
            User testUser1 = TestUtility.createTestUser('IHS Markit: Channel Partner User', 'testUser.testportaluser1@abc.com.user',false);
            testUser1.ContactId = portalcontact1.Id;
            insert testUser1;
            
            //Create Standard user
            User testUser2 = TestUtility.createTestUser('Standard User', 'testUser.test987@abc.com.user',true);
            
            //Create Account for Opportunity and move ownership to portal user
            Account testaccount = TestUtility.createTestAccount('Account testAccountforOpportunity', false);
            testaccount.DataGovernanceStatus__c = 'Approved';
            testaccount.Type ='Global Alliance';
            testaccount.AccountSubType__c ='Reseller';
            insert testaccount;
            
            testaccount.ownerid = testUser1.id;
            update testaccount;

            //Create Opportunity with portal user as owner
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opp';
            opp.StageName= '1-Sales Qualified';
            opp.RecordTypeId = devRecordTypeId;
            opp.CloseDate = System.today()+2;
            opp.Amount = 123;
            opp.AccountId = testaccount.id;
            opp.Subtype__c = 'Global Alliance';
            opp.ChannelPartner__c=portalAccount1.id ;
            opp.ownerId = testUser1.id;
            insert opp;
            
            //Create Opportunity Contact Role on Opportnity
            OpportunityContactRole oppContactRole = new OpportunityContactRole();
            oppContactRole.OpportunityID = opp.id;
            oppContactRole.ContactId = portalcontact1.id;
            oppContactRole.IsPrimary = true;
            insert oppContactRole;
            
            //Add Opportunity Member with Role other than Channel Manager
            OpportunityTeamMember otm = TestUtility.createOpportunityTeamMember(opp.id,testUser2.id,'Edit', true);
            otm.TeamMemberRole ='Account Manager';
            insert otm;
            
            Test.startTest();
            try {
                opp.StageName= '2-Need Confirmed';
                update opp;
            }
            catch(Exception e) {
                Boolean expectedExceptionThrown =  e.getMessage().contains(System.Label.OpptyChannelPartnerError) ? true : false;
                // Assert to check correct Error is thrown
                System.AssertEquals(expectedExceptionThrown, true);
            }
                    
            //Adding Opportunity Member with Channel Manager Role           
            OpportunityTeamMember otm2 = TestUtility.createOpportunityTeamMember(opp.id,testUser1.id,'Edit', true);
            otm2.TeamMemberRole ='Channel Manager';
            insert otm2;
            
            opp.StageName= '2-Need Confirmed';
            update opp;
            System.AssertEquals('2-Need Confirmed', opp.StageName);
            Test.stopTest();
        }
    }
     ///////////////////////////////////////////////////////////////////////////////////////
    //@author: Paras Dhingra                                                            //
    //@date: 09th Jan 2018                                                             //
    //@description: SFDC1-4723 This method test                                       //
    //              the method OpportunityMethod.updateOpportunitySplitOnGamChange   //
    //@companyName: IHS Markit                                                      //
    /////////////////////////////////////////////////////////////////////////////////
    private static testMethod void testUpdateOpportunitySplitOnGamChange() {
        User testUser1 = TestUtility.createAdminUser('testUser1email@test.com.ihsmarkit.test', true);
        User testUser2 = TestUtility.createAdminUser('testUser2email@test.com.ihsmarkit.test', true);
        
        Account testAccount = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        testAccount.GlobalAccountManager__c = testUser1.id;
        insert testAccount;
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.StageName= '1-Sales Qualified';
        opp.RecordTypeId = devRecordTypeId;
        opp.CloseDate = System.today()+2;
        opp.Amount = 123;
        opp.AccountId = testAccount.id;
        insert opp;
        Test.startTest();
        //Assert Opportunity for existing split in overlay
        List<OpportunitySplit> assertOppySplit = [Select Id, SplitPercentage,SplitType.DeveloperName, SplitOwnerId
                                            from OpportunitySplit where opportunityId=:opp.Id AND SplitOwnerId=:testUser1.Id];
        System.assertEquals(1,assertOppySplit.size(),'Check Overlay opportunity split count');
        System.assertEquals('Overlay',assertOppySplit[0].SplitType.DeveloperName, 'Check overlay type');
        //change GAM
        testAccount.GlobalAccountManager__c = testUser2.Id;
        update testAccount;
        Test.stopTest();
        //assert Oppy SPlit
        assertOppySplit = [Select Id, SplitPercentage,SplitType.DeveloperName, SplitOwnerId
                                            from OpportunitySplit where opportunityId=:opp.Id AND SplitOwnerId=:testUser2.Id];
        System.assertEquals(1,assertOppySplit.size(),'Check Overlay opportunity split count');
        System.assertEquals('Overlay',assertOppySplit[0].SplitType.DeveloperName, 'Check overlay type');
        
    }
    //-----------------------------
    // @author: Mohit Modi
    // @date: 28 March 2018
    // @param: TriggerParameters
    // @description: SFDC1-7635 - This Method to Test 'updateReferredByOnOpportunityTeam' Method when Opportunity ReferredBy field is added while insert.
    // @return: None
    //------------------------------
    private static testMethod void testupdateReferredByOnOpportunityTeamOnINSERT() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        a.DataGovernanceStatus__c = 'Approved';
        insert a;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', firstName='test',HRManager__c='manager',LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123@ihs456789.com',ADID__c='test'+system.now().millisecond(),EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
        insert u;
        Test.startTest();
            Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opp';
            opp.StageName= '1-Sales Qualified';
            opp.RecordTypeId = devRecordTypeId;
            opp.CloseDate = System.today()+2;
            opp.Amount = 123;
            opp.ReferredBy__c = u.id;
            opp.AccountId = a.id;
            insert opp;
            System.assertEquals(opp.ReferredBy__c, u.id); 
            
            OpportunityTeamMember otm = new OpportunityTeamMember(); 
            otm =[Select id, name, userId from OpportunityTeamMember where OpportunityId=:opp.id and TeamMemberRole = 'Referred By' limit 1];
            System.assertEquals(opp.ReferredBy__c, otm.userId ); 
        Test.stopTest();    
    }
    //-----------------------------
    // @author: Mohit Modi
    // @date: 28 March 2018
    // @param: TriggerParameters
    // @description: SFDC1-7635 - This Method to Test 'updateReferredByOnOpportunityTeam' Method when Opportunity ReferredBy field is updated.
    // @return: None
    //------------------------------
    private static testMethod void testupdateReferredByOnOpportunityTeamOnUpdate() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        a.DataGovernanceStatus__c = 'Approved';
        insert a;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', firstName='test',HRManager__c='manager',LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123@ihs456789.com',ADID__c='test'+system.now().millisecond(),EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
        insert u;
        
        User u1 = new User(Alias = 'standt1', Email='standarduser123@testorg.com', 
            EmailEncodingKey='UTF-8', firstName='test',HRManager__c='manager123',LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123123@ihs456789.com',ADID__c='test123'+system.now().millisecond(),EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
        insert u1;
        
        Test.startTest();
            Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opp';
            opp.StageName= '1-Sales Qualified';
            opp.RecordTypeId = devRecordTypeId;
            opp.CloseDate = System.today()+2;
            opp.Amount = 123;
            opp.ReferredBy__c = u.id;
            opp.AccountId = a.id;
            insert opp;
            System.assertEquals(opp.ReferredBy__c, u.id); 
            
            OpportunityTeamMember otm = new OpportunityTeamMember(); 
            otm =[Select id, name, userId from OpportunityTeamMember where OpportunityId=:opp.id and TeamMemberRole = 'Referred By' limit 1];
            System.assertEquals(opp.ReferredBy__c, otm.userId );
            
            opp.ReferredBy__c = u1.id;
            update opp;
            
            otm =[Select id, name, userId from OpportunityTeamMember where OpportunityId=:opp.id and TeamMemberRole = 'Referred By' limit 1];
            System.assertEquals(opp.ReferredBy__c, otm.userId );
        Test.stopTest();
    }
    //-----------------------------
    // @author: Mohit Modi
    // @date: 28 March 2018
    // @param: TriggerParameters
    // @description: SFDC1-7635 - This Method to Test 'updateReferredByOnOpportunityTeam' Method when Opportunity ReferredBy field is removed.
    // @return: None
    //------------------------------
    private static testMethod void testupdateReferredByOnOpportunityTeamOnREMOVE() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        a.DataGovernanceStatus__c = 'Approved';
        insert a;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', firstName='test',HRManager__c='manager',LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123@ihs456789.com',ADID__c='test'+system.now().millisecond(),EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
        insert u;
        
        Test.startTest();
            Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opp';
            opp.StageName= '1-Sales Qualified';
            opp.RecordTypeId = devRecordTypeId;
            opp.CloseDate = System.today()+2;
            opp.Amount = 123;
            opp.ReferredBy__c = u.id;
            opp.AccountId = a.id;
            insert opp;
            System.assertEquals(opp.ReferredBy__c, u.id); 
            
            list<OpportunityTeamMember> otm = new List<OpportunityTeamMember>(); 
            otm =[Select id, name, userId from OpportunityTeamMember where OpportunityId=:opp.id and TeamMemberRole = 'Referred By'];
            System.assertEquals(opp.ReferredBy__c, otm[0].userId );
            
            opp.ReferredBy__c = NULL;
            update opp;
            
            otm =[Select id, name, userId from OpportunityTeamMember where OpportunityId=:opp.id and TeamMemberRole = 'Referred By'];
            System.assertEquals(otm.isEmpty() , True );
        Test.stopTest();
    }
	
	/**
     * @author : Sruti Srivastava
     * @date : 9th April 2018
     * @description SFDC1-7027- Test method for verifying Contract Start Date and End Date on Opportunity Line Items if 'ContractStartDate__c' and 'ContractEndDate__c' field on Opportunity are updated 
     * @lastmodifiedSprint : Sprint 23
     */
     static testMethod void testUpdateContractStartDateAndEndDateOnOpportunityLineItem() { 
		 
         //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        
        Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', true);
         
        Test.startTest();
		OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, true);
		//Verifying if Contract start Date and End date are correctly populated as null 
        System.assertEquals(null, [Select ContractStartDate__c From OpportunityLineItem where Id= :testOLI.Id limit 1].ContractStartDate__c,'Checking if ContractStartDate__c on OLI is correctly populated');
		System.assertEquals(null, [Select ContractEndDate__c From OpportunityLineItem where Id= :testOLI.Id limit 1].ContractEndDate__c,'Checking if ContractEndDate__c on OLI is correctly populated');
        testOpportunity.ContractStartDate__c = Date.Today().addDays(-30);
		testOpportunity.ContractEndDate__c = Date.Today().addDays(30);
		update testOpportunity;
        Test.stopTest();
        //Verifying if Contract start Date and End date are correctly populated from opportunity
		System.assertEquals(testOpportunity.ContractStartDate__c, [Select ContractStartDate__c From OpportunityLineItem where Id= :testOLI.Id limit 1].ContractStartDate__c,'Checking if ContractStartDate__c on OLI is correctly populated');
		System.assertEquals(testOpportunity.ContractEndDate__c, [Select ContractEndDate__c From OpportunityLineItem where Id= :testOLI.Id limit 1].ContractEndDate__c,'Checking if ContractEndDate__c on OLI is correctly populated');
	}
	
	 //-----------------------------
    // @author: Anjani Shukla
    // @date: 09 Apr 2018
    // @param: NA
    // @description: Test method for Opportunity trigger methods updateOpportunityRiskRecordStatus on update
    // @return: NA
    //-----------------------------
    private static testMethod void testupdateOpportunityRiskRecordStatus() {
        test.startTest();
        Account a = TestUtility.createTestAccount('Account testSetRenewalRiskOptysObject', false);
        a.DataGovernanceStatus__c = 'Approved';
        insert a;
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'testSetRenewalRiskOptysObject';
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
        opp.StageName= '1-Sales Qualified';
        opp.RecordTypeId = devRecordTypeId;
        opp.CloseDate = System.today()+2;
        opp.Amount = 123;
        opp.AccountId = a.id;
        insert opp;       
         
        // Create RenewalRisk Record.
        RenewalatRisk__c newRenewalRiskOpty = new RenewalatRisk__c();
        newRenewalRiskOpty.OpportunityAtRisk__c = opp.id;
        newRenewalRiskOpty.Account__c = a.id;
        newRenewalRiskOpty.Status__c = 'Open - Pending Resolution';
        newRenewalRiskOpty.RiskProbability__c = 1;
        newRenewalRiskOpty.Comments__c = 'test';
        newRenewalRiskOpty.EstimatedValueatRisk__c = 100;
        
        insert newRenewalRiskOpty;
        
        opp.StageName = '6L-Closed Lost';
        opp.LostReasonCode__c = 'Unfavorable Pricing';
        opp.LostReasonDescription__c ='test';
        update opp;
        System.assertEquals(opp.StageName, '6L-Closed Lost');      
        
        RenewalatRisk__c updatedRenewalRiskOpty = [select id,status__c,OpportunityAtRisk__c from RenewalatRisk__c where OpportunityAtRisk__c =: opp.id limit 1];
        
        system.assertEquals('Closed - Opportunity Lost',updatedRenewalRiskOpty.Status__c);
        test.stopTest();
        
    }
    
    //-----------------------------
    // @author: Anjani Shukla
    // @date: 09 Apr 2018
    // @param: NA
    // @description: SFDC1-8392 : Update Account Manager on Opportunity when Account is updated.
    // @return: NA
    //-----------------------------
    private static testMethod void testupdateOpportunityGAM() {
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', firstName='test',HRManager__c='manager',LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123@ihs456789.com',ADID__c='test'+system.now().millisecond(),EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
        insert u;
        
        Account aGAM1 = TestUtility.createTestAccount('Account testSetRenewalRiskOptysObject', false);
        aGAM1.DataGovernanceStatus__c = 'Approved';
        aGAM1.GlobalAccountManager__c = u.id;
        
        Account aGAM2 = TestUtility.createTestAccount('Account newTestAccforGAMUpdate', false);
        aGAM2.DataGovernanceStatus__c = 'Approved';
		aGAM2.GlobalAccountManager__c = UserInfo.getUserId();        
        
        insert new list<Account>{aGAM1,aGAM2};
        
        test.startTest();
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.StageName= '1-Sales Qualified';
        opp.RecordTypeId = devRecordTypeId;
        opp.CloseDate = System.today()+2;
        opp.Amount = 123;
        opp.AccountId = aGAM1.id;
        insert opp;  
               
        //update account on opportunity
        opp.AccountId = aGAM2.id;
        update opp;
        
        system.assertEquals(aGAM2.GlobalAccountManager__c,[select GAM__c from Opportunity where id =: opp.id].GAM__c );
        test.stopTest();
        
    }
    
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 13 June 2018
    // @param: NA
    // @description: SFDC1-8434 :Test method for createOMCaseOnRenewalOpportunityClosure
    // @return: NA
    //-----------------------------
    private static testMethod void testCreateOMCaseOnRenewalOpportunityClosure() {
        Account aGAM1 = TestUtility.createTestAccount('Account testSetRenewalRiskOptysObject', false);
        aGAM1.DataGovernanceStatus__c = 'Approved';               
        insert new list<Account>{aGAM1};
        
        test.startTest();      
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Id innerYearRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Inner Year').getRecordTypeId();
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.StageName= '3-Renewal Pending';
        opp.RecordTypeId = devRecordTypeId;
        opp.CloseDate = System.today()+2;
        opp.AutoRenewal__c = true;
        opp.SourceSystem__c = 'Manually Generated';
        opp.DoesThisAutoRenewalHaveChanges__c = false;
        opp.Amount = 123;
        opp.AccountId = aGAM1.id;
        oppList.add(opp);
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test Inner Opp';
        opp2.StageName= '3-Renewal Pending';
        opp2.RecordTypeId = innerYearRecordTypeId;
        opp2.CloseDate = System.today()+2;
        opp2.SourceSystem__c = 'Manually Generated';
        opp2.AccountId = aGAM1.id;
        oppList.add(opp2);
        insert oppList;
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'test1';
        c.AccountId = aGAM1.Id;
        c.Email = 'a@tst123example.com';
        insert c;
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = c.Id;
        ocr.OpportunityId = opp.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        insert ocr;  
        opp.StageName= '6W-Renewal Won';
        opp2.StageName= '6W-Renewal Won';
        opp2.PORequired__c = true;
        update oppList;
        system.debug('opp.id----'+opp.id);
        System.debug('opp2.id----'+opp2.Id);
        List<Case> lstOMCase = new List<case>([Select id,RecordType.Name from Case where Opportunity__c IN :oppList]);
        system.assertEquals('Order Management',lstOMCase[0].RecordType.Name);
        system.assertEquals('Order Management',lstOMCase[1].RecordType.Name);
        test.stopTest();   
    }
    //-----------------------------
    // @author: Veriba
    // @company: VERTIBA
    // @date: 25 June 2018
    // @param: 
    // @description:  Test method to check if functionality is working.
    // @return: NA
    // @Modification : Updated code for new methods added for edit fucntionality.
    // @Modification date : Anjani Shukla:25 May 2018 - SFDC1-8147 - New Cross Plant Status Added.
    //-----------------------------
    public static testMethod void testupdateOpportunityProductRestriction() {
        test.startTest();
        //Order Management profile
        Profile p = [SELECT Id ,name FROM Profile WHERE Name like '%Order management%' limit 1];
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', firstName='test',HRManager__c='manager',LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser123@ihsihs.com',ADID__c='test'+system.now().millisecond(),EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
        insert u;
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        //Contact
        Contact con = TestUtility.createContact(testAccount.id,'testemail1@test.com',false,'TestFirstName','TestLastName');
        con.Phone = '123423';
        con.Fax = '321412321';
        insert con;
        
        //Opportunity
        //creating an Opportunity 
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Opportunity testOpportunity = new Opportunity();
        testOpportunity.Name = 'Test Opp';
        testOpportunity.StageName= '1-Sales Qualified';
        testOpportunity.RecordTypeId = devRecordTypeId;
        testOpportunity.CloseDate = System.today()+2;
        testOpportunity.Amount = 123;
        testOpportunity.AccountId = testAccount.id;
        insert testOpportunity;
        
        //Opportunity Contact role
        OpportunityContactRole oppContactRole = new OpportunityContactRole ();
            oppContactRole.OpportunityId = testOpportunity.id;
            oppContactRole.ContactId = con.id;
            oppContactRole.IsPrimary = true;
       insert  oppContactRole;
        //Product
        CrossPlantStatus__c availableProd = new CrossPlantStatus__c();
        availableProd.Name='Renewal Only';
        availableProd.SAPCode__c ='09';
        availableProd.Status__c ='Active';
        insert availableProd;
        
               
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        //Creating Contract
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, true);
        
            List<String> lstforRecord = new List<String>();           
            WarningMsgProductCrossPlantStatus objWarnMsgProdCrossPlantStatus = new WarningMsgProductCrossPlantStatus();
            lstforRecord = WarningMsgProductCrossPlantStatus.getOptyProdLineDetails(testOpportunity.id);
            WarningMsgProductCrossPlantStatus.errorMsgRecord = lstforRecord;
            system.assertEquals(0, lstforRecord.size());  
        
        // update stage.
        testOpportunity.StageName = '2-Need Confirmed'; update testOpportunity;
        lstforRecord = WarningMsgProductCrossPlantStatus.getOptyProdLineDetails(testOpportunity.id);
        WarningMsgProductCrossPlantStatus.errorMsgRecord = lstforRecord;
        system.assertEquals(0, lstforRecord.size());  
        
        Test.stopTest();    
    }
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 28 jun 2018
    // @param: NA
    // @description: SFDC1-8243 :Test method for updateFiscalOnChangeOfCloseDate
    // @return: NA
    //-----------------------------
    private static testMethod void testupdateFiscalOnChangeOfCloseDate() {
        //create test data
        ProfitCenter__c testProfitCenter = new ProfitCenter__c(Name='UP - Energy', Active__c=true, ProfitCenterCode__c='187');
        insert testProfitCenter;
        Family__c testProdFam = new Family__c(Name='ETC-C&A',Status__c ='Active');
        insert testProdFam;
        //create test data
		Product2 testProd = TestUtility.createProduct('Test Product', false);
		testProd.FormerIpOwner__c = 'IHS Markit Global Inc.';
		testProd.Family__c = testProdFam.Id;
		testProd.ProfitCenters__c = testProfitCenter.Id;
		insert testProd;
		Id standardId = Test.getStandardPricebookId();
		PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
		testAccount.DataGovernanceStatus__c = 'Approved';
		insert testAccount;

		Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', false);
		testOpportunity.closeDate = date.newinstance(2017, 11, 11);
        insert testOpportunity;
         
		OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, true);
		ProductSchedule__c ps1 = TestUtility.createProductSchedule(2223.23, '2017', '3 Years', '2017', testProd.Id, false);
        ProductSchedule__c ps2 = TestUtility.createProductSchedule(2323.23, '2017', '3 Years', '2018', testProd.Id, false);
        ProductSchedule__c ps3 = TestUtility.createProductSchedule(2423.23, '2017', '3 Years', '2019', testProd.Id, false);
        //insert product schedule for 2018 financial year
        ProductSchedule__c ps4 = TestUtility.createProductSchedule(2223.23, '2018', '3 Years', '2018', testProd.Id, false);
        ProductSchedule__c ps5 = TestUtility.createProductSchedule(2323.23, '2018', '3 Years', '2019', testProd.Id, false);
        ProductSchedule__c ps6 = TestUtility.createProductSchedule(2423.23, '2018', '3 Years', '2020', testProd.Id, false);
        insert new List<ProductSchedule__c>{ps1,ps2,ps3,ps4,ps5,ps6};
        OpportunityLineItemSchedule__c ops1 = TestUtility.createOpportunityProductSchedule(testOpportunity.Id,ps1.Id,2223.23,2000,
                                                                                            'Amount', 223.23, 0.0, testProd.Id, '2017', 1, 
                                                                                            testOLI.Id,false);
        OpportunityLineItemSchedule__c ops2 = TestUtility.createOpportunityProductSchedule(testOpportunity.Id,ps2.Id,2323.23,2000,
                                                                                            'Amount', 323.23, 0.0, testProd.Id, '2018', 1, 
                                                                                            testOLI.Id,false);
        OpportunityLineItemSchedule__c ops3 = TestUtility.createOpportunityProductSchedule(testOpportunity.Id,ps3.Id,2323.23,2000,
                                                                                            'Amount', 423.23, 0.0, testProd.Id, '2019', 1, 
                                                                                            testOLI.Id,false);
        insert new List<OpportunityLineItemSchedule__c>{ops1,ops2,ops3};
        Test.StartTest();
        //updated closed date of opportunity and check if fiscal year of Oppy schedules is upated or not
        testOpportunity.closeDate = date.newinstance(2018, 6, 21);
        GlobalConstants.hasUpdatedProductSchedules=false;
        update testOpportunity;
        //assert that fiscal year is updated for Oppy schedules
        List<OpportunityLineItemSchedule__c> lstOppySchedules = [Select Id,ProductSchedule__c, ProductSchedule__r.PricingYear__c from OpportunityLineItemSchedule__c 
                                                                    where Opportunity__c=:testOpportunity.Id and ProductSchedule__r.PricingYear__c='2018'];
        System.assertEquals(3, lstOppySchedules.size(),'Checking that fiscal year is changed');
        Test.StopTest();
    }
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 28 jun 2018
    // @param: NA
    // @description: SFDC1-7059 - Test method for OpportunityValidations
    // @return: NA
    //-----------------------------
    private static testMethod void testOpportunityValidations() {
        //create test data
        //adding more atttributes to product
        ProfitCenter__c testProfitCenter = new ProfitCenter__c(Name='UP - Energy', Active__c=true, ProfitCenterCode__c='187');
        insert testProfitCenter;
        Family__c testProdFam = new Family__c(Name='ETC-C&A',Status__c ='Active');
        insert testProdFam;
        //create test data
		Product2 testProd = TestUtility.createProduct('Test Product', false);
		testProd.FormerIpOwner__c = 'IHS Markit Global Inc.';
		testProd.Family__c = testProdFam.Id;
		testProd.ProfitCenters__c = testProfitCenter.Id;
		insert testProd;
		Id standardId = Test.getStandardPricebookId();
		PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        Integer currentFY = UtilityClass.calculateFyFromDate(Date.Today(), UtilityClass.FiscalStartMonth);
        Integer nextFY = currentFY+1;
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
		testAccount.DataGovernanceStatus__c = 'Approved';
		insert testAccount;

		Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', false);
		testOpportunity.ContractStartDate__c = 	date.newinstance(currentFY, 03,21 );
		testOpportunity.ContractEndDate__c = date.newinstance(currentFY+2, 10, 21);
		testOpportunity.AutoRenewal__c = true;
		testOpportunity.DoesThisAutoRenewalHaveChanges__c = false;
        insert testOpportunity;
        OpportunityValidationFields__c ofv = new OpportunityValidationFields__c(Name='Opportunity Name',APIName__c='Name',RuleName__c='AutoRenewDoesNotHaveChanges');
        OpportunityValidationFields__c ofv2 = new OpportunityValidationFields__c(Name='Description',APIName__c='Description',RuleName__c='AutoRenewHasChanges');
        insert new List<OpportunityValidationFields__c>{ofv,ofv2};
        //create test user
        Profile p = [Select id,name from profile where name like '%Sales Ops%' limit 1];
        System.debug('@PD--profile query name--'+p.name);
        String username = 'testusera@testihsmarkit.com';
        User testUser = new User(Alias = 'standt', Email=username, 
                                  EmailEncodingKey='UTF-8', firstName='testFirstName', HRManager__c='testManager', LastName='testLastName',
                                  LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,
                                  TimeZoneSidKey='America/Los_Angeles', UserName=username, ADID__c='test'+system.now().millisecond(),
                                  EmployeeNumber=String.valueOf(Math.round(Math.random()*10000)),EmployeeNumber__c=String.valueOf(Math.round(Math.random()*10000)));
        insert testUser;
        System.runAs(new User(Id=UserInfo.getUserId())) {
            GlobalConstants.hasTriggeredFromOpportunityProduct= false;
            GlobalConstants.hasBeenValidatedOnce = false;
            testOpportunity.ownerId = testUser.Id;
            update testOpportunity;
        }
        Test.startTest();
        System.runAs(testUser) {
            //test positive test case
            testOpportunity.name = 'test Opportunity name change';
            GlobalConstants.hasTriggeredFromOpportunityProduct= false;
            GlobalConstants.hasBeenValidatedOnce = false;
            //reseting the logged in user profile
            UtilityClass.LoggedInUserProfileName = null;
            update testOpportunity;
            //test negative test case
            try {
                     testOpportunity.description = 'test fail';
                     GlobalConstants.hasTriggeredFromOpportunityProduct= false;
                     GlobalConstants.hasBeenValidatedOnce = false;
                     update testOpportunity;
                     System.assert(false,'Control will not reach here');
              } 
              catch (exception ex) {
                  Boolean errorexist = ex.getmessage().contains(System.Label.AutoRenewHasChangesOppyError) ? true : false;
                  System.assertEquals(errorexist ,true);
              }
        }
        Test.stopTest();
        
    }
	
	//-----------------------------
    // @author: Anjani Shukla
    // @date: 23 July 2018
    // @param: TriggerParameters
    // @description: SFDC1-5864 - Cumulative Contract Value
    //                            Migrating Process builder "Cumulative Contract Value" &  
    //                            "Clear Total Cumulative Contract Value"
    // This method will be called in afterupdate trigger Events.
    // @return: None
    //------------------------------
    private static testMethod void testupdateCumulativeContractAddwhen6W() {
    	User testUser1 = TestUtility.createAdminUser('testUser1email@test.com.ihsmarkit.test', true);
        
        
        Account testAccount = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        testAccount.GlobalAccountManager__c = testUser1.id;
        insert testAccount;
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.StageName= '1-Sales Qualified';
        opp.RecordTypeId = devRecordTypeId;
        opp.CloseDate = System.today()+2;
        opp.Amount = 123;
        opp.AccountId = testAccount.id;
        insert opp;
       	
          //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        test.startTest();
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Contract testContract = TestUtility.createContractWithInsertOptional(testAccount.id, legalEntity.id,
                                                                        country.id,standardId,false);
        testContract.RecordTypeId = orderFormRecordTypeId;
        testContract.AccountId = testAccount.id;
        testContract.AutoRenewal__c = true;
        testContract.CurrencyIsoCode = 'USD';
        testContract.StartDate = System.today();
        testContract.Pricebook2Id = standardId;
        testContract.ContractTerm = 10;
        insert testContract;
        
        
        Id renewRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Opp';
        opp1.StageName= '3-Renewal Pending';
        opp1.RecordTypeId = renewRecordTypeId;
        opp1.CloseDate = System.today()+2;
        opp1.AutoRenewal__c = true;
        opp1.SourceSystem__c = 'Manually Generated';
        opp1.DoesThisAutoRenewalHaveChanges__c = false;
        opp1.Amount = 123;
        opp1.AccountId = testAccount.id;
        opp1.ContractBeingRenewed__c = testContract.id;
        oppList.add(opp1);
        
        insert oppList;
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'test1';
        c.AccountId = testAccount.Id;
        c.Email = 'a@tst123example.com';
        insert c;
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = c.Id;
        ocr.OpportunityId = opp1.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        insert ocr;  
        
        opp1.StageName = '6W-Renewal Won';
        update opp1;
        
        system.assertEquals([select AllAssociatedTotalOpportunityValue__c from Contract where Id=: testContract.id].AllAssociatedTotalOpportunityValue__c, 123);
       // system.assertEquals(expected, actual);
        
        test.stopTest();
        
        
    }

	//-----------------------------
    // @author: Anjani Shukla
    // @date: 23 July 2018
    // @param: TriggerParameters
    // @description: SFDC1-5864 - Cumulative Contract Value
    //                            Migrating Process builder "Cumulative Contract Value" &  
    //                            "Clear Total Cumulative Contract Value"
    // This method will be called in afterupdate trigger Events.
    // @return: None
    //------------------------------
    private static testMethod void testremoveCumulativeContractWhen6WtoContracting() {
    	User testUser1 = TestUtility.createAdminUser('testUser1email@test.com.ihsmarkit.test', true);
        
        
        Account testAccount = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        testAccount.GlobalAccountManager__c = testUser1.id;
        insert testAccount;
        
        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.StageName= '1-Sales Qualified';
        opp.RecordTypeId = devRecordTypeId;
        opp.CloseDate = System.today()+2;
        opp.Amount = 123;
        opp.AccountId = testAccount.id;
        insert opp;
       	
          //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        test.startTest();
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Contract testContract = TestUtility.createContractWithInsertOptional(testAccount.id, legalEntity.id,
                                                                        country.id,standardId,false);

        testContract.RecordTypeId = orderFormRecordTypeId;
        testContract.AccountId = testAccount.id;
        testContract.AutoRenewal__c = true;
        testContract.Fastrack__c = true;
        testContract.NoInternalApprovalNeeded__c = true;
        testContract.PriceIncreaseClause__c ='Standard Contract Price Increase';
        testContract.CurrencyIsoCode = 'USD';
        testContract.StartDate = System.today();
        testContract.Pricebook2Id = standardId;
        testContract.ContractTerm = 10;
        testContract.Status = 'Creation';
        insert testContract;
        system.assertEquals([select AllAssociatedTotalOpportunityValue__c from Contract where Id=: testContract.id].AllAssociatedTotalOpportunityValue__c, 0);
        
        Id renewRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Opp';
        opp1.StageName= '3-Renewal Pending';
        opp1.RecordTypeId = renewRecordTypeId;
        opp1.CloseDate = System.today()+2;
        opp1.AutoRenewal__c = true;
        opp1.SourceSystem__c = 'Manually Generated';
        opp1.DoesThisAutoRenewalHaveChanges__c = false;
        opp1.Amount = 100;
        opp1.AccountId = testAccount.id;
        opp1.ContractBeingRenewed__c = testContract.id;
        opp1.ActivityCreated__c = true;
        insert opp1;
        
        Contact c = new Contact();
        c.firstname = 'Test';
        c.lastname = 'test1';
        c.AccountId = testAccount.Id;
        c.Email = 'a@tst123example.com';
        insert c;
        OpportunityContactRole ocr = new OpportunityContactRole();
        ocr.ContactId = c.Id;
        ocr.OpportunityId = opp1.Id;
        ocr.IsPrimary = TRUE;
        ocr.Role = 'Decision Maker';
        insert ocr;  
        
        opp1.stagename = '5-Renewal Contracting';
        update opp1;
        system.assertEquals([select ContractBeingRenewed__r.AllAssociatedTotalOpportunityValue__c from opportunity where Id=: opp1.id].ContractBeingRenewed__r.AllAssociatedTotalOpportunityValue__c, 0);
        
        test.stopTest();
        
        
    }  
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 1 Aug 2018
    // @param: NA
    // @description: SFDC1-9500: Testmethod for revisit opportunity feature
    // @return: NA
    //-----------------------------
    private static testMethod void testRevisitOpportunityFeature() {
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;

        Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', false);
        testOpportunity.AutoRenewal__c = true;
        testOpportunity.DoesThisAutoRenewalHaveChanges__c = false;
        insert testOpportunity; 
        Test.startTest();
        Task taskRec = new Task(Subject='revisit testing', activityDate = System.Today()+10, priority = 'Normal');
        Id taskObjId = RevisitOpportunityLookup.creatTask(taskRec,testOpportunity.Id);
        system.assertNotEquals(taskObjId,NULL);
        testOpportunity.Revisit__c = false;
        update testOpportunity;
        Test.stopTest();
        
    }
	
	//-----------------------------
    // @author: Jagadesh Kumar
    // @date: 31 July 2018
    // @param: NA
    // @description: SFDC1-5228 :Test method for setContactRolePrimary
    // @return: NA
    //-----------------------------
    private static testMethod void testSetContactRolePrimary() {
        Test.startTest();
        Account acc = TestUtility.createTestAccount('BARCLAYS PLC',true);
        Contact con = TestUtility.createContact(acc.Id,'oppty.primary@ihsmarkit.com',true,'TestOppty','TestPrimary');
        Opportunity opp = TestUtility.createOpportunity(acc.id, 'BARCLAYS Opp',null,true);
        OpportunityContactRole ocr = new OpportunityContactRole(IsPrimary = true, OpportunityId = opp.Id, ContactId=con.Id);
        insert ocr;
        update opp;
        Test.stopTest();
        Opportunity op = [Select ID,PrimaryContact__c from Opportunity where Id =: opp.Id];
        System.assertEquals('TestOppty TestPrimary', op.PrimaryContact__c); 
    }
    
    //-----------------------------
    // @author: Uttam Arya
    // @date: 11 Sept 2018
    // @param: NA
    // @description: Test method for Opportunity trigger methods changeAdditionalOpportunityFieldsNameWhenOpportunityFieldChanges on update and setOpportunityAdditionalFieldsObject on insert
    // @return: NA
    //-----------------------------
    private static testMethod void TestOpportunityAdditionalFieldsObject() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', false);
        a.DataGovernanceStatus__c = 'Approved';
        insert a;
        
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
        opp.StageName= '1-Sales Qualified';
        opp.RecordTypeId = devRecordTypeId;
        opp.CloseDate = System.today()+2;
        opp.Amount = 123;
        opp.GAM__c = u.id;
        opp.AccountId = a.id;
        insert opp;       
        
        Opportunity oppyInserted = [Select Id, Name, AdditionalOpportunityFields__r.Name, AdditionalOpportunityFields__c from Opportunity where id = :opp.id];
        
        System.assert(oppyInserted != null);
        System.assert(oppyInserted.AdditionalOpportunityFields__c != null);
        System.assertEquals(('Additional Fields - ' + oppyInserted.Name).left(80), oppyInserted.AdditionalOpportunityFields__r.Name);
        
        opp.Name = 'Test Opp2';
        opp.LegacyID__c = '123455';
        
        update opp;
        
        oppyInserted = [Select Id, Name, LegacyID__c, AdditionalOpportunityFields__r.Name, AdditionalOpportunityFields__c, AdditionalOpportunityFields__r.LegacyID__c from Opportunity where id = :opp.id];
        
        System.assertEquals(oppyInserted.LegacyID__c, oppyInserted.AdditionalOpportunityFields__r.LegacyID__c);
        System.assertEquals(('Additional Fields - ' + oppyInserted.Name).left(80), oppyInserted.AdditionalOpportunityFields__r.Name);

    }
}