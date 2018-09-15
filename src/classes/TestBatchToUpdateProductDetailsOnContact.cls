//-----------------------------
// @author: Sruti Srivastava
// @date: 11th June 2018
// @description: SFDC1-6833 This batch class will update license and product information on Contact
// @companyname: Vertiba
//------------------------------

@isTest
public class TestBatchToUpdateProductDetailsOnContact {
    
    //-----------------------------
    // @author: Sruti Srivastava
    // @date: 11th June 2018
    // @description: Test method for batch BatchToUpdateProductDetailsOnContact which
    // update license and product information on Contact
    // @return: NA
    //-------------------
    private static testMethod void testProductAndLicenseDetailUpdateOnContact() {
        
        Account accountObj = TestUtility.createTestAccount('Unknown Account', true);
        List<Contact> conList = new List<Contact>();
        Contact c1 = new Contact(firstname = 'Test1', lastname = 'Test1', Email = 'pl.contactExists@ihsmarkit.com', AccountId = accountObj.Id);
        conList.add(c1);
        Contact c2 = new Contact(firstname = 'Test2', lastname = 'Test2', Email = 'pl.contactNull@ihsmarkit.com', AccountId = accountObj.Id);
        conList.add(c2);
        
        insert conList;
        
        List<ProductLogin__c> plList = new List<ProductLogin__c>();
        
        ProductLogin__c pl1 = new ProductLogin__c(Email__c = 'pl.contactNull@ihsmarkit.com', Source__c = 'Manual', Username__c = 'pl.contactNull');        
        plList.add(pl1);
        ProductLogin__c pl2 = new ProductLogin__c(Email__c = 'pl.contactExists@ihsmarkit.com', Source__c = 'Manual', Username__c = 'pl.contactNull2',FirstName__c = 'Test11',LastName__c = 'Test22' );        
        plList.add(pl2);
        
        insert plList;
        
        List<ProductLicense__c> listProdLicenses = new List<ProductLicense__c>();
        listProdLicenses.add(new ProductLicense__c(Name = 'Securities'));
        listProdLicenses.add(new ProductLicense__c(Name = 'Operation'));
        insert listProdLicenses;
        
        List<ProductUsageStatistics__c> pusList = new List<ProductUsageStatistics__c>();
        
        ProductUsageStatistics__c usg1 = new ProductUsageStatistics__c(ProductLogin__c    = pl1.Id, Source__c = 'UserXS', ProductLicense__c = listProdLicenses[0].Id,  UsageDate__c = System.today().addDays(-45));
        pusList.add(usg1);
        ProductUsageStatistics__c usg2 = new ProductUsageStatistics__c(ProductLogin__c    = pl2.Id, Source__c = 'UserXS', ProductLicense__c = listProdLicenses[1].Id,  UsageDate__c = System.today().addDays(-45));
        pusList.add(usg2);
        ProductUsageStatistics__c usg3 = new ProductUsageStatistics__c(ProductLogin__c    = pl1.Id, Source__c = 'UserXS', ProductLicense__c = listProdLicenses[0].Id,  UsageDate__c = System.today().addDays(-88));
        pusList.add(usg3);
        ProductUsageStatistics__c usg4 = new ProductUsageStatistics__c(ProductLogin__c    = pl1.Id, Source__c = 'UserXS', ProductLicense__c = listProdLicenses[0].Id,  UsageDate__c = System.today().addDays(-10));
        pusList.add(usg4);
        insert pusList;
        
        List<ProductEntitlement__c> listProdEntitlement = new List<ProductEntitlement__c>();
        listProdEntitlement.add(new ProductEntitlement__c(ProductLogin__c= pl1.Id, ProductLicense__c = listProdLicenses[0].Id, StartDate__c = Date.today()));
        insert listProdEntitlement;
        
        List<ProductGroup__c> listProdGroup = new List<ProductGroup__c>();
        listProdGroup.add(new ProductGroup__c(Name = 'Data Center & Cloud'));
        listProdGroup.add(new ProductGroup__c(Name = 'Facilities Management'));
        listProdGroup.add(new ProductGroup__c(Name = 'Access Control & Fire'));
        insert listProdGroup;
        
        List<ProductGroupLicenseAssociation__c> listProdGroupGA = new List<ProductGroupLicenseAssociation__c>();
        listProdGroupGA.add(new ProductGroupLicenseAssociation__c(ProductGroup__c = listProdGroup[0].Id, ProductLicense__c = listProdLicenses[0].Id));
        listProdGroupGA.add(new ProductGroupLicenseAssociation__c(ProductGroup__c = listProdGroup[1].Id, ProductLicense__c = listProdLicenses[0].Id));
        listProdGroupGA.add(new ProductGroupLicenseAssociation__c(ProductGroup__c = listProdGroup[2].Id, ProductLicense__c = listProdLicenses[1].Id));
        insert listProdGroupGA;
        
        Test.startTest();
        database.executeBatch(new BatchToUpdateProductDetailsOnContact());
        Test.stopTest();
        Contact contact1 = [select NumberOfLicenses__c, Licenses__c, ProductUsageLast30days__c, ProductUsageLast60days__c, ProductUsageLast90days__c
                            FROM Contact where email ='pl.contactNull@ihsmarkit.com' limit 1];
        Contact contact2 = [select NumberOfLicenses__c, Licenses__c, ProductUsageLast30days__c, ProductUsageLast60days__c, ProductUsageLast90days__c
                            FROM Contact where email !='pl.contactNull@ihsmarkit.com' limit 1];
        system.debug('******'+contact1);
        system.debug('******'+contact2);
        //Verifying outputs for License nformation update on Contact
        system.assertEquals(contact1.NumberOfLicenses__c, 1);
        system.assertEquals(contact2.NumberOfLicenses__c, 0);
        system.assertNotEquals(contact1.Licenses__c, null);
        system.assertEquals(contact2.Licenses__c, null);
        
        //Verifying outputs for Product usage information for last 30 days update on Contact
        system.assertNotEquals(contact1.ProductUsageLast30days__c, null);
        system.assertEquals(contact2.ProductUsageLast30days__c, null);
        
        //Verifying outputs for Product usage information for last 60 days update on Contact
        system.assert(contact1.ProductUsageLast60days__c.contains('Data Center & Cloud'));
        system.assert(contact1.ProductUsageLast60days__c.contains('Facilities Management'));
        system.assert(contact2.ProductUsageLast60days__c.contains('Access Control & Fire'));
        
        //Verifying outputs for Product usage information for last 90 days update on Contact
        system.assert(contact1.ProductUsageLast90days__c.contains('Data Center & Cloud'));
        system.assert(contact1.ProductUsageLast90days__c.contains('Facilities Management'));
        system.assert(contact2.ProductUsageLast90days__c.contains('Access Control & Fire'));
        
    }
    
    //-----------------------------
    // @author: Sruti Srivastava
    // @date: 11th June 2018
    // @description: Test method for schedular class BatchToUpdateProductDetailsScheduler
    // update license and product information on Contact
    // @return: NA
    //-------------------
    static testMethod void TestSchedulerForBatchToUpdateProductDetailsOnContact(){
        Test.StartTest();        
        BatchToUpdateProductDetailsScheduler contactBatchScheduler = new BatchToUpdateProductDetailsScheduler(); //Schedule apex class name
        String sch = '0 0 0 * * ?'; 
        String jobId = system.schedule('Run Job for BatchToUpdateProductDetailsOnContact', sch, contactBatchScheduler); //scheduling apex class
        System.assert(jobId!=null);
        Test.stopTest();
    }
    
}