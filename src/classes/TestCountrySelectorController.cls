/*********************************************
Name - TestCountrySelectorController 
Description - POLK_WRF- Test Class for Country Selector
Author - IHS

Modified by - Anjani Shukla/10/12/2017

**********************************************/
@isTest
private class TestCountrySelectorController {  
    static testMethod void SelectListPopulationTest() {
        List<CountryOption__c> countryOptionList = aSavedCountryOptionList();
        
        WorkRequestForm__c wrf = new WorkRequestForm__c();
        
        WRACE ext = new WRACE(new ApexPages.standardController(wrf));
        
        CountrySelectorController controller = new CountrySelectorController();
        
        controller.pageExtension = ext;
        controller.requestType = 'Data Extract';
        controller.parentId = wrf.Id;
        
            system.assertEquals(1, ext.countrySelectors.size());
            system.assert(controller.isRegistered);
            system.assertEquals(null, controller.onDeckSelection.RequestType__c);
            system.assertEquals(false, controller.selectionIsValid);
        
        List<SelectOption> dataTypeOptions = controller.getDataTypeOptions();
            system.assertEquals(2, dataTypeOptions.size());
            system.assertEquals(null, controller.onDeckSelection.DataType__c);
        
            // remaining lists are not populated until certain values are assigned to the onDeckSelection
            system.assert(controller.getVehicleTypeOptions().isEmpty());
            system.assert(controller.getRegionOptions().isEmpty());
            system.assert(controller.getCountryOptions().isEmpty());
            system.assert(controller.getGeographyOptions().isEmpty());
//          system.assert(controller.getTimePeriodOptions().isEmpty());
        
        controller.onDeckSelection.DataType__c = dataTypeOptions[0].getValue();
            system.assertEquals('Global VIO', controller.onDeckSelection.DataType__c);
            system.assertEquals(false, controller.selectionIsValid);
        
        List<SelectOption> vehicleTypeOptions = controller.getVehicleTypeOptions();
            system.assertEquals(3, vehicleTypeOptions.size());
        
        controller.onDeckSelection.VehicleType__c = vehicleTypeOptions[0].getValue();
            system.assertEquals('CARS', controller.onDeckSelection.VehicleType__c);
            system.assertEquals(false, controller.selectionIsValid);

        List<SelectOption> regionOptions = controller.getRegionOptions();
        List<SelectOption> countryOptions = controller.getCountryOptions();
            system.assertEquals(4, regionOptions.size());
            system.assertEquals(9, countryOptions.size());
    
            system.assert(controller.getGeographyOptions().isEmpty());
//          system.assert(controller.getTimePeriodOptions().isEmpty());

        controller.onDeckSelection.Region__c = regionOptions[0].getValue();
            system.assertEquals('America North', controller.onDeckSelection.Region__c);
            system.assertEquals(false, controller.selectionIsValid);

        countryOptions = controller.getCountryOptions();
            system.assertEquals(4, countryOptions.size());

        controller.onDeckSelection.Country__c = countryOptions[3].getValue();
            system.assertEquals('USA', controller.onDeckSelection.Country__c);
            system.assertEquals(false, controller.selectionIsValid);
        
        List<SelectOption> geographyOptions = controller.getGeographyOptions();
        controller.onDeckSelection.Geography__c = geographyOptions[0].getValue();
            system.assertEquals(true, controller.selectionIsValid);
           

/*      List<SelectOption> timePeriodOptions = controller.getTimePeriodOptions();
        controller.onDeckSelection.Time_Period__c = timePeriodOptions[0].getValue();
            system.assertEquals(true, controller.selectionIsValid);*/

        // changing a value
     
        controller.onDeckSelection.DataType__c = dataTypeOptions[1].getValue();
            system.assertEquals('NA VIO', controller.onDeckSelection.DataType__c);
        
            // page causes downstream values to clear when an upstream value changes
            PageReference anyPage = Page.WRDriver;
            anyPage.getParameters().put('startingField', 'VehicleType__c');
            Test.setCurrentPage(anyPage);
            controller.clearDownStreamValues();
            system.assertEquals(false, controller.selectionIsValid);

            system.assertEquals(null, controller.onDeckSelection.VehicleType__c);
            system.assertEquals(null, controller.onDeckSelection.Region__c);
            system.assertEquals(null, controller.onDeckSelection.Country__c);
            system.assertEquals(null, controller.onDeckSelection.Geography__c);
//          system.assertEquals(null, controller.onDeckSelection.Time_Period__c);

            system.assert(controller.getVehicleTypeOptions().isEmpty() == false);
            system.assert(controller.getRegionOptions().isEmpty());
            system.assert(controller.getCountryOptions().isEmpty());
            system.assert(controller.getGeographyOptions().isEmpty());
//          system.assert(controller.getTimePeriodOptions().isEmpty());
    }

    static testMethod void AddAndRemoveCountrySelectionRowsTest() {
        List<CountryOption__c> countryOptionList = aSavedCountryOptionList();
        
        WorkRequestForm__c wrf = new WorkRequestForm__c();
        
        WRACE ext = new WRACE(new ApexPages.standardController(wrf));
        
        CountrySelectorController controller = new CountrySelectorController();
        
        controller.pageExtension = ext;
        controller.requestType = 'Data Extract';
        controller.parentId = wrf.Id;
        
        // make selections and add a row to the country selections list
        controller.onDeckSelection.DataType__c = controller.getDataTypeOptions()[0].getValue();
        controller.onDeckSelection.VehicleType__c = controller.getVehicleTypeOptions()[0].getValue();
        controller.onDeckSelection.Region__c = controller.getRegionOptions()[0].getValue();
        controller.onDeckSelection.Country__c = controller.getCountryOptions()[3].getValue();
        controller.onDeckSelection.Geography__c = controller.getGeographyOptions()[0].getValue();
//      controller.onDeckSelection.Time_Period__c = controller.getTimePeriodOptions()[0].getValue();
            
            system.assertEquals('Global VIO', controller.onDeckSelection.DataType__c);
            system.assertEquals('CARS', controller.onDeckSelection.VehicleType__c);
            system.assertEquals('America North', controller.onDeckSelection.Region__c);
            system.assertEquals('USA', controller.onDeckSelection.Country__c);
            system.assertEquals('National', controller.onDeckSelection.Geography__c);
//          system.assertEquals('1/1 (VIO)', controller.onDeckSelection.Time_Period__c);
            system.assertEquals(true, controller.selectionIsValid);
            system.assert(controller.countrySelections.isEmpty());

        controller.addSelection();
            system.assertEquals(1, controller.countrySelections.size(), 'add selection should move the onDeckSelection to the selections list');
            system.assertEquals(false, controller.selectionIsValid, 'onDeckSelection should be refreshed once a selection is added');

            // these properties are used to display selections on the page
            system.assertEquals('Global VIO', controller.countrySelections[0].dataType);
            system.assertEquals('CARS', controller.countrySelections[0].vehicleType);
            system.assertEquals('America North', controller.countrySelections[0].region);
            system.assertEquals('USA', controller.countrySelections[0].country);
            system.assertEquals('National', controller.countrySelections[0].geography);
//          system.assertEquals('1/1 (VIO)', controller.countrySelections[0].timePeriod);

        // add a second row to the country selections list
        controller.onDeckSelection.DataType__c = controller.getDataTypeOptions()[1].getValue();
        controller.onDeckSelection.VehicleType__c = controller.getVehicleTypeOptions()[1].getValue();
        controller.onDeckSelection.Region__c = controller.getRegionOptions()[0].getValue();
        controller.onDeckSelection.Country__c = controller.getCountryOptions()[0].getValue();
        controller.onDeckSelection.Geography__c = controller.getGeographyOptions()[1].getValue();
//      controller.onDeckSelection.Time_Period__c = controller.getTimePeriodOptions()[0].getValue();

            system.assertEquals('NA VIO', controller.onDeckSelection.DataType__c);
            system.assertEquals('HCV', controller.onDeckSelection.VehicleType__c);
            system.assertEquals('America North', controller.onDeckSelection.Region__c);
            system.assertEquals('Canada', controller.onDeckSelection.Country__c);
            system.assertEquals('Regional', controller.onDeckSelection.Geography__c);
//          system.assertEquals('1/1 (VIO)', controller.onDeckSelection.Time_Period__c);
            system.assertEquals(true, controller.selectionIsValid);

        controller.addSelection();
            system.assertEquals(2, controller.countrySelections.size());
            system.assertEquals(false, controller.countrySelections[0].isRemoved);
            system.assertEquals(false, controller.countrySelections[1].isRemoved);
            system.assertEquals(2, controller.getRetainedSelections().size());
        
        // remove a row from the country selections
        controller.countrySelections[1].removeRow();
            system.assertEquals(2, controller.countrySelections.size(), 'should still be 2 selections in the list');
            system.assertEquals(false, controller.countrySelections[0].isRemoved);
            system.assertEquals(true, controller.countrySelections[1].isRemoved, 'the second selection in the list is flagged for removal');
            system.assertEquals(false, controller.countrySelections[1].removeSelection, 'this selection has no Id, so is not flagged for deletion from the database');
            system.assertEquals(1, controller.getRetainedSelections().size(), 'should be only 1 selection retained, this list is displayed on the page');
    }

    static testMethod void SaveAndDeleteCountrySelectionRecordsTest() {
        List<CountryOption__c> countryOptionList = aSavedCountryOptionList();
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        insert testAccount;
        WorkRequestForm__c wrf = new WorkRequestForm__c(Name = 'Test WRF 1');
         Product2 testProd = TestUtility.createProduct('Test Product', true);
         Id standardId = Test.getStandardPricebookId();
         PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
         
         Opportunity opty = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', true);
         OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(opty.Id, testPBE, true);
        //Opportunity opty = createOpportunity('Random Opty Name');
        wrf.OpportunityName__c = opty.id;
       wrf.OpportunityNumber__c = opty.Opportunitynum__c;
        upsert wrf;
        wrf = refreshWRF(wrf.Name);
        
        WRACE ext = new WRACE(new ApexPages.standardController(wrf));
        
        CountrySelectorController controller = new CountrySelectorController();
        
        controller.pageExtension = ext;
        controller.requestType = 'Data Extract';
        controller.parentId = wrf.Id;
        
        // make selections and add a row to the country selections list
        controller.onDeckSelection.DataType__c = controller.getDataTypeOptions()[0].getValue();
        controller.onDeckSelection.VehicleType__c = controller.getVehicleTypeOptions()[0].getValue();
        controller.onDeckSelection.Region__c = controller.getRegionOptions()[0].getValue();
        controller.onDeckSelection.Country__c = controller.getCountryOptions()[3].getValue();
        controller.onDeckSelection.Geography__c = controller.getGeographyOptions()[0].getValue();
//      controller.onDeckSelection.Time_Period__c = controller.getTimePeriodOptions()[0].getValue();
        controller.addSelection();

        // add a second row to the country selections list
        controller.onDeckSelection.DataType__c = controller.getDataTypeOptions()[1].getValue();
        controller.onDeckSelection.VehicleType__c = controller.getVehicleTypeOptions()[1].getValue();
        controller.onDeckSelection.Region__c = controller.getRegionOptions()[0].getValue();
        controller.onDeckSelection.Country__c = controller.getCountryOptions()[0].getValue();
        controller.onDeckSelection.Geography__c = controller.getGeographyOptions()[1].getValue();
//      controller.onDeckSelection.Time_Period__c = controller.getTimePeriodOptions()[0].getValue();
        controller.addSelection();
        
        ext.saveDraft();
            wrf = refreshWRF(wrf.Name);
         
        // new extension and controller with wrf from the database
        ext = new WRACE(new ApexPages.standardController(wrf));
        controller = new CountrySelectorController();
        
        // these are set by the page when the selector component is rendered
        controller.pageExtension = ext;
        controller.requestType = 'Data Extract';
        controller.parentId = wrf.Id;
        
            system.assertEquals(0, controller.countrySelections.size());
            system.assertEquals(0, controller.getRetainedSelections().size());
            
        //controller.countrySelections[0].removeRow();
            system.assertEquals(0, controller.countrySelections.size(), 'removed row should remain in this list, remains intact in the cancel event');
            system.assertEquals(0, controller.getRetainedSelections().size(), 'removed row should not appear in the retained list, which is displayed to the page');
            
        ext.saveDraft();
            wrf = refreshWRF(wrf.Name);
            system.assertEquals(0, wrf.CountrySelections__r.size(), 'should be only one row left in the database');
    }


    static testMethod void CloneCountrySelectionRecordsTest() {
        List<CountryOption__c> countryOptionList = aSavedCountryOptionList();
        Account testAccount = TestUtility.createTestAccount('testAccount', false);
        testAccount.DataGovernanceStatus__c = 'Approved';
        upsert testAccount;
        WorkRequestForm__c wrf = new WorkRequestForm__c(Name = 'Test WRF 1');
        //Test Data opportunity,Product,Pricebook,OLI
         Product2 testProd = TestUtility.createProduct('Test Product', true);
         Id standardId = Test.getStandardPricebookId();
         PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
         
         Opportunity opty = TestUtility.createOpportunity(testAccount.Id, 'test Opppy', true);
         OpportunityLineItem testOLI = TestUtility.createOpportunityLineItem(opty.Id, testPBE, true);
        /*Opportunity opty = createOpportunity('Random Opty Name');*/
        wrf.OpportunityName__c = opty.id;
        wrf.OpportunityNumber__c = opty.Opportunitynum__c;
        upsert wrf;
        wrf = refreshWRF(wrf.Name);
        WRACE ext = new WRACE(new ApexPages.standardController(wrf));
        
        CountrySelectorController controller = new CountrySelectorController();
        
        controller.pageExtension = ext;
        controller.requestType = 'Data Extract';
        controller.parentId = wrf.Id;
        
        // make selections and add a row to the country selections list
        controller.onDeckSelection.DataType__c = controller.getDataTypeOptions()[0].getValue();
        controller.onDeckSelection.VehicleType__c = controller.getVehicleTypeOptions()[0].getValue();
        controller.onDeckSelection.Region__c = controller.getRegionOptions()[0].getValue();
        controller.onDeckSelection.Country__c = controller.getCountryOptions()[3].getValue();
        controller.onDeckSelection.Geography__c = controller.getGeographyOptions()[0].getValue();
//      controller.onDeckSelection.Time_Period__c = controller.getTimePeriodOptions()[0].getValue();
        controller.addSelection();

        // add a second row to the country selections list
        controller.onDeckSelection.DataType__c = controller.getDataTypeOptions()[1].getValue();
        controller.onDeckSelection.VehicleType__c = controller.getVehicleTypeOptions()[1].getValue();
        controller.onDeckSelection.Region__c = controller.getRegionOptions()[0].getValue();
        controller.onDeckSelection.Country__c = controller.getCountryOptions()[0].getValue();
        controller.onDeckSelection.Geography__c = controller.getGeographyOptions()[1].getValue();
//      controller.onDeckSelection.Time_Period__c = controller.getTimePeriodOptions()[0].getValue();
        controller.addSelection();

            system.assertEquals(2, controller.countrySelections.size());
            system.assertEquals(2, controller.getRetainedSelections().size());
            system.assertEquals(false, controller.countrySelections[0].isRemoved);
            system.assertEquals(false, controller.countrySelections[1].isRemoved);

        ext.saveDraft();
        system.assertEquals(1, [select count() from WorkRequestForm__c where Name like '%Test WRF 1']);

        ext.wrClone();
            system.assertEquals(2, [select count() from WorkRequestForm__c where Name like '%Test WRF 1']);
        
        WorkRequestForm__c cloneOfWRF = refreshWRF('Clone - Test WRF 1');
        
            system.assertEquals(2, cloneOfWRF.CountrySelections__r.size());
    }
    
    //creates, inserts, and refreshes an opportunity
    //This is useful for adding them to WRFs
    private static Opportunity createOpportunity(String name) {
        Opportunity opty = new Opportunity(Name=name, StageName='Test', CloseDate=System.today());
        insert opty;
        //refresh to grab id and opty # 
        opty = [SELECT Id, Name,Opportunitynum__c FROM Opportunity WHERE Name=:name];
        return opty;
    }

    static testMethod void RegisteringComponentWithExtensionPreventsDuplicationTest() {
        List<CountryOption__c> countryOptionList = aSavedCountryOptionList();
        
        WorkRequestForm__c wrf = new WorkRequestForm__c();
        
        WRACE ext = new WRACE(new ApexPages.standardController(wrf));
        
        CountrySelectorController controller = new CountrySelectorController();
        
        controller.pageExtension = ext;
        controller.requestType = 'Data Extract';
        controller.parentId = wrf.Id;
        
            system.assertEquals(1, ext.countrySelectors.size());
            system.assert(controller.isRegistered);
        
        // call pageExtension property's setter again, isRegistered boolean prevents adding component to extension a second time
        controller.pageExtension = ext;
            system.assertEquals(1, ext.countrySelectors.size());
            system.assert(controller.isRegistered);
    }
    
    public static List<CountryOption__c> aSavedCountryOptionList() { 

        /*
        String jsonString = '';
        
        for (CountryOption__c each : [Select RequestType__c, DataType__c, VehicleType__c, Region__c, Country__c, Geography__c, Time_Period__c, CurrencyIsoCode From CountryOption__c]) {
            jsonString += '\'{"attributes":{"type":"CountryOption__c"},"RequestType__c":"'+each.RequestType__c+'","DataType__c":"'+each.DataType__c+'","VehicleType__c":"'+each.VehicleType__c+'","Region__c":"'+each.Region__c+'","Country__c":"'+each.Country__c+'","Geography__c":"'+each.Geography__c+'","Time_Period__c":"'+each.Time_Period__c+'","CurrencyIsoCode":"'+each.CurrencyIsoCode+'"}\',\n';
        }
        system.debug('\n\n'+jsonString+'\n\n');
        */
        
        /*
        String jsonString = '';
        
        for (CountryOption__c each : [Select RequestType__c, DataType__c, VehicleType__c, Region__c, Country__c, Geography__c, Time_Period__c, CurrencyIsoCode From CountryOption__c]) {
            jsonString += '\'{"attributes":{"type":"CountryOption__c"},"RequestType__c":"'+each.RequestType__c+'","DataType__c":"'+each.DataType__c+'","VehicleType__c":"'+each.VehicleType__c+'","Region__c":"'+each.Region__c+'","Country__c":"'+each.Country__c+'","Geography__c":"'+each.Geography__c+'","CurrencyIsoCode":"'+each.CurrencyIsoCode+'"}\',\n';
        }
        system.debug('\n\n'+jsonString+'\n\n');
        */
        
/*        List<String> jsonList = new List<String> {
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO;NA VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"America North","Country__c":"USA","Geography__c":"National;Regional","Time_Period__c":"1/1 (VIO);4/1 (VIO);7/1 (VIO);10/1 (VIO);Current VIO (US WorldView)","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO;NA VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"America North","Country__c":"Mexico","Geography__c":"National","Time_Period__c":"1/1 (VIO);4/1 (VIO);7/1 (VIO);10/1 (VIO);Current VIO (US WorldView)","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO;NA VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"America North","Country__c":"Canada","Geography__c":"National;Regional","Time_Period__c":"1/1 (VIO);4/1 (VIO);7/1 (VIO);10/1 (VIO);Current VIO (US WorldView)","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO;NA VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"America North","Country__c":"Puerto Rico","Geography__c":"National","Time_Period__c":"1/1 (VIO);4/1 (VIO);7/1 (VIO);10/1 (VIO);Current VIO (US WorldView)","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"America South","Country__c":"Brazil","Geography__c":"National;Regional","Time_Period__c":"1/1 (VIO);4/1 (VIO);7/1 (VIO);10/1 (VIO);Current VIO (US WorldView)","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"America South","Country__c":"Argentina","Geography__c":"National;Regional","Time_Period__c":"1/1 (VIO);4/1 (VIO);7/1 (VIO);10/1 (VIO);Current VIO (US WorldView)","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"Europe West","Country__c":"Germany","Geography__c":"NUTS Level 1;NUTS Level 2","Time_Period__c":"1/1 (VIO);4/1 (VIO);7/1 (VIO);10/1 (VIO);Current VIO (US WorldView)","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"Europe West","Country__c":"Estonia","Geography__c":"NUTS Level 1;NUTS Level 2","Time_Period__c":"1/1 (VIO);4/1 (VIO);7/1 (VIO);10/1 (VIO);Current VIO (US WorldView)","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO","VehicleType__c":"CARS;LCV","Region__c":"Europe East","Country__c":"France","Geography__c":"NUTS Level 1;NUTS Level 2","Time_Period__c":"1/1 (VIO);4/1 (VIO);7/1 (VIO);10/1 (VIO);Current VIO (US WorldView)","CurrencyIsoCode":"USD"}'
        };*/
   
        List<String> jsonList = new List<String> {
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO;NA VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"America North","Country__c":"USA","Geography__c":"National;Regional","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO;NA VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"America North","Country__c":"Mexico","Geography__c":"National","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO;NA VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"America North","Country__c":"Canada","Geography__c":"National;Regional","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO;NA VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"America North","Country__c":"Puerto Rico","Geography__c":"National","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"America South","Country__c":"Brazil","Geography__c":"National;Regional","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"America South","Country__c":"Argentina","Geography__c":"National;Regional","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"Europe West","Country__c":"Germany","Geography__c":"NUTS Level 1;NUTS Level 2","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO","VehicleType__c":"CARS;HCV;LCV","Region__c":"Europe West","Country__c":"Estonia","Geography__c":"NUTS Level 1;NUTS Level 2","CurrencyIsoCode":"USD"}',
            '{"attributes":{"type":"CountryOption__c"},"RequestType__c":"Data Extract;MarketInsight VIO System","DataType__c":"Global VIO","VehicleType__c":"CARS;LCV","Region__c":"Europe East","Country__c":"France","Geography__c":"NUTS Level 1;NUTS Level 2","CurrencyIsoCode":"USD"}'
        };
        
        List<CountryOption__c> sobjectList = new List<CountryOption__c>();
        
        for (String each : jsonList)
            sobjectList.add((CountryOption__c)Json.deserialize(each, CountryOption__c.class));

        insert sobjectList;

        return sobjectList;
    }
    
    static WorkRequestForm__c refreshWRF(String jobName) {
        // dynamically grabbing all WorkRequestForm__c fields 
        Schema.Describesobjectresult sobjectResult = Schema.describeSObjects(new List<String>{ 'WorkRequestForm__c' })[0];
        Map<String, Schema.SObjectField> fieldMap = sobjectResult.fields.getMap();
        List<String> fieldList = new List<String>(fieldMap.keySet());
        fieldList.add('(select Id from CountrySelections__r)');
        
        String dynamicFieldList = String.join(fieldList, ', ');
        
        String queryString = XedeQueryBuilder.QueryStringFor(dynamicFieldList, 'WorkRequestForm__c', XedeQueryBuilder.TextEqualityComparisonFor('Name', jobName), null, null, null);
        return Database.query(queryString);

    }
    
}