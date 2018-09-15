//------------------------------------------------
// @author: Vertiba
// @company: VERTIBA
// @date: 13 Dec 2017
// @description:  SFDC1-5326 -Opportunity Behavior - when a Future Disconnect Product is on the Oppy.
// @return: 
// @Last Updated: 25 May 2018:Anjani Shukla : SFDC1-8147- New Cross Plat Status Addition for Renewal Opty
//------------------------------------------------
@isTest
public class TestWarningMsgProductCrossPlantStatus {
	//-----------------------------
    // @author: Veriba
    // @company: VERTIBA
    // @date: 14 Dec 2017
    // @param: 
    // @description:  Test method to check if functionality is working.
    // @return: NA
    // @Modification : Updated code for new methods added for edit fucntionality.
    // @Modification date : Anjani Shukla:14 Dec 2017
    //-----------------------------
    public static testMethod void testNoWarningNotification() {
        test.startTest();
            Account acnt = TestUtility.createTestAccountWithStreet('SFDC1-5326-OpporunityCrossPlantStatus','Test1',true);        	
        	CrossPlantStatus__c availableProd = new CrossPlantStatus__c();
            availableProd.Name='Available for Sale';
        	availableProd.SAPCode__c ='04';
        	availableProd.Status__c ='Active';
            insert availableProd;
        	Product2 testProd = TestUtility.createProduct('Test Product', true); 
            testProd.ProductStatus__c = availableProd.id;
            update testProd;
            Id standardId = Test.getStandardPricebookId();
            PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        	LegalEntity__c testLegalEntity = TestUtility.createLegalEntity('Test Legal Entity', 'USD');
            Opportunity o = TestUtility.createOpportunity(acnt.Id, 'test Opppy1', true);
            OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(o.Id, testPBE, true);
        	//List<sObject> testCrossPlantStatus = TestUtility.loadCrossPlantStatus();
        	List<String> lstforRecord = new List<String>();
        	//lstforRecord.add(testOLI1.name);
        	// test functionality.
        	WarningMsgProductCrossPlantStatus objWarnMsgProdCrossPlantStatus = new WarningMsgProductCrossPlantStatus();
        	WarningMsgProductCrossPlantStatus.getOptyProdLineDetails(o.id);
        	WarningMsgProductCrossPlantStatus.errorMsgRecord = lstforRecord;
            system.assertEquals(0, lstforRecord.size());
        test.stopTest(); 	
    }

	//-----------------------------
    // @author: Veriba
    // @company: VERTIBA
    // @date: 14 Dec 2017
    // @param: 
    // @description:  Test method to check if functionality is working.
    // @return: NA
    // @Modification : Updated code for new methods added for edit fucntionality.
    // @Modification date : Anjani Shukla:14 Dec 2017
    //-----------------------------
    public static testMethod void testWarningNotificationErrorMsg() {
        test.startTest();
            Account acnt = TestUtility.createTestAccountWithStreet('SFDC1-5326-OpporunityCrossPlantStatus','Test1',true);  
            CrossPlantStatus__c notavailableProd = new CrossPlantStatus__c();
            notavailableProd.Name='Discntnd w/o Rplcmnt';
        	notavailableProd.SAPCode__c ='05';
        	notavailableProd.Status__c ='Active';
            insert notavailableProd;
        	Product2 testProd = TestUtility.createProduct('Test Product', true); 
            testProd.ProductStatus__c = notavailableProd.id;
            update testProd;
            Id standardId = Test.getStandardPricebookId();
            PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        	LegalEntity__c testLegalEntity = TestUtility.createLegalEntity('Test Legal Entity', 'USD');
            Opportunity o = TestUtility.createOpportunity(acnt.Id, 'test Opppy1', true);
            OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(o.Id, testPBE, true);
        	List<sObject> testCrossPlantStatus = TestUtility.loadCrossPlantStatus();            
        	List<String> lstforRecord = new List<String>();
        	lstforRecord.add(testOLI1.name);
        	// test functionality.
        	WarningMsgProductCrossPlantStatus objWarnMsgProdCrossPlantStatus = new WarningMsgProductCrossPlantStatus();
        	WarningMsgProductCrossPlantStatus.getOptyProdLineDetails(o.id);
        	WarningMsgProductCrossPlantStatus.errorMsgRecord = lstforRecord;
            system.assertEquals(1, lstforRecord.size());
        test.stopTest(); 	
    }

	//-----------------------------
    // @author: Veriba
    // @company: VERTIBA
    // @date: 25 May 2018
    // @param: 
    // @description:  Test method to check if functionality is working.
    // @return: NA
    // @Modification : Updated code for new methods added for edit fucntionality.
    // @Modification date : Anjani Shukla:25 May 2018 - SFDC1-8147 - New Cross Plant Status Added.
    //-----------------------------
    public static testMethod void testNoWarningNotificationForRenewal() {
        test.startTest();
            Account acnt = TestUtility.createTestAccountWithStreet('SFDC1-5326-OpporunityCrossPlantStatus','Test1',true);        	
        	CrossPlantStatus__c availableProd = new CrossPlantStatus__c();
            availableProd.Name='Available for Sale';
        	availableProd.SAPCode__c ='05';
        	availableProd.Status__c ='Active';
            insert availableProd;
        	Product2 testProd = TestUtility.createProduct('Test Product', true); 
            testProd.ProductStatus__c = availableProd.id;
            update testProd;
            Id standardId = Test.getStandardPricebookId();
            PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        	LegalEntity__c testLegalEntity = TestUtility.createLegalEntity('Test Legal Entity', 'USD');
            Opportunity o = TestUtility.createOpportunity(acnt.Id, 'test Opppy1', true);
            OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(o.Id, testPBE, true);
        	//List<sObject> testCrossPlantStatus = TestUtility.loadCrossPlantStatus();
        	List<String> lstforRecord = new List<String>();
        	//lstforRecord.add(testOLI1.name);
        	// test functionality.
        	WarningMsgProductCrossPlantStatus objWarnMsgProdCrossPlantStatus = new WarningMsgProductCrossPlantStatus();
        	WarningMsgProductCrossPlantStatus.getOptyProdLineDetails(o.id);
        	WarningMsgProductCrossPlantStatus.errorMsgRecord = lstforRecord;
            system.assertEquals(0, lstforRecord.size());
        test.stopTest(); 	
    } 
    
    //-----------------------------
    // @author: Veriba
    // @company: VERTIBA
    // @date: 25 May 2018
    // @param: 
    // @description:  Test method to check if functionality is working.
    // @return: NA
    // @Modification : Updated code for new methods added for edit fucntionality.
    // @Modification date : Anjani Shukla:25 May 2018 - SFDC1-8147 - New Cross Plant Status Added.
    //-----------------------------
    public static testMethod void testWarningNotificationForRenewal() {
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
        Opportunity testOpportunity = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', false);
        testOpportunity.TotalDaysOfContinuation__c = 30;
        testOpportunity.ContractStartDate__c = System.Today();
        testOpportunity.ContractEndDate__c = System.Today()+30;
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
        Contract contract = TestUtility.createContractWithInsertOptional(testAccount.Id, legalEntity.Id, country.Id, standardId,FALSE);
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        contract.recordtypeid = orderFormRecordTypeId;
        insert contract;
        //creating an Opportunity 
        Id ofRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        Id OppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        //Opportunity testOpportunity = [SELECT Id,stageName FROM Opportunity WHERE Name='test Opppy' LIMIT 1];
        testOpportunity.ContractStartDate__c = System.today();
        testOpportunity.ContractEndDate__c = System.today().addDays(30);
        testOpportunity.CloseDate = System.today().addDays(35);
        testOpportunity.ActivityCreated__c = true;
        testOpportunity.RecordTypeId = OppRecordTypeId;
        testOpportunity.ContractBeingRenewed__c = contract.Id;
        update testOpportunity;
        
        
        OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(testOpportunity.Id, testPBE, true);
        	//List<sObject> testCrossPlantStatus = TestUtility.loadCrossPlantStatus();
        	List<String> lstforRecord = new List<String>();
        	//lstforRecord.add(testOLI1.name);
        	// test functionality.
        	WarningMsgProductCrossPlantStatus objWarnMsgProdCrossPlantStatus = new WarningMsgProductCrossPlantStatus();
        	WarningMsgProductCrossPlantStatus.getOptyProdLineDetails(testOpportunity.id);
        	WarningMsgProductCrossPlantStatus.errorMsgRecord = lstforRecord;
            system.assertEquals(0, lstforRecord.size());        
        Test.stopTest(); 	
    } 
}