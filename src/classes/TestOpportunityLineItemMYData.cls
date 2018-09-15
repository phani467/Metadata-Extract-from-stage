//-----------------------------
// @author: Paras Dhingra
// @date: 15th May 2018
// @param: NA
// @description: SFDC1-7976 Test class for OpportunityLineItemMYData
// @company: IHS Markit
// @return: None
//------------------------------
@isTest
public class TestOpportunityLineItemMYData {
    //-----------------------------
    // @author: Prachi Bhasin
    // @date: 3 July 2017
    // @param: NA
    // @description: Test method for Opportunity trigger methods updateGAMOnOpportunityTeam on insert
    // @return: NA
    //-----------------------------
    private static testMethod void testOpportunityLineItemMYData() {
        //create test data
        OpportunityLineItemMYData oliMData = new OpportunityLineItemMYData();
        Loop.ExternalData.QueryRequestInfo requestInfo = new Loop.ExternalData.QueryRequestInfo();
        Account testAccount = TestUtility.createTestAccount('Test Account 1', true);
        Opportunity testOppy = TestUtility.createOpportunity(testAccount.Id, 'Test Opportunity 1',true);
        Product2 p1 = TestUtility.createProduct('Test Product 1', false);
        p1.DiscountThreshold__c = 10;
        Product2 p2 = TestUtility.createProduct('Test Product 2', false);
        p2.DiscountThreshold__c = 12;
        insert new List<Product2>{p1,p2};
        Id stdPricebookId = Test.getStandardPricebookId();
        PricebookEntry pbe1 = TestUtility.createPriceBookEntry(stdPricebookId, p1.Id, false);
        PricebookEntry pbe2 = TestUtility.createPriceBookEntry(stdPricebookId, p2.Id, false);
        insert new List<PricebookEntry>{pbe1,pbe2};
        //Now create product schedules
        ProductSchedule__c ps1 = TestUtility.createProductSchedule(1223.23, '2017', '1 Year', '2017', p1.Id, false);
        ProductSchedule__c ps2 = TestUtility.createProductSchedule(2223.23, '2017', '3 Years', '2017', p2.Id, false);
        ProductSchedule__c ps3 = TestUtility.createProductSchedule(2323.23, '2018', '3 Years', '2017', p2.Id, false);
        ProductSchedule__c ps4 = TestUtility.createProductSchedule(2423.23, '2019', '3 Years', '2017', p2.Id, false);
        insert new List<ProductSchedule__c>{ps1,ps2,ps3,ps4};
        
        OpportunityLineItem oli1 = TestUtility.createOpportunityLineItem(testOppy.id, pbe1,false);
        OpportunityLineItem oli2 = TestUtility.createOpportunityLineItem(testOppy.id, pbe2,false);
        insert new List<OpportunityLineItem>{oli1,oli2};
        Test.startTest();
        //create Opportunity product schedules
        OpportunityLineItemSchedule__c ops1 = TestUtility.createOpportunityProductSchedule(testOppy.Id,ps1.Id,1223.23,1000,
                                                                                            'Amount', 223.23, 0.0, p1.Id, '2017', 2, 
                                                                                            oli1.Id,false);
        OpportunityLineItemSchedule__c ops2 = TestUtility.createOpportunityProductSchedule(testOppy.Id,ps2.Id,2223.23,2000,
                                                                                            'Amount', 223.23, 0.0, p2.Id, '2017', 1, 
                                                                                            oli2.Id,false);
        OpportunityLineItemSchedule__c ops3 = TestUtility.createOpportunityProductSchedule(testOppy.Id,ps3.Id,2323.23,2000,
                                                                                            'Amount', 323.23, 0.0, p2.Id, '2018', 1, 
                                                                                            oli2.Id,false);
        OpportunityLineItemSchedule__c ops4 = TestUtility.createOpportunityProductSchedule(testOppy.Id,ps4.Id,2323.23,2000,
                                                                                            'Amount', 423.23, 0.0, p2.Id, '2019', 1, 
                                                                                            oli2.Id,false);
        insert new List<OpportunityLineItemSchedule__c>{ops1,ops2,ops3,ops4};
        //start test
        requestInfo.RecordId = testOppy.id;
        oliMData.describeObjects(new List<String>(oliMData.getGlobalDescribe()));
        oliMData.getChildRelationships('OppyLineItem');
        List<Loop.ExternalData.Relationship> Relationships = new List<Loop.ExternalData.Relationship>();
        for(String str: oliMData.getGlobalDescribe()) {
            Loop.ExternalData.Relationship relationship = new Loop.ExternalData.Relationship();
            relationship.Name = str;
            Relationships.add(relationship);
        }
        requestInfo.Relationships = Relationships;
        Loop.ExternalData.QueryResultSet queryRS = oliMData.query(requestInfo);
        System.assert(queryRS!=null);
        Test.stopTest();
    }
}