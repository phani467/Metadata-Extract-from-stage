//-----------------------------
// @author: Jagadesh Kumar
// @date: 01 June 2018
// @param: NA
// @description: Test class for Product Usage Statistics trigger methods 
// @return: NA
//-----------------------------

@isTest
public class TestProductUsageStatisticsMethods {
	//-----------------------------
    // @author: Jagadesh Kumar
    // @date: 01 June 2018
    // @param: NA
    // @description: Test method for Product Usage Statistics trigger methods productUserContactCreation on insert
    // @return: NA
    //-----------------------------
    
    private static testMethod void testproductUserContactCreation() {
        Test.startTest();
        Account a = TestUtility.createTestAccount('Unknown Account', true);
        List<Contact> conList = new List<Contact>();
        Contact c1 = new Contact();
        c1.firstname = 'Test1';
        c1.lastname = 'Test1';
        c1.Email = 'pl.contactExists@ihsmarkit.com';
        c1.AccountId = a.Id;
        conList.add(c1);
        
        Contact c2 = new Contact();
        c2.firstname = 'Test2';
        c2.lastname = 'Test2';
        c2.AccountId = a.Id;
        c2.Email = 'pl.contactNull@ihsmarkit.com';
        conList.add(c2);
        
        insert conList;
        
        List<ProductLogin__c> plList = new List<ProductLogin__c>();
        
        ProductLogin__c pl2 = new ProductLogin__c();        
        pl2.Email__c = 'pl.contactNull@ihsmarkit.com';
        pl2.Source__c = 'Manual';
        pl2.Username__c = 'pl.contactNull';
        plList.add(pl2);
        
        ProductLogin__c pl3 = new ProductLogin__c();
        pl3.Email__c = 'pl.contactNull2@ihsmarkit.com';
        pl3.Source__c = 'Manual';
        pl3.Username__c = 'pl.contactNull2';
        pl3.FirstName__c = 'Test11';
        pl3.LastName__c = 'Test22';
        plList.add(pl3);
        
        insert plList;
        
        List<ProductUsageStatistics__c> pusList = new List<ProductUsageStatistics__c>();
        
        ProductUsageStatistics__c usg2 = new ProductUsageStatistics__c();
        usg2.ProductLogin__c	= pl2.Id;
        usg2.Source__c = 'UserXS';
        usg2.UsageDate__c = System.today();
        pusList.add(usg2);
        
        ProductUsageStatistics__c usg3 = new ProductUsageStatistics__c();
        usg3.ProductLogin__c	= pl3.Id;
        usg3.Source__c = 'UserXS';
        usg3.UsageDate__c = System.today();
        pusList.add(usg3);
        
        insert pusList;
        
		List<ProductLogin__c> productloginList = [SELECT Id,
                                             (SELECT Contact__c,ProductLogin__c FROM ProductLoginContactAssociations1__r) 
                                             FROM ProductLogin__c];
        System.assertEquals(1,productloginList.get(0).ProductLoginContactAssociations1__r.size());
        Test.stopTest();
    }
    
}