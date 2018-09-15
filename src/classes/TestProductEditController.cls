/**
* @auhor Paras Dhingra
* @date 17th Sep 2017
* @description Test class for ProductEditController
* @company IHS Markit
* */
@isTest
public class TestProductEditController {
    /**
* @author Paras Dhingra
* @date 17 Sep 2017
* @description Test multiple methods for productEditController
* @param null
* @return void
* @company IHS Markit
*/
    private static testMethod void TestAddProducts() {
        Account testAccount = TestUtility.createTestAccount('Test Account 1', true);
        Opportunity testOppy = TestUtility.createOpportunity(testAccount.Id, 'Test Opportunity 1',false);
        testOppy.CurrencyIsoCode = 'USD';
        insert testOppy;
        LegalEntity__c testLegalEntity = TestUtility.createLegalEntity('IHSM test legalEntity', 'USD'); 
        Product2 p1 = TestUtility.createProduct('Test Product 1', false);
        p1.DiscountThreshold__c = 10;
        p1.LegalEntity__c = testLegalEntity.Id;
        Product2 p2 = TestUtility.createProduct('Test Product 2', false);
        p2.DiscountThreshold__c = 12;
        p2.LegalEntity__c = testLegalEntity.Id;
        insert new List<Product2>{p1,p2};
            Id stdPricebookId = Test.getStandardPricebookId();
        PricebookEntry pbe1 = TestUtility.createPriceBookEntry(stdPricebookId, p1.Id, false);
        PricebookEntry pbe2 = TestUtility.createPriceBookEntry(stdPricebookId, p2.Id, false);
        pbe1.CurrencyIsoCode = 'USD';
        pbe2.CurrencyIsoCode = 'USD';
        insert new List<PricebookEntry>{pbe1,pbe2};
        //Now create product schedules
        ProductSchedule__c ps1 = TestUtility.createProductSchedule(1223.23, '2017', '1 Year', '2017', p1.Id, false);
        ProductSchedule__c ps2 = TestUtility.createProductSchedule(2223.23, '2017', '3 Years', '2017', p2.Id, false);
        ProductSchedule__c ps3 = TestUtility.createProductSchedule(2323.23, '2018', '3 Years', '2017', p2.Id, false);
        ProductSchedule__c ps4 = TestUtility.createProductSchedule(2423.23, '2019', '3 Years', '2017', p2.Id, false);
        insert new List<ProductSchedule__c>{ps1,ps2,ps3,ps4};
            List<ProductEditController.ProductLineItemWrapper> lstProdWrapper = ProductEditController.getProductDetails(new List<Id>{p1.Id,p2.Id},testOppy.Id);
        	System.assertEquals(2, lstProdWrapper.size());
        	String json = System.JSON.serialize(lstProdWrapper);
        	ProductEditController.saveProductsOnOpportunity(json, testOppy.Id, testLegalEntity.Id);
      }
}