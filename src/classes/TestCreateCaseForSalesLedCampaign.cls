//-----------------------------
// @author: Hemant Shukla
// @date: 12-oct-2017
// @param: NA
// @description: Test class for CreateCaseForSalesLedCampaign class. SFDC1-4630, This class is used to create Case when Opportunity gets closes and it has Sales Led Commissionable campaign
// @Last Modified By : Hemant Shukla
// @Last Modified Description : Removed the dependency of ContractExists__c field based on SFDC1-5701
// @Last Modified Date : 6-Nov-2017
// @Last Modified By : Prachi Bhasin
// @Last Modified Date: 20 Dec 2017 Sprint 15
// @Last Modified Description: SFDC1-6411, Test class fix for OpportunityMethods class update
// @Last Modified By : Sruti Srivastava
// @Last Modified Date: 25 June 2018
// @Last Modified Description: Test class fixes
// 
// @Last Modified By : Vishnu Vardhan Chowdary Andra
// @Last Modified Date: 08 Aug 2018
// @Last Modified Description: Code is deleted/commented out as part of stories SFDC1-9677/78/80/81/82/83/84.
// 		Accordingly commenting out test class. 
//-----------------------------

@isTest
public class TestCreateCaseForSalesLedCampaign {
    
    
    
    //-----------------------------
    // @author Hemant Shukla
    // @date 12-oct-2017
    // @description SFDC1-4630, test method for createCase method
    // @param NA
    // @lastmodified description: Primary Contact roles needs to be created before updating opprtunity to stage 3 and above as per  SFDC1-5782 AND SFDC1-5029
    // @modifiedBy: Ankita Singh on 5th December,2017
    // @lastmodified description: Removing Internal partner record types and changing it to Sales Support and also account Name.
    // @modifiedBy: Vishnu Vardhan on 4th April,2018, SFDC1-7120
    // @modifiedBy: sruti srivastava on 25th june,2018, test class fixes
    //-----------------------------
    
    static testMethod void testCreateCase() {
    
        //create test data
        /*Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        Account testAccount = TestUtility.createTestAccount('IHS Markit', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        
        Contact testcontact1 = TestUtility.createContact(testAccount.id, 'h@ihsmarkit.com', true, 'h', 's');
        Contact testcontact2 = TestUtility.createContact(testAccount.id, 'p@ihsmarkit.com', true, 'p', 't');
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Contract contract1 = TestUtility.createContract(testAccount.Id, legalEntity.Id, country.Id, standardId);
        
        
        Id newBusinessRecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('New Business').getRecordTypeId();
        Id renewalRecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
        Contract contract = TestUtility.createContractWithInsertOptional(testAccount.Id, legalEntity.Id, country.Id, standardId,FALSE);
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        contract.recordtypeid = orderFormRecordTypeId;
        insert contract;
        
        List<Opportunity> listOpportunities = new List<Opportunity>();
        //create related opportunity
        Opportunity testOpportunity1 = TestUtility.createOpportunity(testAccount.Id, 'test Opppy1', false);
        testOpportunity1.RecordTypeId = newBusinessRecordTypeId;
        testOpportunity1.StageName= '1-Sales Qualified';
        listOpportunities.add(testOpportunity1);
        
        Opportunity testOpportunity2 = TestUtility.createOpportunity(testAccount.Id, 'test Opppy2', false);
        testOpportunity2.RecordTypeId = renewalRecordTypeId;
        testOpportunity2.StageName= '3-Renewal Pending';
        testOpportunity2.ContractBeingRenewed__c = contract.Id;
        listOpportunities.add(testOpportunity2);
        
        insert listOpportunities;
        List<OpportunityLineItem> listOpportunityLineItem = new List<OpportunityLineItem>();
        OpportunityLineItem testOLI1 = TestUtility.createOpportunityLineItem(listOpportunities[0].Id, testPBE, false);
        OpportunityLineItem testOLI2 = TestUtility.createOpportunityLineItem(listOpportunities[1].Id, testPBE, false);
        listOpportunityLineItem.add(testOLI1);
        listOpportunityLineItem.add(testOLI2);
        insert listOpportunityLineItem;
        
        List<Campaign> lstCampaigns = new List<Campaign>();
        Campaign testCampaign1 = new Campaign(Name='test campaign1', 
                                              IsActive = true,
                                              Status = 'In Progress',
                                              startdate = System.today() - 30,
                                              EndDate = System.today() + 30,
                                              Type = 'Sales Led',
                                              Commissionable__c = true);
                                              
        Campaign testCampaign2 = new Campaign(Name='test campaign1', 
                                              IsActive = true,
                                              Status = 'In Progress',
                                              startdate = System.today() - 30,
                                              EndDate = System.today() + 30,
                                              Type = 'Sales Led',
                                              Commissionable__c = true);                                      
        
        lstCampaigns.add(testCampaign1);
        lstCampaigns.add(testCampaign2);
        
        insert lstCampaigns;
        System.assertEquals(2, [select id from Campaign].size());
        
        Id CIMId = [Select Id from CampaignInfluenceModel where IsDefaultModel = true].Id;
        
        list<CampaignInfluence> lstCI = New List<CampaignInfluence>();
        CampaignInfluence ci1 = new CampaignInfluence(CampaignId = testCampaign1.id,
                                                      ContactId = testcontact1.id,
                                                      OpportunityId = testOpportunity1.id,
                                                      ModelId = CIMId
                                                      );
                                                      
        CampaignInfluence ci2 = new CampaignInfluence(CampaignId = testCampaign2.id,
                                                      ContactId = testcontact2.id,
                                                      OpportunityId = testOpportunity1.id,
                                                      ModelId = CIMId
                                                      );     
                                                      
        CampaignInfluence ci3 = new CampaignInfluence(CampaignId = testCampaign1.id,
                                                      ContactId = testcontact1.id,
                                                      OpportunityId = testOpportunity2.id,
                                                      ModelId = CIMId
                                                      );
                                                      
        CampaignInfluence ci4 = new CampaignInfluence(CampaignId = testCampaign2.id,
                                                      ContactId = testcontact2.id,
                                                      OpportunityId = testOpportunity2.id,
                                                      ModelId = CIMId
                                                      );                                                   
        
        lstCI.add(ci1);
        lstCI.add(ci2);
        lstCI.add(ci3);
        lstCI.add(ci4);
        
        insert lstCI;
        
        List<OpportunityContactRole> ocrList = new List<OpportunityContactRole>();
        OpportunityContactRole ocr1 = new OpportunityContactRole();
        ocr1.ContactId = testContact1.Id;
        ocr1.OpportunityId = testOpportunity1.Id;
        ocr1.IsPrimary = TRUE;
        ocr1.Role = 'Decision Maker';
        
        OpportunityContactRole ocr2 = new OpportunityContactRole();
        ocr2.ContactId = testContact2.Id;
        ocr2.OpportunityId = testOpportunity2.Id;
        ocr2.IsPrimary = TRUE;
        ocr2.Role = 'Decision Maker';
        ocrList.add(ocr1);
        ocrList.add(ocr2);
        insert ocrList;
        
        Test.startTest();
       
        List<Opportunity> lstToUpdate = new List<Opportunity>();
        lstToUpdate.add(new Opportunity(id = testOpportunity1.id,
                                        StageName = '6W-Closed Won',
                                        ContractId = contract1.id,
                                        ContractStartDate__c = System.today(),
                                        ContractEndDate__c = System.today(),
                                        ActivityCreated__c = true,
                                        ReadyForProcessingContractExist__c  = true
                                        )
                        );
                        
        lstToUpdate.add(new Opportunity(id = testOpportunity2.id,
                                        StageName = '6W-Closed Won',
                                        ContractId = contract1.id,
                                        ContractStartDate__c = System.today(), 
                                        ContractEndDate__c = System.today(),
                                        ActivityCreated__c = true,
                                        ReadyForProcessingContractExist__c  = true
                                        )
                        );                
        
        
        update lstToUpdate;
        
        //Do assert check if process builder fires. 
        if(GlobalConstants.hasCreateCaseForSalesLedCampaignprocessfired){
            
            List<Case> lCases = [Select Id, Subject, origin, RecordTypeId, ownerId from case];
            
            System.assertEquals(4, lCases.size(), 'Total number of cases');
            System.assertEquals(2, [Select Id from case where Opportunity__c = :testOpportunity1.id].size(), 'Total number of cases for Opp1');
            System.assertEquals(2, [Select Id from case where Opportunity__c = :testOpportunity2.id].size(), 'Total number of cases for Opp1');
            
            Id salesSupportRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Support').getRecordTypeId();
            List<Group> queues = [select Id from Group where Name = 'Sales Claims Team' and Type = 'Queue'];
            
            //checking for field value for created case.
            Case objCase = [Select Id, Subject, origin, RecordTypeId, ownerId from case where Opportunity__c = :testOpportunity1.id][0];
            System.assertEquals('Sales Claim Request', objCase.Subject , 'subject check');
            System.assertEquals('Internal', objCase.origin , 'origin check');
            System.assertEquals(salesSupportRecordTypeId, objCase.RecordTypeId , 'RecordTypeId check');
        }
        
        Test.stopTest();*/
    }        

}