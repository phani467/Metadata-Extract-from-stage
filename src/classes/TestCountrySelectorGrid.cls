/*
 * Description: Contains test methods for CountrySelectorGridController,
 *               CountrySelectorPageController, and CountrySelectorGridViewController.
*/
@isTest
public class TestCountrySelectorGrid {
  
    @isTest
    public static void testCountrySelectorGridController() {
        WorkRequestForm__c wrf = TestUtility.newWRF(true);
        WorkRequestForm__c wrf2 = TestUtility.newWRF(true);
        CountryOption__c o1 = new CountryOption__c(
            RequestType__c = 'Test;Test2',
            DataType__c = 'Test;Test2',
            Country__c = 'Argentina;Brazil',
            Geography__c = 'Forecast;National',
            VehicleType__c='CARS;HCV'
        );
        insert o1;
        CountryOption__c o2 = new CountryOption__c(
            RequestType__c = 'Test2',
            DataType__c = 'Test2',
            Country__c = 'Brazil',
            Geography__c = 'Forecast;National',
            VehicleType__c='CARS;HCV'
        );
        insert o2;
        
        CountryOption__c o3 = new CountryOption__c(
            RequestType__c = 'Test;Test2',
            DataType__c = 'Test;Test2',
            Country__c = 'Argentina;Brazil;China;Denmark;Ethiopia;France;Germany;Hungary',
            Geography__c = 'Forecast;National',
            VehicleType__c='CARS;HCV;LCV'
        );
        insert o3;
        //one country, multiple geos, multiple veh types
        CountrySelection__c s1 = new CountrySelection__c(
            RequestType__c='Test',
            DataType__c='Test',
            Country__c='Argentina',
            Geography__c='Forecast;National;',
            VehicleType__c='CARS;HCV',
            WorkRequestForm__c=wrf.id
        );
        insert s1;
        //many countries, including one that isn't an option
        CountrySelection__c s2 = new CountrySelection__c(
            RequestType__c='Test',
            DataType__c='Test',
            Country__c='Brazil;NonOption;France;Hungary',
            Geography__c='National',
            VehicleType__c='CARS;HCV',
            WorkRequestForm__c=wrf.id
        );
        insert s2;
        //wrong WRF
        CountrySelection__c s3 = new CountrySelection__c(
            RequestType__c='Test',
            DataType__c='Test',
            Country__c='China',
            Geography__c='National',
            VehicleType__c='LCV',
            WorkRequestForm__c=wrf2.id,
            Comments__c='Other'
        );
        insert s3;
        //for comment only change
        CountrySelection__c s4 = new CountrySelection__c(
            RequestType__c='Test',
            DataType__c='Test',
            Country__c='China',
            Geography__c='National',
            WorkRequestForm__c=wrf.id,
            Comments__c='None'
        );
        insert s4;
        //option to be deleted
        CountrySelection__c s5 = new CountrySelection__c(
            RequestType__c='Test',
            DataType__c='Test',
            Country__c='Denmark',
            Geography__c='Forecast',
            VehicleType__c='CARS',
            WorkRequestForm__c=wrf.id
        );
        insert s5;
        //wrong request type
        CountrySelection__c s6 = new CountrySelection__c(
            RequestType__c='Test2',
            DataType__c='Test',
            Country__c='Wrong Request Type',
            Geography__c='Forecast',
            VehicleType__c='CARS',
            WorkRequestForm__c=wrf.id
        );
        insert s6;
        //row with no changes
        CountrySelection__c s7 = new CountrySelection__c(
            RequestType__c='Test',
            DataType__c='Test',
            Country__c='Ethiopia',
            Geography__c='Forecast',
            VehicleType__c='CARS',
            WorkRequestForm__c=wrf.id
        );
        insert s7;
        //one country, one geo, multi veh types
        CountrySelection__c s8 = new CountrySelection__c(
            RequestType__c='Test',
            DataType__c='Test',
            Country__c='France',
            Geography__c='Forecast',
            VehicleType__c='CARS',
            WorkRequestForm__c=wrf.id
        );
        insert s8;
        //one country, many geos
        CountrySelection__c s9 = new CountrySelection__c(
            RequestType__c='Test',
            DataType__c='Test',
            Country__c='Germany',
            Geography__c='Forecast;;Regional - Other;National;',
            VehicleType__c='CARS;HCV',
            WorkRequestForm__c=wrf.id
        );
        insert s9;
        
        CountryQuickSelect__c region1 = new CountryQuickSelect__c(
            QuickSelectKey__c = 'America South', 
            Countries__c = 'Argentina;Brazil;China;Denmark;Ethiopia;France;Germany;Hungary',
            Type__c = 'World Region'
        );
        insert region1;
        
        CountryQuickSelect__c region2 = new CountryQuickSelect__c(
            QuickSelectKey__c = 'America North', 
            Countries__c = 'Argentina;Brazil;China;Denmark;Ethiopia;France;Germany;Hungary',
            Type__c = 'World Region'
        );
        insert region2;
        
        ApexPages.currentPage().getParameters().put('id', wrf.id);
        ApexPages.currentPage().getParameters().put('retURL', 'Test');
        CountrySelectorGridController con = new CountrySelectorGridController();
        System.assertEquals(wrf.id, con.URLID);
        System.assertEquals(false, con.isView);
        con.requestType = 'Test'; //will cause the controller to fetch data types
        System.assertNotEquals(0,con.dataTypes.size());
        con.dataType = 'Test';//will trigger row creation
        
        //Make sure basic meta data components are working properly
        System.assertNotEquals(0, con.getGeographies().size());
        System.assertNotEquals(0, con.getVehicleTypes().size());
        System.assertEquals(con.getVehicleTypes().size(), con.getVehicleTypeCount());
        System.assertEquals(con.getGeographies().size(), con.getGeographiesCount());
        System.assertNotEquals(0, con.getAllRegions().size());
        System.assertEquals(con.getAllRegions().size(), con.getRegionCount());
        System.assertEquals(false, con.getOddRegionCount());
        
        List<CountrySelectorGridController.CountryRow> rows = con.CountryRows;
        CountrySelectorGridController.CountryRow germany = null;
        for(integer i = 0; i < rows.size(); i++) {
            if(rows[i].country == 'China') {
                rows[i].Comments = 'Changed';
            }
            
            if(rows[i].country == 'Germany')
                germany = rows[i];
        }
        
        //assert that rows are being created properly based on above options and selections
        //just doing a spot check on one country here
        System.assertNotEquals(null, germany);
        System.assertEquals(2, germany.getRegions().size());
        System.assertEquals(true, germany.getRegionIsSelected());        
        System.assertNotEquals(0, germany.getVehicleTypeMap().keySet().size());
        System.assertNotEquals(0, germany.getVehicleTypes().size());
        System.assertEquals(true, germany.getHasSelection());
        System.assertEquals(0, germany.compareTo(new CountrySelectorGridController.CountryRow('Germany')));
        
        //construct a save string to cover all the bases
        con.saveString = 'China_0_0;Argentina_Forecast_LCV;Denmark_Forecast_CARS;Ethiopia_0_0;France_Forecast_HCV;' +
            'France_Forecast_LCV;France_National_LCV;Germany_Forecast_CARS;Germany_National_CARS;Hungary_National_CARS;NotAnOption_0_0;bad_too_many_parts';
        con.saveCountrySelections();
        
        //ensure that saves occurred correctly
        //retrieve list of all selections post-save
        List<CountrySelection__c> selections = [SELECT RequestType__c,DataType__c, Country__c, 
                                                 Geography__c, VehicleType__c,Comments__c
                                                FROM CountrySelection__c
                                                WHERE WorkRequestForm__c = :wrf.id
                                                AND RequestType__c = :con.requestType
                                                AND DataType__c = :con.dataType];
        //map them to country for easy retrieval
        Map<String, List<CountrySelection__c>> countrySelectionMap = new Map<String, List<CountrySelection__c>>();
        for(CountrySelection__c selection : selections) {
            if(!countrySelectionMap.containsKey(selection.Country__c))
                countrySelectionMap.put(selection.Country__c, new List<CountrySelection__c>());
            
            countrySelectionMap.get(selection.Country__c).add(selection);
        }
        
        //assert that saves occurred
        //  if china; assert that comments = 'Changed'
        for(CountrySelection__c china : countrySelectionMap.get('China')) {
            System.assertEquals('Changed', china.Comments__c);
        }
        //  if Argentina, size = 2
        System.assertEquals(2, countrySelectionMap.get('Argentina').size());
        //  Denmark doesn't exist
        System.assertEquals(false, countrySelectionMap.containsKey('Denmark'));
        //  Ethiopia comments & veh type = s7
        System.assertEquals(true, countrySelectionMap.get('Ethiopia')[0].VehicleType__c == s7.VehicleType__c);
        System.assertEquals(true, countrySelectionMap.get('Ethiopia')[0].Comments__c == s7.Comments__c);
        //  France veh type contains ;
        for(CountrySelection__c france : countrySelectionMap.get('France')) {
            System.assertEquals(true, france.VehicleType__c.contains(';'));
        }
        //  Germany count = 3
        System.assertEquals(3, countrySelectionMap.get('Germany').size());
        //  Hungary count  = 1; geo  = national; veh type = hcv
        System.assertEquals(1, countrySelectionMap.get('Hungary').size());
        System.assertEquals(true, countrySElectionMap.get('Hungary')[0].Geography__c == 'National');
        System.assertEquals(true, countrySElectionMap.get('Hungary')[0].VehicleType__c == 'HCV');
        //  have page messages
        System.assertNotEquals(0, ApexPages.getMessages().size());
        
        //test a bunch of invalid options and ensure no rows are generated
        CountrySelectorGridController con2 = new CountrySelectorGridController();
        con2.URLID = null;
        con2.requestType = null;
        con2.dataType = con2.nullDataTypeOption;
        System.assertEquals(0, con2.countryRows.size());
        System.assertEquals(0, con2.getAllRegions().size());
    }
    
    @isTest
    public static void testCountrySelectorGridViewController() {
        String reqType = 'Test';
        String dataType = 'Test;Test2';
        WorkRequestForm__c wrf = TestUtility.newWRF(true);
        ApexPages.currentPage().getParameters().put('id', wrf.id);
        CountrySelectorGridViewController con = new CountrySelectorGridViewController();
        
        System.assertEquals(wrf.id, con.URLID);
        System.assertEquals(false, con.getHasSelections());
        
        CountryOption__c o1 = new CountryOption__c(
            RequestType__c = reqType,
            DataType__c = dataType,
            Country__c = 'Test',
            Geography__c = 'Forecast',
            VehicleType__c='HCV'
        );
        insert o1;
        
        CountrySelection__c s1 = new CountrySelection__c(
            RequestType__c = reqType,
            DataType__c = 'Test',
            Country__c = 'Test Country 1',
            Geography__c = 'Forecast',
            VehicleType__c = 'HCV',
            WorkRequestForm__c = wrf.id,
            Comments__c = 'test'
        );
        insert s1;
               
        CountrySelection__c s2 = new CountrySelection__c(
            RequestType__c = reqType,
            DataType__c = dataType,
            WorkRequestForm__c = wrf.id,
            Comments__c = 'This record is bad since it has no country.'
        );
        insert s2;
        
        CountrySelection__c s3 = new CountrySelection__c(
            RequestType__c = reqType,
            DataType__c = 'Test2',
            Country__c = 'Test Country 2',
            Geography__c = 'Forecast',
            VehicleType__c = 'HCV',
            WorkRequestForm__c = wrf.id,
            Comments__c = 'test'
        );
        insert s3;
        
        CountrySelection__c s4 = new CountrySelection__c(
            RequestType__c = reqType,
            DataType__c = 'Test2',
            Country__c = 'Test Country 2',
            Geography__c = 'Forecast',
            VehicleType__c = 'HCV',
            WorkRequestForm__c = wrf.id,
            Comments__c = 'test'
        );
        insert s4;
        
        //make sure selections and data types were read properly
        con.requestType = reqType;
        System.assertEquals(reqType, con.requestType);
        System.assertEquals(true, con.getHasSelections());
        System.assertEquals(2, con.dataTypes.size());
        System.assertEquals(1, con.dataTypeCountryRows.get('Test').size()); 
        System.assertEquals(s1.Country__c, con.dataTypeCountryRows.get('Test')[0].country);
        System.assertEquals(1, con.dataTypeCountryRows.get('Test2').size()); 
        System.assertEquals(s3.Country__c, con.dataTypeCountryRows.get('Test2')[0].country);
        
        //test one with bad data
        ApexPages.currentPage().getParameters().remove('id');
        CountrySelectorGridViewController con2 = new CountrySelectorGridViewController();
        con2.requestType = reqType;
        System.assertEquals(reqType, con2.requestType);
        System.assertEquals(false, con2.getHasSelections());
        System.assertEquals(0, con2.dataTypes.size());
    }
    
    @isTest
    public static void testCountrySelectorPageController() {
        String reqType = 'Test';
        ApexPages.currentPage().getParameters().put('rt',reqType);
        CountrySelectorPageController con = new CountrySelectorPageController();
        System.assertEquals(reqType, con.requestType);
    }

}