//-----------------------------
// @author: Sruti Srivastava
// @date:  24 July 2018
// @Description: SFDC1-5233- Testing Controller for component ViewEntitlement, which Displays license and usage information for 
// @companyname: Vertiba
//------------------------------

@isTest
private class TestViewEntitlementsController {
    
	static testMethod void testViewEntitlementsController() {
        //Creating test data
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
        
        ProductUsageStatistics__c usg1 = new ProductUsageStatistics__c(ProductLogin__c    = pl1.Id, Source__c = 'UserXS', ProductLicense__c = listProdLicenses[0].Id,  UsageDate__c = System.today().addDays(-15));
        pusList.add(usg1);
        ProductUsageStatistics__c usg2 = new ProductUsageStatistics__c(ProductLogin__c    = pl2.Id, Source__c = 'UserXS', ProductLicense__c = listProdLicenses[1].Id,  UsageDate__c = System.today().addDays(-25));
        pusList.add(usg2);
        ProductUsageStatistics__c usg3 = new ProductUsageStatistics__c(ProductLogin__c    = pl1.Id, Source__c = 'UserXS', ProductLicense__c = listProdLicenses[0].Id,  UsageDate__c = System.today().addDays(-24));
        pusList.add(usg3);
        ProductUsageStatistics__c usg4 = new ProductUsageStatistics__c(ProductLogin__c    = pl1.Id, Source__c = 'UserXS', ProductLicense__c = listProdLicenses[0].Id,  UsageDate__c = System.today().addDays(-4));
        pusList.add(usg4);
        insert pusList;
        
        List<ProductEntitlement__c> listProdEntitlement = new List<ProductEntitlement__c>();
        listProdEntitlement.add(new ProductEntitlement__c(ProductLogin__c= pl1.Id, ProductLicense__c = listProdLicenses[0].Id, StartDate__c = Date.today()));
        listProdEntitlement.add(new ProductEntitlement__c(ProductLogin__c= pl2.Id, ProductLicense__c = listProdLicenses[1].Id, StartDate__c = Date.today()));
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
        ViewEntitlementsController.LicenseWrapper objLicenseWrapper = ViewEntitlementsController.initialize(accountObj.Id, true);
        List<ViewEntitlementsController.ProductUsageSummary> listProductUsageSummary = ViewEntitlementsController.showUsageInformation(accountObj.Id, listProdGroup[0].Id ,false);
        Test.stopTest();
        //verifying if outputs are correct
        system.assert(objLicenseWrapper != null);
        system.assert(objLicenseWrapper.listProductLicense != null);
        system.assert(objLicenseWrapper.listProductLicense.size()>0);
        system.assert(listProductUsageSummary.size()>0);
        system.assert(objLicenseWrapper.conList.size() ==2);
    }
}