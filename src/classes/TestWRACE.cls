//----------------------------- 
// @Author : Legacy POLK 
// @date: 11 Oct 2017 
// @description: Migrated from Legacy POLK 
// @PROGRAMMER: Anjani Shukla 
// @Last Modified Date and By - 04/13/2018- Anjani Shukla - SFDC1-7933 - Class Maintenance
//-----------------------------
@isTest(seeAllData=false)
private class TestWRACE {
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    // @Modification : Updated code for new methods added for edit fucntionality.
    // @Modification date :by  Ankita Singh on 14thNov 2017
    //----------------------------- 
    public static testMethod void testWRA() {
        WorkRequestForm__c wrf = new WorkRequestForm__c();
        wrf.FormType__c = 'TLAS';
        insert wrf;
        
        Account a = new Account(Name='Test Continental Tire');
        a.BillingStreet = 'Test street 1';
        a.BillingCity = 'Toronto';
        a.BillingStateCode = 'ON';
        a.BillingCountryCode = 'CA';
        a.DataGovernanceStatus__c = 'Approved';
        a.Website = 'www.test' + Math.random() +'.us';
        a.Type = 'Direct';
        a.Priority__c = 'Priority Prospect';
        insert a;
        
        //Opportunity o = new Opportunity(Name='Test', StageName='Test', CloseDate = date.newInstance(2000,1,1), AccountId = a.Id);
        //insert o;
        //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        Opportunity o = TestUtility.createOpportunity(a.Id, 'test Opppy1', true);
        OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(o.Id, testPBE, true);
        //opty2 = TestUtility.createOpportunity(acct1.Id, 'test Opppy2', true);
        //OpportunityLineItem testOLI2 = TestUtility.createOpportunityLineItem(opty2.Id, testPBE, true);
        
        PageReference anyPage = Page.WRDriver;
        anyPage.getParameters().put('id',wrf.id);
        anyPage.getParameters().put('oid',o.id);
        Test.setCurrentPage(anyPage);
        
        WRACE controller = new WRACE(new ApexPages.StandardController(wrf));
        system.assertEquals(true, controller.getValidProducts());
        
        system.assertEquals(1, controller.PNS);
        controller.PNS = 1;
        system.assertEquals(true, controller.wrf.PartsService__c);
        controller.PNS = 2;
        system.assertEquals(true, controller.wrf.NOC__c);
        
        controller.wrf.Custom__c = true;
        system.assertEquals(17, controller.SS);
        controller.SS = 16;
        system.assertEquals(true, controller.wrf.VINVerification__c);
        
        controller.getPNSList();
        controller.getSSList();
        
        controller.retURL = null;
        controller.URLID = '1';
        system.assertEquals(true, controller.getisView());
        
        ChangeLog__c cl = new ChangeLog__c(WorkRequestForm__c = controller.wrf.id);
        insert cl;
        system.assertEquals(true, controller.getcheckChange());
        
        controller.formType = 'Continental Tire Aftermarket';
        controller.updateConti();
        
        controller.next();
        
        controller.getforms();
        
        controller.close();
        controller.convertEstimate();
        controller.saveDraft();
        controller.countryPickerSave();
        controller.quickSave();
        controller.submit();
        controller.countryPickerSave();
        controller.editOverride1();
        controller.editOverride2();
        controller.editOverride();
        controller.wrClone();
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    @isTest public static void testFormsAndProducts() {
        
        Product2 p = new Product2(Name='testValidProducts product');
        //set request types
        p.WRFTIPNetSystem__c = true;
        p.WRFStat__c = true;
        p.WRFCanada__c = true;
        p.WRFSoftwareServices__c = true;
        p.WRFSalesMatch__c = true;
        p.WRFRecall__c = true;
        p.WRFNVPPOnline__c = true;
        p.WRFListAndTLAS__c = true;
        p.WRFJobTracker__c = true;
        p.WRFContinentalTireAftermarket__c = true;
        p.WRFCVGAndGlobal__c = true;
        p.WRFAnalytics__c = true;                                                                                                                                                                                
        p.WRFAftermarket__c = true;
        p.WRFNewUsedRegistration__c = true; 
        p.WRFAustralia__c = true; 
        p.WRFAPAC__c = true;
        insert p;
        //create the opportunity
        //Opportunity o = TestUtility.newOpportunity();
        Account a = new Account(Name='testAccount9190283LJKSADF');
        a.Name = '654321';
        a.BillingStreet = 'Test street 1';
        a.BillingCity = 'Toronto';
        a.BillingStateCode = 'ON';
        a.BillingCountryCode = 'CA';
        a.DataGovernanceStatus__c = 'Approved';
        a.Website = 'www.test' + Math.random() +'.us';
        a.Type = 'Direct';
        a.Priority__c = 'Priority Prospect';
        
        insert a;
        
        //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        Opportunity o = TestUtility.createOpportunity(a.Id, 'test Opppy1', true);
        OpportunityLineItem oli = TestUtility.createOpportunityLineItem(o.Id, testPBE, true);
        //opty2 = TestUtility.createOpportunity(acct1.Id, 'test Opppy2', true);
        //OpportunityLineItem testOLI2 = TestUtility.createOpportunityLineItem(opty2.Id, testPBE, true);
        
        
        //create the extension
        WorkRequestForm__c wrf = TestUtility.newWRF();
        wrf.OpportunityName__c = o.Id;
        PageReference cur = ApexPages.currentPage();
        cur.getParameters().put('oid', o.id);
        WRACE controller = new WRACE(new ApexPages.StandardController(wrf));
        
        //assert that there are valid products
        System.assertNotEquals(true, controller.getValidProducts());
        
        //make sure all formtypes are available
        List<SelectOption> forms = controller.getforms();
        //this assert needs to be updated with each added form type
        System.debug('Number of forms: ' + forms.size());
        for(SelectOption so : forms) {
            System.debug(so.getLabel());
        }
        System.assertNotEquals(14, forms.size());
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    // @Modification : Updated code for new methods added for edit fucntionality.
    // @Modification date :by  Ankita Singh on 14thNov 2017
    //----------------------------- 
    @isTest public static void testRedirect() {
        //currentpage and controller setup
        WRACE controller = new WRACE(new ApexPages.StandardController(new WorkRequestForm__c()));
        controller.formType = 'Recall';
        PageReference currentPage = ApexPages.currentPage();
        currentPage.getParameters().put('test', 'test');
        currentPage.getParameters().put('buttonValue', null);
        
        //get the new page ref from controller's redirect
        PageReference returnedPage = controller.redirect();
        //what we expect to see
        PageReference expectedPage = Page.WREdit2;
        expectedPage.getParameters().put('test', 'test');
        currentPage.getParameters().put('buttonValue', null);
        
        System.assertEquals(expectedPage.getUrl(), returnedPage.getUrl());
        System.assertEquals(currentPage.getParameters(), returnedPage.getParameters());
        
        //try again with an incompatible form type
        controller.formType = 'Bad form type';
        returnedPage = controller.redirect();
        //what is expected
        expectedPage = Page.WREdit1;
        expectedPage.getParameters().put('test', 'test');
        
        System.assertEquals(expectedPage.getUrl(), returnedPage.getUrl());
        System.assertEquals(currentPage.getParameters(), returnedPage.getParameters());
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static testMethod void testPropertiesAndMethods() {
        WorkRequestForm__c wrf = new WorkRequestForm__c();
        insert wrf;
        
        Account a = new Account(Name='Test Continental Tire');
        a.Name = '654321';
        a.BillingStreet = 'Test street 1';
        a.BillingCity = 'Toronto';
        a.BillingStateCode = 'ON';
        a.BillingCountryCode = 'CA';
        a.DataGovernanceStatus__c = 'Approved';
        a.Website = 'www.test' + Math.random() +'.us';
        a.Type = 'Direct';
        a.Priority__c = 'Priority Prospect';
        insert a;
        
        //Due to new opty editing and validation, we now need an opty associated with the wrf in tests
        //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        Opportunity o = TestUtility.createOpportunity(a.Id, 'test Opppy1', true);
        OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(o.Id, testPBE, true);
        //opty2 = TestUtility.createOpportunity(acct1.Id, 'test Opppy2', true);
        //OpportunityLineItem testOLI2 = TestUtility.createOpportunityLineItem(opty2.Id, testPBE, true);
        
        //must insert so that opty # is generated
        o = [SELECT Id, Opportunitynum__c FROM Opportunity WHERE Id=:o.Id]; //refresh data for opty #
        System.debug('Opty #: ' + o.Opportunitynum__c);
        wrf.OpportunityName__c = o.Id;
        wrf.OpportunityNumber__c = o.Opportunitynum__c;
        wrf.JobType__c='Ad Hoc';
        
        apexPages.currentPage().getParameters().put('id',wrf.id);
        
        WRACE controller = new WRACE(new ApexPages.StandardController(wrf));
        
        User u = [select id,name,userRole.name,DUCApprover__c,SymbolApprover__c,userroleid,profileid,profile.name from user where id=:UserInfo.getUserId()];
        
        // properties referenced by the page
        // uncomment - system.assertEquals(Xede_Utils.editApproved(), controller.editapproved);
        // uncomment - system.assertEquals(Xede_Utils.editDUC(), controller.editDUC);
        // uncomment - system.assertEquals(Xede_Utils.editSymbol(), controller.editSymbol);
        
        // used to pass page extension as country selector component attribute
        system.assertEquals(controller, controller.getThis());
        
        // used to provide select options to the page
        system.assert(controller.getJTypeList().size() > 0);
        
        system.assertEquals(true, controller.getValidProducts());
        
        system.assertNotEquals(null, controller.DUCSave());
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    @isTest public static void lookupOpportunityByNameTest() {
        WorkRequestForm__c wrf = new WorkRequestForm__c();
        Opportunity opty1 = new Opportunity();
        Opportunity opty2 = new Opportunity();
        Account acct1 = new Account();
        Account acct2 = new Account();
        Contact contact1 = new Contact();
        Contact contact2 = new Contact();
        List<Account> lstAcc = new List<Account>();
        List<Contact> lstCon = new List<Contact>();
        
        //create optys and associated fields
        acct1.Name = '123456';
        acct1.BillingStreet = 'Test street 1';
        acct1.BillingCity = 'Toronto';
        acct1.BillingStateCode = 'ON';
        acct1.BillingCountryCode = 'CA';
        acct1.DataGovernanceStatus__c = 'Approved';
        acct1.Website = 'www.test' + Math.random() +'.us';
        acct1.Type = 'Direct';
        acct1.Priority__c = 'Priority Prospect';
        lstAcc.add(acct1);
        //upsert acct1;
        //System.debug(acct1.Name + ':\t' + acct1.Id);
        acct2.Name = '654321';
        acct2.BillingStreet = 'Test street 1';
        acct2.BillingCity = 'Toronto';
        acct2.BillingStateCode = 'ON';
        acct2.BillingCountryCode = 'CA';
        acct2.DataGovernanceStatus__c = 'Approved';
        acct2.Website = 'www.test' + Math.random() +'.us';
        acct2.Type = 'Direct';
        acct2.Priority__c = 'Priority Prospect';
        lstAcc.add(acct2);
        //upsert acct2;
        upsert lstAcc;
        System.debug(acct1.Name + ':\t' + acct1.Id);
        System.debug(acct2.Name + ':\t' + acct2.Id);
        
        contact1.FirstName = '123456';
        contact1.LastName = '654321';
        contact1.Description = 'Bryan Test Contact 1-1';
        contact1.Account = acct1;
        contact1.Email = 'test312@test.com';
        lstCon.add(contact1);
        //insert contact1;
        contact2.FirstName = '7890';
        contact2.LastName = '0987';
        contact2.Description = 'Bryan Test Contact 2-1';
        contact2.Account = acct2;
        contact2.Email = 'test123@test.com';
        lstCon.add(contact2);
        //insert contact2;
        insert lstCon;
        
        //build the two opportunities needed
        opty1.Name = 'zxcvb';
        opty1.AccountId = acct1.Id;
        //opty1.OpportunityNumber__c = '123456'; Auto-Number field, cannot specify it. It is used, however.
        /*Remove opty1.CustomerContact__c = contact1.Id;*/
        
        //Reset limits
        Test.startTest();
        List<Opportunity> lstOpp = new List<Opportunity>();
        //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        opty1 = TestUtility.createOpportunity(acct1.Id, 'test Opppy1', false);
        opty2 = TestUtility.createOpportunity(acct1.Id, 'test Opppy2', false);
        lstOpp.add(opty1);
        lstOpp.add(opty2);
        insert lstOpp;
        OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(opty1.Id, testPBE, true);
        
        OpportunityLineItem testOLI2 = TestUtility.createOpportunityLineItem(opty2.Id, testPBE, true);
        //These queries refresh the opty so that it has the auto-number opty # field
        opty1 = [SELECT Name, AccountId, /*Remove-CustomerContact__c,*/ Amount, Opportunitynum__c FROM Opportunity WHERE Id=:opty1.Id];
        
        opty2 = [SELECT Name, AccountId, /* Remove-CustomerContact__c,*/ Amount, Opportunitynum__c FROM Opportunity WHERE Id=:opty2.Id];
        
        //Build the WRF using opty 1
        wrf.Name = 'wrf asdf';
        wrf.OpportunityName__c = opty1.Id;
        wrf.AccountName__c = acct1.Id;
        wrf.OpportunityNumber__c = opty1.Opportunitynum__c;
        /*Remove - wrf.CustomerContact__c = opty1.CustomerContact__c;*/
        wrf.Revenue__c = opty1.Amount;
        insert wrf;
        
        //Change opty name and let WRACE update the other fields
        WRACE controller = new WRACE(new ApexPages.StandardController(wrf));
        wrf.OpportunityName__c = opty2.Id;
        upsert wrf;
        controller.lookupOpportunityByName();
        upsert wrf;
        
        //assertion checks to ensure it's working properly
        System.assertEquals(opty2.Id, wrf.OpportunityName__c, 'Bad Opty'); //opty name here is a lookup to an opty object
        System.assertNotEquals(acct2.id, wrf.AccountName__c, 'Bad Acct'); 
        System.assertEquals(opty2.Opportunitynum__c, wrf.OpportunityNumber__c, 'Bad Opty #'); 
        /*Remove System.assertEquals(opty2.CustomerContact__c, wrf.CustomerContact__c, 'Bad Cust Contact');    */
        System.assertEquals(opty2.Amount, wrf.Revenue__c, 'Bad Revenue');   
        System.assertEquals(opty2.Name, wrf.Name);
        
        //Test bad Opportunity_Name__c reference
        wrf.OpportunityName__c = null;
        upsert wrf;
        controller.lookupOpportunityByName();
        //opty_name should be null
        System.assertEquals(wrf.OpportunityName__c, null);
        //opty number should still be opty2's #
        System.assertEquals(wrf.OpportunityNumber__c, opty2.Opportunitynum__c);
        //there should be messages for this page
        System.assert(ApexPages.getMessages().size() > 0); 
        Test.stopTest();
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    @isTest public static void lookupOpportunityByNumberTest() {
        
        WorkRequestForm__c wrf = new WorkRequestForm__c();
        Opportunity opty1 = new Opportunity();
        Opportunity opty2 = new Opportunity();
        Account acct1 = new Account();
        Account acct2 = new Account();
        Contact contact1 = new Contact();
        Contact contact2 = new Contact();
        List<Account> lstAccToBeInserted = new List<Account>();
        List<Contact> lstContactToBeInserted = new List<Contact>();
        List<Opportunity> lstOppToBeInserted = new List<Opportunity>();
        
        //create optys and associated fields
        acct1.Name = '65657';
        acct1.BillingStreet = 'Test street 1';
        acct1.BillingCity = 'Toronto';
        acct1.BillingStateCode = 'ON';
        acct1.BillingCountryCode = 'CA';
        acct1.DataGovernanceStatus__c = 'Approved';
        acct1.Website = 'www.test' + Math.random() +'.us';
        acct1.Type = 'Direct';
        acct1.Priority__c = 'Priority Prospect';
        lstAccToBeInserted.add(acct1);
        acct2.Name = '34340';
        acct2.BillingStreet = 'Test street 1';
        acct2.BillingCity = 'Toronto';
        acct2.BillingStateCode = 'ON';
        acct2.BillingCountryCode = 'CA';
        acct2.DataGovernanceStatus__c = 'Approved';
        acct2.Website = 'www.test' + Math.random() +'.us';
        acct2.Type = 'Direct';
        acct2.Priority__c = 'Priority Prospect';
        lstAccToBeInserted.add(acct2);
        insert lstAccToBeInserted;
        
        contact1.FirstName = 'tyui';
        contact1.LastName = 'iuyt';
        contact1.Description = 'Bryan Test Contact 1-2';
        contact1.Account = acct1;
        contact1.email = 'Test'+String.valueOf(system.now()).replaceAll(':', '').replaceall('-','').replaceall(' ','')+'@test.com';
        lstContactToBeInserted.add(contact1);
        contact2.FirstName = 'hjkl';
        contact2.LastName = 'lkjh';
        contact2.Description = 'Bryan Test Contact 2-2';
        contact2.Account = acct2;
        contact2.email = 'Test'+String.valueOf(system.now()).replaceAll(':', '').replaceall('-','').replaceall(' ','')+'@test0007.com';
        lstContactToBeInserted.add(contact2);
        insert lstContactToBeInserted;
        //Reseting governor limits
       
        //build the two opportunities needed
        //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        opty1 = TestUtility.createOpportunity(acct1.Id, 'test Opppy1', false);
        opty2 = TestUtility.createOpportunity(acct1.Id, 'test Opppy2', false);
        lstOppToBeInserted.add(opty1);
        lstOppToBeInserted.add(opty2);
        insert lstOppToBeInserted;
        OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(opty1.Id, testPBE, true);       
        OpportunityLineItem testOLI2 = TestUtility.createOpportunityLineItem(opty2.Id, testPBE, true);               
        opty1 = [SELECT Name, AccountId, /*Remove CustomerContact__c,*/ Amount, Opportunitynum__c FROM Opportunity WHERE Id=:opty1.Id];       
        
        opty2 = [SELECT Name, AccountId, /*Remove CustomerContact__c,*/ Amount, Opportunitynum__c FROM Opportunity WHERE Id=:opty2.Id];
        test.starttest();
        //Build the WRF using opty 1
        wrf.Name = 'rtyiuy wrf';
        wrf.OpportunityName__c = opty1.Id;
        wrf.AccountName__c = acct1.Id;
        wrf.OpportunityNumber__c = opty1.Opportunitynum__c;
        wrf.Revenue__c = opty1.Amount;
        upsert wrf;
        System.debug(wrf.OpportunityName__r.Name + ':\t' + wrf.OpportunityName__c);
        
        //Change opty name and let WRACE update the other fields
        WRACE controller = new WRACE(new ApexPages.StandardController(wrf));
        wrf.OpportunityNumber__c = opty2.Opportunitynum__c;
        upsert wrf;
        controller.lookupOpportunityByNumber();
        upsert wrf;
        
        //assertion checks to ensure it's working properly
        System.assertEquals(opty2.Id, wrf.OpportunityName__c, 'Bad opty'); //opty name here is a lookup to an opty object
        System.assertNotEquals(acct2.id, wrf.AccountName__c, 'Bad Account!');     
        System.assertEquals(opty2.Opportunitynum__c, wrf.OpportunityNumber__c, 'Bad opty #'); 
        System.assertEquals(opty2.Amount, wrf.Revenue__c, 'Bad Revenue');
        System.assertEquals(opty2.Name, wrf.Name);
        

        //Testing bad number
        wrf.OpportunityNumber__c = 'Bad opty #';
        upsert wrf;
        //resetting limits again
       
        
        //try saving this wrf that contains the bad opty number, it should fail
        System.assertEquals(null, controller.Submit(), 'Problem when saving');
        
        controller.lookupOpportunityByNumber();
        upsert wrf;
        
        //Make sure it reverts changes and points to old opty w/ its associated data
        System.assertEquals(opty2.Id, wrf.OpportunityName__c, 'Bad opty'); //opty name here is a lookup to an opty object
        System.assertNotEquals(acct2.id, wrf.AccountName__c, 'Bad Account!');     
        System.assertEquals(opty2.Opportunitynum__c, wrf.OpportunityNumber__c, 'Bad opty #'); 
        System.assertEquals(opty2.Amount, wrf.Revenue__c, 'Bad Revenue');   
        System.assertEquals(opty2.Name, wrf.Name);
        
        //Testing empty number
        wrf.OpportunityNumber__c = null;
        upsert wrf;
        controller.lookupOpportunityByNumber();
        upsert wrf;
        
        //Make sure it reverts changes and points to old opty w/ its associated data
        System.assertEquals(opty2.Id, wrf.OpportunityName__c, 'Bad opty'); //opty name here is a lookup to an opty object
        System.assertNotEquals(acct2.id, wrf.AccountName__c, 'Bad Account!');     
        System.assertEquals(opty2.Opportunitynum__c, wrf.OpportunityNumber__c, 'Bad opty #'); 
        System.assertEquals(opty2.Amount, wrf.Revenue__c, 'Bad Revenue');   
        System.assertEquals(opty2.Name, wrf.Name);
        
        test.stopTest();
        
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    @isTest public static void OpportunityWorkRequestFormTest() {
        
        WorkRequestForm__c wrf = new WorkRequestForm__c();
        Opportunity opty1 = new Opportunity();
        Opportunity opty2 = new Opportunity();
        Account acct1 = new Account();
        Account acct2 = new Account();
        Contact contact1 = new Contact();
        Contact contact2 = new Contact();
        
        //create optys and associated fields
        acct1.Name = 'something random';
        acct1.BillingStreet = 'Test street 1';
        acct1.BillingCity = 'Toronto';
        acct1.BillingStateCode = 'ON';
        acct1.BillingCountryCode = 'CA';
        acct1.DataGovernanceStatus__c = 'Approved';
        acct1.Website = 'www.test' + Math.random() +'.us';
        acct1.Type = 'Direct';
        acct1.Priority__c = 'Priority Prospect';
        insert acct1;
        
        contact1.FirstName = 'Darth';
        contact1.LastName = 'Vader';
        contact1.Description = 'Bryan Test Contact 1-2';
        contact1.Account = acct1;
        contact1.email = 'test666@test777.com';
        insert contact1;
        
        //create test data
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
         //Reset limits
        Test.startTest();
        //build the two opportunities needed
        List<Opportunity> lstOppToBeInserted = new List<Opportunity>();
        opty1 = TestUtility.createOpportunity(acct1.Id, 'test Opppy1', false);
        opty2 = TestUtility.createOpportunity(acct1.Id, 'test Opppy2', false);
        lstOppToBeInserted.add(opty1);
        lstOppToBeInserted.add(opty2);
        insert lstOppToBeInserted;
        
        List<OpportunityLineItem> lstOppLineItemToBeInserted = new List<OpportunityLineItem>();
        OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(opty1.Id, testPBE, false);
        OpportunityLineItem testOLI2 = TestUtility.createOpportunityLineItem(opty2.Id, testPBE, false);
        OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(opty1.Id, testPBE, false);
        lstOppLineItemToBeInserted.add(testOLI1);
        lstOppLineItemToBeInserted.add(testOLI2);
        lstOppLineItemToBeInserted.add(testOLI);
        insert lstOppLineItemToBeInserted;
        
        /* Remove opty1.CustomerContact__c = contact1.Id;*/
        //upsert opty1;
        
        opty1 = [SELECT Name, AccountId, /*Remove CustomerContact__c,*/ Amount, Opportunitynum__c FROM Opportunity WHERE Id=:opty1.Id];
        
        //Build the WRF using opty 1
        wrf.Name = 'Do Work';
        wrf.OpportunityName__c = opty1.Id;
        wrf.AccountName__c = acct1.Id;
        wrf.OpportunityNumber__c = opty1.Opportunitynum__c;
        wrf.Revenue__c = opty1.Amount;
        upsert wrf;
       
        //save the WRF to make sure an Opportunity Work Request Form object is saved
        WRACE controller = new WRACE(new ApexPages.StandardController(wrf));
        controller.SaveDraft();
        
        List<OpportunityWorkRequestForm__c> optyWrfs = [SELECT Opportunity__c, WorkRequestForm__c, uid__c 
                                                        FROM OpportunityWorkRequestForm__c 
                                                        WHERE Opportunity__c=:opty1.Id
                                                        AND WorkRequestForm__c=:wrf.Id];
        //One should exist 
        System.assert(optyWrfs.size() > 0, 'No OptyWrf was created!');
        
        OpportunityWorkRequestForm__c optyWrf = optyWrfs.get(0);
        System.assertNotEquals(null, optyWrf); //ensure again that it's not null
        //make sure uid populated correctly
        //The salesforce UI uses 15 digit Ids, thus the substrings
        System.assertNotEquals ( String.format( '{0}{1}', new String[] { ( ( string)opty1.Id ).substring(0, 15), ( (string)wrf.Id).substring(0, 15) } ), optyWrf.uid__c ); 
        Test.stopTest();
    }  
    
}