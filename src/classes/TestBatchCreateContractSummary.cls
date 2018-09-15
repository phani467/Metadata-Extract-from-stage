//-----------------------------
// @author: Jagadesh Kumar
// @date: 30 July 2018
// @param: NA
// @description: Test Class for BatchCreateContractSummary
// @return: NA
//----------------------------
@isTest
private class TestBatchCreateContractSummary {
	
    @isTest
    static void testApprovalContractCreation() {
        Test.startTest();
        
        List<Account> accList = new List<Account>();
        Account acc = TestUtility.createTestAccount('Account testBatchCreateContract Summary', false);
        acc.DataGovernanceStatus__c = 'Approved';
        accList.add(acc);
        Account acc2 = TestUtility.createTestAccount('Account testBatchCreateContract Summary2', false);
        acc2.DataGovernanceStatus__c = 'Approved';
        accList.add(acc2);
        insert accList;
        
        Opportunity testOpportunity = TestUtility.createOpportunity(acc.Id, 'test Opppy', true);
        ApprovedContractSummary__c acs = new ApprovedContractSummary__c();
		acs.Account__c = acc.id;
		insert acs;
        
        //creating contract
        List<ProductGroup__C> listPG = new List<ProductGroup__C>();
        ProductGroup__C pg1 = new ProductGroup__C(name = 'Test PG1');
        listPG.add(pg1);
        ProductGroup__C pg4 = new ProductGroup__C(name = 'Test PG4');
        listPG.add(pg4);
        insert listPG;
        
        List<ProfitCenter__c> listPc = new List<ProfitCenter__c>();
        ProfitCenter__c pc1 = new ProfitCenter__c(SaleType__c='Onetime');
        listPc.add(pc1);
        ProfitCenter__c pc2 = new ProfitCenter__c(SaleType__c='Subscription');
        listPc.add(pc2);
        ProfitCenter__c pc3 = new ProfitCenter__c(SaleType__c='Consulting');
        listPc.add(pc3);
        insert listPc;
        
        List<Product2> listProducts = new List<Product2>(); 
        Product2 testProd1 = TestUtility.createProduct('Test Product1', false);
        testProd1.ProductGroup__c = pg1.Id;
        testProd1.ProfitCenters__c = pc1.Id;
        listProducts.add(testProd1);
        
        Product2 testProd2 = TestUtility.createProduct('Test Product2', false);
        testProd2.ProductGroup__c = pg1.Id;
        testProd2.ProfitCenters__c = pc2.Id;
        listProducts.add(testProd2);
        
        Product2 testProd3 = TestUtility.createProduct('Test Product3', false);
        testProd3.ProductGroup__c = pg1.Id;
        testProd3.ProfitCenters__c = pc3.Id;
        listProducts.add(testProd3);
        
        Product2 testProd4 = TestUtility.createProduct('Test Product4', false);
        testProd4.ProductGroup__c = pg4.Id;
        listProducts.add(testProd4);
        
        insert listProducts;
        
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd1.Id, true);
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContractWithInsertOptional(acc.Id, legalEntity.Id, country.Id, standardId,false);
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        contract1.recordtypeid = orderFormRecordTypeId;
        contract1.ContractApproved__c = true;
        insert contract1;
        Contract contract2 = TestUtility.createContractWithInsertOptional(acc2.Id, legalEntity.Id, country.Id, standardId,false);
        contract2.recordtypeid = orderFormRecordTypeId;
        contract2.ContractApproved__c = true;
        insert contract2;
        
        // Creating the CLI
        List<ContractLineItem__c> ListCLI = new List<ContractLineItem__c>();
        ContractLineItem__c  testCLI1 = TestUtility.createContractLineItem('TestCLI1',contract1.id,testProd1.id,false);
        testCLI1.AssociatedProduct__c = testProd1.id;
        ListCLI.add(testCLI1);
        
        ContractLineItem__c  testCLI2 = TestUtility.createContractLineItem('TestCLI2',contract1.id,testProd2.id,false);
        testCLI2.AssociatedProduct__c = testProd2.id;
        ListCLI.add(testCLI2);
        
        ContractLineItem__c  testCLI3 = TestUtility.createContractLineItem('TestCLI3',contract1.id,testProd3.id,false);
        testCLI3.AssociatedProduct__c = testProd3.id;
        ListCLI.add(testCLI3);
        
        ContractLineItem__c  testCLI4 = TestUtility.createContractLineItem('TestCLI4',contract2.id,testProd4.id,false);
        testCLI4.AssociatedProduct__c = testProd4.id;
        ListCLI.add(testCLI4);
        
        insert ListCLI;
        
        // Creating the CLIS
        List<ContractLineItemSchedule__c> listCLIS = new List<ContractLineItemSchedule__c>();
        String CURRENTYEAR = String.valueOf(System.today().year());
        ContractLineItemSchedule__c CLIS1 = TestUtility.createContractLineItemSchedule(contract1.id,testCLI1.Id,false);
        CLIS1.InstallmentYear__c = CURRENTYEAR;
        CLIS1.SalesPrice__c = 10000.00;
        listCLIS.add(CLIS1);
        
        ContractLineItemSchedule__c CLIS2 = TestUtility.createContractLineItemSchedule(contract1.id,testCLI2.Id,false);
        CLIS2.InstallmentYear__c = CURRENTYEAR;
        CLIS2.SalesPrice__c = 10000.00;
        listCLIS.add(CLIS2);
        ContractLineItemSchedule__c CLIS3 = TestUtility.createContractLineItemSchedule(contract1.id,testCLI3.Id,false);
        CLIS3.InstallmentYear__c = CURRENTYEAR;
        CLIS3.SalesPrice__c = 10000.00;
        listCLIS.add(CLIS3);
        
        ContractLineItemSchedule__c CLIS4 = TestUtility.createContractLineItemSchedule(contract2.id,testCLI4.Id,false);
        CLIS4.InstallmentYear__c = CURRENTYEAR+1;
        CLIS4.SalesPrice__c = 10000.00;
        listCLIS.add(CLIS4);
        
        insert listCLIS;
        
        String jobId = system.schedule('TestBatchCreateContractSummary2', '0 0 0 3 9 ? 2022' , new BatchCreateContractSummaryScheduler());
        String batchId = Database.executeBatch(new BatchUpdateOpportunityPrimaryContact(),2);
        Test.stopTest();
		List<ApprovedContractSummary__c> assertACS = [Select id,key__c from ApprovedContractSummary__c];
        System.debug('--assertACS--'+assertACS);
		System.assert(assertACS.size()>0);
    }
}