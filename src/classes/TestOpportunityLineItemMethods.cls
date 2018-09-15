//-----------------------------
// @author: Sruti Srivastava
// @date: 9th April 2018
// @param: NA
// @description: Test class for Opportunity line item trigger methods 
//------------------- 
@isTest
private class TestOpportunityLineItemMethods {
	 //
     // @author : Sruti Srivastava
     //@date : 11th April 2018
     // @description SFDC1-7027- test setup method, creating test data
     // @lastmodifiedSprint : Sprint 23
     // @modified by: Paras Dhingra
     // @modified date: 12th Apr 2019
     // @modified reason: SFDC1-7525 adding more attributes to product
     //
     // @modified by: Paras Dhingra
     // @modified date: 12th Apr 2019
     // @modified reason: SFDC1-8222 addiing more data to product schedules
     //
    @testSetup static void setup() {
        //adding more atttributes to product
        ProfitCenter__c testProfitCenter = new ProfitCenter__c(Name='UP - Energy', Active__c=true, ProfitCenterCode__c='187');
        insert testProfitCenter;
        Family__c testProdFam = new Family__c(Name='ETC-C&A',Status__c ='Active');
        insert testProdFam;
        ProductGroup__c pg = TestUtility.createProductGroup('MRO',false,false);//SFDC1-5228 JK- New
        //create test data
		Product2 testProd = TestUtility.createProduct('Test Product', false);
		testProd.FormerIpOwner__c = 'IHS Markit Global Inc.';
		testProd.Family__c = testProdFam.Id;
		testProd.ProfitCenters__c = testProfitCenter.Id;
        testProd.ProductGroup__c = pg.Id;//SFDC1-5228 JK- New
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
        insert testOpportunity;
         
		OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, true);
		ProductSchedule__c ps1 = TestUtility.createProductSchedule(2223.23, String.valueof(currentFY), '3 Years', String.valueof(currentFY), testProd.Id, false);
        ProductSchedule__c ps2 = TestUtility.createProductSchedule(2323.23, String.valueof(currentFY), '3 Years', String.valueof(currentFY+1), testProd.Id, false);
        ProductSchedule__c ps3 = TestUtility.createProductSchedule(2423.23, String.valueof(currentFY), '3 Years', String.valueof(currentFY+2), testProd.Id, false);
        //insert product schedule for 2018 financial year
        ProductSchedule__c ps4 = TestUtility.createProductSchedule(2223.23, String.valueof(nextFY), '3 Years', String.valueof(nextFY), testProd.Id, false);
        ProductSchedule__c ps5 = TestUtility.createProductSchedule(2223.23, String.valueof(nextFY), '3 Years', String.valueof(nextFY+1), testProd.Id, false);
        ProductSchedule__c ps6 = TestUtility.createProductSchedule(2223.23, String.valueof(nextFY), '3 Years', String.valueof(nextFY+2), testProd.Id, false);
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
		
    }
    /**
     * @author : Sruti Srivastava
     * @date : 9th April 2018
     * @description SFDC1-7027- Test method for verifying Contract Start Date and End Date on Opportunity Line Items 
     * are auto-populated on create
     * @lastmodifiedSprint : Sprint 23
     */
     static testMethod void testPopulateContractStartDateAndEndDate() { 
		Opportunity testOpportunity = TestUtility.createOpportunity([Select Id From Account limit 1].Id, 'test Opppy', false);
		insert testOpportunity;

		Test.startTest();
		OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(testOpportunity.Id, [select Id, UnitPrice FROM PricebookEntry limit 1], false);
		testOLI1.ContractStartDate__c = Date.Today().addDays(-30);
		testOLI1.ContractEndDate__c = Date.Today().addDays(30);
		insert testOLI1;
		
		//Verifying if Contract start Date and End date are correctly populated as null from opportunity
		System.assertEquals(null, [select ContractStartDate__c From OpportunityLineItem where Id= :testOLI1.Id limit 1].ContractStartDate__c,'Checking if ContractStartDate__c on OLI is correctly populated');
		System.assertEquals(null, [select ContractEndDate__c From OpportunityLineItem where Id= :testOLI1.Id limit 1].ContractEndDate__c,'Checking if ContractEndDate__c on OLI is correctly populated');

		testOpportunity.ContractStartDate__c = Date.Today().addDays(-30);
		testOpportunity.ContractEndDate__c = Date.Today().addDays(30);
		update testOpportunity;
		OpportunityLineItem testtestOLI= TestUtility.createOpportunityLineItem(testOpportunity.Id, [select Id, UnitPrice FROM PricebookEntry limit 1], true);
		//Verifying if Contract start Date and End date are correctly populated from opportunity
		System.assertEquals(testOpportunity.ContractStartDate__c, [select ContractStartDate__c From OpportunityLineItem where Id= :testtestOLI.Id limit 1].ContractStartDate__c,'Checking if ContractStartDate__c on OLI is correctly populated');
		System.assertEquals(testOpportunity.ContractEndDate__c, [select ContractEndDate__c From OpportunityLineItem where Id= :testtestOLI.Id limit 1].ContractEndDate__c,'Checking if ContractEndDate__c on OLI is correctly populated');
		Test.stopTest();
	}
    
    /**
     * @author : Sruti Srivastava
     * @date : 9th April 2018
     * @description SFDC1-7027- Test method for verifying Contract Start Date and End Date on Opportunity Line Items on update
     * are auto-populated on create
     * @lastmodifiedSprint : Sprint 23
     */
     static testMethod void testPopulateContractStartDateAndEndDateonUpdate() { 
		OpportunityLineItem testOLI = [Select Id, OpportunityId from OpportunityLineItem limit 1];
        
		Test.startTest();
		testOLI.ContractStartDate__c = Date.Today();
		update testOLI;
        Test.stopTest();
         
		//Verifying if Contract start Date and End date are correctly populated from opportunity
		System.assertEquals(Date.Today(), [select ContractStartDate__c From OpportunityLineItem where Id= :testOLI.Id limit 1].ContractStartDate__c,'Checking if ContractStartDate__c on OLI is correctly populated');
		System.assertEquals([Select Id, ContractEndDate__c from Opportunity limit 1].ContractEndDate__c, [select ContractEndDate__c From OpportunityLineItem 
                                                                 where Id= :testOLI.Id limit 1].ContractEndDate__c,'Checking if ContractEndDate__c on OLI is correctly populated');
	}
      //
      //@author : Paras Dhingra
      //@date : 10th Apr 2018
      //@description : SFDC1-7525 Test class for OpportunityLineItemMethods.rollupProductInfoToOpportunity
      //@param : TriggerParameters
      //@return : void
      //@companyname : IHS Markit
      //
      private static testMethod Void testRollupProductInfoToOpportunity() {
          Test.startTest();
          //assert on insert of opportunity lineItem
          Opportunity assertOpportunity = [Select Id, AccountId, ProfitCenter__c, ProductFamily__c,FormerIP__c,(Select id from OpportunityLineItems) from Opportunity where name='test Opppy' ];
          System.assertEquals('UP - Energy', assertOpportunity.ProfitCenter__c);
          System.assertEquals('IHS Markit Global Inc.', assertOpportunity.FormerIP__c);
          System.assertEquals('ETC-C&A', assertOpportunity.ProductFamily__c);
          
          //SFDC1-5228 JK :New
          Product2 testProd1 = TestUtility.createProduct('Test Product1', true);
          Id standardId = Test.getStandardPricebookId();
          PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd1.Id, true);
          LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
          List<Country__c> lstCountry = TestUtility.loadCountryData();
          Country__c country = lstCountry.get(0);
          Contract contract1 = TestUtility.createContractWithInsertOptional(assertOpportunity.AccountId, legalEntity.Id, country.Id, standardId,false);
          Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
          contract1.recordtypeid = orderFormRecordTypeId;
          contract1.ContractApproved__c = true;
          contract1.Opportunity__c = assertOpportunity.Id;
          insert contract1;
          
          //update product family and then update opportunity line item
          Family__c testProdFam = [Select id, name from Family__c where name='ETC-C&A'];
          testProdFam.name = 'ETC-C&A test';
          update testProdFam;
          //update opportunityLineItem
          assertOpportunity.OpportunityLineItems[0].UnitPrice = 232;
          update assertOpportunity.OpportunityLineItems;
          Opportunity assertOpportunity2 = [Select Id, ProductFamily__c,ProductGroup__c from Opportunity where name='test Opppy' ]; //SFDC1-5228 JK- Change
          System.assertEquals('ETC-C&A test', assertOpportunity2.ProductFamily__c);
          System.assertEquals('MRO', assertOpportunity2.ProductGroup__c);//SFDC1-5228 JK- New
          Contract assertc1 = [Select Id,ProductGroup__c from Contract Where Id =: contract1.Id];//SFDC1-5228 JK- New
          System.assertEquals('MRO', assertc1.ProductGroup__c);//SFDC1-5228 JK- New
          Test.stopTest();
          
          
      }
      //
      //@author : Paras Dhingra
      //@date : 10th Apr 2018
      //@description : SFDC1-7525 Test class for OpportunityLineItemMethods.rollupProductInfoToOpportunity
      //@param : TriggerParameters
      //@return : void
      //@companyname : IHS Markit
      //
      private static testMethod void testDeleteChildOpportunityLineItemSchedules() {
          Test.startTest();
          Opportunity assertOpportunity = [Select Id, (Select id from OpportunityLineItems) from Opportunity where name='test Opppy' ];
          Id opportunityProductId = assertOpportunity.OpportunityLineItems[0].Id;
          List<OpportunityLineItemSchedule__c> assertOLIS = [Select Id, OpportunityProductId__c from OpportunityLineItemSchedule__c where OpportunityProductId__c=:opportunityProductId];
          System.assertEquals(3,assertOLIS.size());
          //now delete opportunity product;
          OpportunityLineItem deleteOppyProduct = new OpportunityLineItem(Id=opportunityProductId);
          delete deleteOppyProduct;
          assertOLIS = [Select Id, OpportunityProductId__c from OpportunityLineItemSchedule__c where OpportunityProductId__c=:opportunityProductId];
          //assert that Opportunity product schedules have been deleted
          System.assertEquals(0,assertOLIS.size());
          Test.stopTest();
          
      }
      
      
      //
      //@author : Mohit Modi
      //@date : 23 Apr 2018
      //@description : SFDC1-5722 Test class for OpportunityLineItemMethods.preventOpportunityLineItemDeletion
      //@param : TriggerParameters
      //@return : void
      //@companyname : Vertiba
      //
      private static testMethod void testpreventOpportunityLineItemDeletion() {
          User testUser1 = TestUtility.createTestUser('IHSMarkit Sales: Sales Ops', 'testusername'+string.valueof(system.now()).replace('-','').replace(':','').replaceall(' ','')+'@test.com',true);
          Test.startTest();
          System.runas(testUser1) {
              Opportunity assertOpportunity = [Select Id, (Select id from OpportunityLineItems) from Opportunity where name='test Opppy' ];
              
              Id opportunityProductId = assertOpportunity.OpportunityLineItems[0].Id;
              
              try {
              delete new OpportunitylineItem (id = opportunityProductId );
              } catch (exception ex) {
                  boolean errorexist = ex.getmessage().contains('You are not authorized to delete Opportunity Products') ? true : false;
                  System.assertEquals(errorexist ,true);
              }
          }
          Test.stopTest();
          
      }
      //
      //@author : Paras Dhingra
      //@date : 05th Jun 2018
      //@description : SFDC1-7028 Test class for OpportunityLineItemMethods.updateChildSchedulesOnContractDateChange
      //               and ProductEditController.proRateBeforeInsert
      //@return : void
      //@companyname : IHS Markit
      //
      /* to be uncommented for phase 1.3
      private static testMethod void testUpdateChildSchedulesOnContractDateChange() {
          //update test data
          ProfitCenter__c profitCenter = [Select id, SaleType__c from ProfitCenter__c where name='UP - Energy'];
          profitCenter.SaleType__c = 'Subscription';
          update profitCenter;
          //pro-rate existing opportunity products
          List<Opportunity> lstOpportunity = [Select Id, ContractStartDate__c, ContractEndDate__c, (Select id, DiscountPercent__c, DiscountAmount__c, DiscountType__c, ExternalListPrice__c,
                                                                    InstallmentYears__c, OpportunityProductId__c, PriceBookListPrice__c, Quantity__c, SalesPrice__c,
                                                                    TotalPrice__c,Status__c, AnnualizedUnitPrice__c, AnnualizedDiscountAmount__c,
                                                                    ProRatedUnitPrice__c, ProRatedDiscountAmount__c from OpportunityProductSchedules__r),
                                                                    (Select id, isProRated__c,ProductType__c from OpportunityLineItems)
                                                                    from Opportunity where name='test Opppy'];
          
          Test.startTest();
          //update the opportunity line item to be pro-rated
          for(OpportunityLineItem oli : lstOpportunity[0].OpportunityLineItems) {
            oli.IsProRated__c = 'Yes';
            oli.Status__c = 'New';
          }
          update lstOpportunity[0].OpportunityLineItems;
          for(OpportunityLineItemSchedule__c olis: lstOpportunity[0].OpportunityProductSchedules__r) {
            olis.DiscountAmount__c = 200.00;
            olis = ProductEditController.proRateBeforeInsert(olis, lstOpportunity[0], olis.Quantity__c);
          }
          update lstOpportunity[0].OpportunityProductSchedules__r;
          //assert to check proration happened or not
          List<Opportunity> assertLstOpportunity =  [Select Id, ContractStartDate__c, ContractEndDate__c, (Select id, DiscountPercent__c, DiscountAmount__c, DiscountType__c, ExternalListPrice__c,
                                                                    InstallmentYears__c, OpportunityProductId__c, PriceBookListPrice__c, Quantity__c, SalesPrice__c,
                                                                    TotalPrice__c,Status__c, AnnualizedUnitPrice__c, AnnualizedDiscountAmount__c,
                                                                    ProRatedUnitPrice__c, ProRatedDiscountAmount__c from OpportunityProductSchedules__r),
                                                                    (Select id, ContractStartDate__c, ContractEndDate__c from OpportunityLineItems)
                                                                    from Opportunity where name='test Opppy'];
          for(OpportunityLineItemSchedule__c olis: assertLstOpportunity[0].OpportunityProductSchedules__r) {
            System.assertEquals(olis.ProRatedUnitPrice__c,olis.ExternalListPrice__c);
            System.assertEquals(olis.ProRatedDiscountAmount__c,olis.DiscountAmount__c);
            System.assertEquals(olis.SalesPrice__c,(olis.ProRatedUnitPrice__c - olis.ProRatedDiscountAmount__c));
            System.assertNotEquals(olis.AnnualizedUnitPrice__c,null);
            System.assertNotEquals(olis.AnnualizedDiscountAmount__c,null);
          }
          // check when contract start date and end date re-calculates pro-ration
          List<OpportunityLineItem> updatedOLI = new List<OpportunityLineItem>();
          for(OpportunityLineItem oli : assertLstOpportunity[0].OpportunityLineItems) {
              oli.ContractStartDate__c = Date.Today().addDays(-5);
              updatedOLI.add(oli);
          }

          GlobalConstants.preventOpportunityProductScheduleUpdate = false;
          update updatedOLI;
          assertLstOpportunity =  [Select Id, ContractStartDate__c, ContractEndDate__c, (Select id, DiscountPercent__c, DiscountAmount__c, DiscountType__c, ExternalListPrice__c,
                                                                    InstallmentYears__c, OpportunityProductId__c, PriceBookListPrice__c, Quantity__c, SalesPrice__c,
                                                                    TotalPrice__c,Status__c, AnnualizedUnitPrice__c, AnnualizedDiscountAmount__c,
                                                                    ProRatedUnitPrice__c, ProRatedDiscountAmount__c from OpportunityProductSchedules__r),
                                                                    (Select id, ContractStartDate__c, ContractEndDate__c from OpportunityLineItems)
                                                                    from Opportunity where name='test Opppy'];
          for(OpportunityLineItemSchedule__c olis: assertLstOpportunity[0].OpportunityProductSchedules__r) {
            System.assertEquals(olis.ProRatedUnitPrice__c,olis.ExternalListPrice__c);
            System.assertEquals(olis.ProRatedDiscountAmount__c,olis.DiscountAmount__c);
            System.assertEquals(olis.SalesPrice__c,(olis.ProRatedUnitPrice__c - olis.ProRatedDiscountAmount__c));
            System.assertNotEquals(olis.AnnualizedUnitPrice__c,null);
            System.assertNotEquals(olis.AnnualizedDiscountAmount__c,null);
          }
          Test.stopTest();
          
      }*/
       //
      //@author : Paras Dhingra
      //@date : 05th Jun 2018
      //@description : SFDC1-7028 Test class for OpportunityLineItemMethods.updateChildSchedulesOnContractDateChange fiscal year change
      //@return : void
      //@companyname : IHS Markit
      //
      private static testMethod void testUpdateChildSchedulesOnContractDateChangeFiscalChange() {
        //query opportunity and its related lineitem and schedules
        Integer currentFY = UtilityClass.calculateFyFromDate(Date.Today(), UtilityClass.FiscalStartMonth);
        Integer nextFY = currentFY+1;
        List<Opportunity> lstOpportunity = [Select id, (Select id,ContractStartDate__c,ContractEndDate__c from OpportunityLineItems )
                                            ,(Select Id, ProductSchedule__c, ProductSchedule__r.PricingYear__c,
                                                Opportunity__c from OpportunityProductSchedules__r ) 
                                                from Opportunity where name = 'test Opppy' ];
        Test.startTest();
        //assert the pricing year of product schedules
        for(OpportunityLineItemSchedule__c ops : lstOpportunity[0].OpportunityProductSchedules__r) {
          System.assertEquals(String.valueOf(currentFY), ops.ProductSchedule__r.PricingYear__c);
        }
        //update contract start date and end date of opportunity line item
        lstOpportunity[0].OpportunityLineItems[0].ContractStartDate__c = date.newinstance(nextFY, 03,21 );
		lstOpportunity[0].OpportunityLineItems[0].ContractEndDate__c = date.newinstance(nextFY, 10, 21);
		update lstOpportunity[0].OpportunityLineItems;
		List<Opportunity> assertLstOpportunity = [Select id,(Select id,ContractStartDate__c,ContractEndDate__c from OpportunityLineItems ),
	                                            (Select Id, ProductSchedule__c, ProductSchedule__r.PricingYear__c,
                                                Opportunity__c from OpportunityProductSchedules__r ) 
                                                from Opportunity where name = 'test Opppy' ];
        for(OpportunityLineItemSchedule__c ops : assertLstOpportunity[0].OpportunityProductSchedules__r) {
          System.assertEquals(String.valueOf(nextFY), ops.ProductSchedule__r.PricingYear__c);
        }
        //remove contract start date and end date from lineitem and the fiscal will go to opportunity start date
        assertLstOpportunity[0].OpportunityLineItems[0].ContractStartDate__c = null;
		assertLstOpportunity[0].OpportunityLineItems[0].ContractEndDate__c = null;
		GlobalConstants.preventOpportunityProductScheduleUpdate=false;
		update assertLstOpportunity[0].OpportunityLineItems;
		assertLstOpportunity = [Select id,(Select Id, ProductSchedule__c, ProductSchedule__r.PricingYear__c,
                                                Opportunity__c from OpportunityProductSchedules__r ) 
                                                from Opportunity where name = 'test Opppy' ];
        for(OpportunityLineItemSchedule__c ops : assertLstOpportunity[0].OpportunityProductSchedules__r) {
          System.assertEquals(String.valueOf(currentFY), ops.ProductSchedule__r.PricingYear__c);
        }
        Test.stopTest();
      }
      
      //
      //@author : Paras Dhingra
      //@date : 24th July 2018
      //@description : SFDC1-7060 Test class for OpportunityLineItemMethods.OppyProductValidations
      //@return : void
      //@companyname : IHS Markit
      //
      private static testMethod void testOppyProductValidations() {
          //add custom setting data     
        OpportunityValidationFields__c ofv2 = new OpportunityValidationFields__c(Name='Discount Type OP',APIName__c='DiscountType__c',RuleName__c='AutoRenewNoChangesOppyProduct');
        insert new List<OpportunityValidationFields__c>{ofv2};
        List<Opportunity> lstOpportunity = [Select id,AutoRenewal__c, (Select id,ContractStartDate__c,ContractEndDate__c from OpportunityLineItems )
                                            ,(Select Id, ProductSchedule__c, ProductSchedule__r.PricingYear__c,
                                                Opportunity__c from OpportunityProductSchedules__r ) 
                                                from Opportunity where name = 'test Opppy' ];
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
            lstOpportunity[0].ownerId = testUser.Id;
            //convert the opportunity to auto renewal 
            lstOpportunity[0].AutoRenewal__c = true;
            System.debug('@PD--updating opportunity');
            update lstOpportunity[0];
        }
        Test.startTest();
        GlobalConstants.preventOpportunityProductScheduleUpdate=false;
        GlobalConstants.hasTriggeredFromOpportunityProduct= false;
        GlobalConstants.hasBeenValidatedOnce = false;
        System.runAs(testUser) {
            //test positive test case
            OpportunityLineItem oli = lstOpportunity[0].OpportunityLineItems[0];
            oli.DiscountType__c='Percentage';
            UtilityClass.LoggedInUserProfileName = null;
            System.debug('@PD--updating opportunity line item');
            update oli;
            //test negative test case
            try {
                    oli.NumberofConcurrentUsersSeats__c = 10;
                    update oli;
                    System.assert(false,'Control will not reach here');
              } 
              catch (exception ex) {
                  Boolean errorexist = ex.getmessage().contains(System.Label.AutoRenewHasChangesOppyError) ? true : false;
                  System.assertEquals(errorexist ,true);
              }
        }
        Test.stopTest();
      }
}