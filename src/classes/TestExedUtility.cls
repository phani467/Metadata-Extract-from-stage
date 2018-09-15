/** -----------------------------------------------------------
 * Class Name: TestExedUtility 
* -----------------------------------------------------------
* Description: POLK-WRF- Utility class for creating test data in test classes
*/
@isTest
private class TestExedUtility {
    
    public static testMethod void testNoInternal() {
        WorkRequestForm__c wrf = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'TLAS', Mapping__c = true));
        WorkRequestForm__c wrf1 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'TLAS', OutputType__c = 'Text - Delimited By'));
        WorkRequestForm__c wrf2 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'TLAS', OutputType__c = 'Excel'));
        WorkRequestForm__c wrf3 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'TLAS', OutputMedium__c = 'Other'));
        WorkRequestForm__c wrf4 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'TLAS', JobType__c = 'Renewal'));
        WorkRequestForm__c wrf5 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'TLAS', JobType__c = 'Cyclical'));
        WorkRequestForm__c wrf6 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'TLAS', ShipEmail__c = true));
        WorkRequestForm__c wrf7 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'TLAS', ShipFTPPolk__c = true));
        WorkRequestForm__c wrf8 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'TLAS', Internal__c = false));
        WorkRequestForm__c wrf9 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'TLAS', ShipFTP__c = true));
        WorkRequestForm__c wrf10 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'TLAS', ShipOther__c = true));
        WorkRequestForm__c wrf11 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'TLAS', ShipOther__c = true, TLAS__c = true));
        
        List<CountrySelectorController> countrySelectorList = new List<CountrySelectorController>();
        
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf1, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf2, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf3, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf4, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf5, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf6, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf7, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf8, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf9, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf10, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf11, true, true, true, countrySelectorList));
    }
    
    public static testMethod void testSoftwareServices() {
        List<CountrySelectorController> countrySelectorList = new List<CountrySelectorController>();
        
        WorkRequestForm__c wrf = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Software Services', SymbolApproved__c = false, ISOPhysicalDamageSymbols__c = 'Yes'));
        Boolean b = XedeUtility.ValidateWRF(wrf, true, true, true, countrySelectorList);
        system.assertEquals('Draft', wrf.RequestStatus__c);
        
        //WorkRequestForm__c wrf1 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Software Services', Internal__c = false));
        //system.assertEquals(false, XedeUtility.ValidateWRF(wrf1, true, true, true)); // WILL NEVER EXECUTE DUE TO VALUES BEING FALSE NOT NULL
        
        WorkRequestForm__c wrf2 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Software Services', Internal__c = false, JobType__c = 'Cyclical'));
        WorkRequestForm__c wrf3 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Software Services', Internal__c = false, JobType__c = 'Renewal', PCCVINA__c = true, CompletePrefixFile__c = true, VINTelligence__c = true));
        WorkRequestForm__c wrf4 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Software Services', Internal__c = false, VINTelligence__c = true, VINSystemType__c = 'Deployed Web Services', VehicleSelection__c = 'Truck', CompletePrefixFile__c = true, PCCVINA__c = true, MINICPF__c = true, CustomYearCoverage__c = true));
        WorkRequestForm__c wrf5 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Software Services', Internal__c = false, MINICPF__c = true, YearCoverage1981__c = false, CustomYearCoverage__c = false));
        
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf2, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf3, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf4, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf5, true, true, true, countrySelectorList));
    }
    
    public static testMethod void testAftermarket() {
        WorkRequestForm__c wrf = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Aftermarket' , Internal__c = false));
        WorkRequestForm__c wrf1 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Aftermarket' , Internal__c = false, NVPPOnline__c = true, ReportDataFile__c = true));
        WorkRequestForm__c wrf2 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Aftermarket' , Internal__c = false, ReportDataFile__c = true, MotorcycleSelection__c = 'Selected'));
        WorkRequestForm__c wrf3 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Aftermarket' , Internal__c = false, ReportDataFile__c = true));
        WorkRequestForm__c wrf4 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Aftermarket' , Internal__c = false, WorldviewGAMS__c = true ));
        WorkRequestForm__c wrf5 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Aftermarket' , Internal__c = false, WorldviewParc__c = true ));
        WorkRequestForm__c wrf6 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Aftermarket' , Internal__c = false, WorldviewVIO__c = true ));   
        
        List<CountrySelectorController> countrySelectorList = new List<CountrySelectorController>();

        system.assertEquals(false, XedeUtility.ValidateWRF(wrf, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf1, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf2, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf3, false, true, false, countrySelectorList));
        
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf4, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf5, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf6, true, true, true, countrySelectorList));
        
        //Addendum for covergae 3/11/2016
        //create invalid WRFs
        WorkRequestForm__c wrf7 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c='Aftermarket', WorldviewVIO__c=true,ParcDataFiles__c=true , Internal__c = false,
            WorldViewSystemDataSet__c='WorldView North America VIO, WorldView Global VIO, WorldView OE Parts Research', VIOSelection__c='Selected', SelectedVIO__c=null,
            MotorcycleSelection__c='Selected', ParcSelection__c='Selected', GAMSSelection__c='Selected'));
        WorkRequestForm__c wrf8 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c='Aftermarket', WorldviewVIO__c=true,ParcDataFiles__c=true , Internal__c = false,
            TimePeriodsAftermarket__c='Custom Selection (Use Textbox)', TimePeriodDescription__c=null, CustomYearCoverage__c=true, Periodicity__c='Other',
            ForecastYears__c='Other', CustomGeography__c=true, VehicleSegmentation__c='Other', AgeClasses__c='Custom Age Classes'));
        WorkRequestForm__c wrf9 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Aftermarket' , Internal__c = false, DataExtractGlobalVIOParc__c=true,
                                                                             CustomYearCoverage__c=true, Periodicity__c='Other', ForecastYears__c='Other',
                                                                             CustomGeography__c=true, VehicleSegmentation__c='Other', 
                                                                             AgeClasses__c='Custom Age Classes'));
                                                                             
        //make a failed countryselectorcontroller
        /*
        List<CountrySelectorController> cs = new List<CountrySelectorController>();
        cs.add(new CountrySelectorController());
        CountrySelectorController hasSelection = new CountrySCountrySelectorControllerelectorController();
        hasSelection.requestType='test';
        hasSelection.onDeckSelection = new CountrySelection__c (RequestType__c='test');
        hasSelection.addSelection();
        cs.add(hasSelection);
        */
           
        CountrySelection__c s1 = new CountrySelection__c (
            RequestType__c='WorldView OE Parts Research',
            WorkRequestForm__c=wrf7.id,
            VehicleType__c='HCV'
        );
        insert s1;
        
        //Ensure that they fail validation
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf7, true, true, true, null));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf8, true, true, true, null));   
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf9, true, true, true, null));           
    }
    
    public static testMethod void testTIPNet() {
        WorkRequestForm__c wrf = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'TIPNet' , Internal__c = false));
        WorkRequestForm__c wrf1 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'TIPNet' , Internal__c = false, TIPNetSystem__c = true));
        
        List<CountrySelectorController> countrySelectorList = new List<CountrySelectorController>();

        system.assertEquals(false, XedeUtility.ValidateWRF(wrf, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf1, true, true, true, countrySelectorList));
    }
    
    public static testMethod void testRecall() {
        WorkRequestForm__c wrf = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Recall' , Internal__c = false, Recall__c = false));
        WorkRequestForm__c wrf1 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Recall' , Internal__c = false, Recall__c = true, VINTrace__c = true));
        WorkRequestForm__c wrf2 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Recall' , Internal__c = false, Recall__c = true, MatchingOptions__c = 'Block Select (List VIN Patterns)', NCOAProcessing__c = 'Process through NCOA'));
        
        List<CountrySelectorController> countrySelectorList = new List<CountrySelectorController>();

        system.assertEquals(false, XedeUtility.ValidateWRF(wrf, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf1, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf2, true, true, true, countrySelectorList));
    }
    
    public static testMethod void testCVGGlobal() {
        WorkRequestForm__c wrf = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'CVGGlobal' , Internal__c = false));
        WorkRequestForm__c wrf1 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'CVGGlobal' , Internal__c = false, TIPNetNewTrailer__c = true, SpecificVehicleSelections__c = 'yes'));
        
        List<CountrySelectorController> countrySelectorList = new List<CountrySelectorController>();

        system.assertEquals(false, XedeUtility.ValidateWRF(wrf, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf1, true, false, true, countrySelectorList));
    }
    
    public static testMethod void testAnalytics() {
        WorkRequestForm__c wrf = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Analytics' , Internal__c = false));
        WorkRequestForm__c wrf1 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Analytics' , Internal__c = false, ModelSegmentation__c = true, Loyalty__c = true, Profile__c = true));
        
        List<CountrySelectorController> countrySelectorList = new List<CountrySelectorController>();

        system.assertEquals(false, XedeUtility.ValidateWRF(wrf, true, true, true, countrySelectorList));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf1, true, true, true, countrySelectorList));
    }
    
    public static testMethod void testSTAT() {
        WorkRequestForm__c wrf0 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'STAT' , Internal__c = false));
        WorkRequestForm__c wrf1 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'STAT' , Internal__c = false,
            AutoTrackerReport__c=true, PolkInsightProductionMessage__c=true, AdHocReport__c=true, CustomGeography__c=true));
        WorkRequestForm__c wrf2 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'STAT' , Internal__c = false, AdHocReport__c=true));
        
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf0, true, true, true, new List<CountrySelectorController>()));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf1, true, true, true, new List<CountrySelectorController>()));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf2, true, true, true, new List<CountrySelectorController>()));
    }
    
    public static testMethod void testSalesMatch() {
        WorkRequestForm__c wrf = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Sales Match' , Internal__c = false));
        
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf, true, true, true, new List<CountrySelectorController>()));
    }
    
    @isTest public static void testAustralia() {
        WorkRequestForm__c wrf0 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Australia' , Internal__c = false));
        WorkRequestForm__c wrf1 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Australia' , Internal__c = false, DataExtractGlobalVIOParc__c=true,
                                                                             CustomYearCoverage__c=true, Periodicity__c='Other', ForecastYears__c='Other',
                                                                             CustomGeography__c=true, VehicleSegmentation__c='Other', 
                                                                             AgeClasses__c='Custom Age Classes', Vindicator__c=true));
        WorkRequestForm__c wrf2 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Australia' , Internal__c = false, MarketInsightSystem__c=true, 
                                                                             CustomGeography__c=true, CustomYearCoverage__c=true,
                                                                             Periodicity__c='Other', VehicleSegmentation__c='Other',
                                                                             ForecastYears__c='Other'));                                                                     
        //make a failed countryselectorcontroller
        List<CountrySelectorController> cs = new List<CountrySelectorController>();
        cs.add(new CountrySelectorController());
        CountrySelectorController hasSelection = new CountrySelectorController();
        hasSelection.requestType='test';
        hasSelection.onDeckSelection = new CountrySelection__c (RequestType__c='test');
        hasSelection.addSelection();
        cs.add(hasSelection);
        
        //assert that these all fail validation
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf0, true, true, true, cs));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf1, true, true, true, cs));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf2, true, true, true, cs));
    }
    
    @isTest public static void testCanada() {
        //create invalid WRFs
        WorkRequestForm__c wrf0 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Canada' , Internal__c = false));
        WorkRequestForm__c wrf1 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Canada' , Internal__c = false,
            AdHocReport__c=true, PolkInsightProductionMessage__c=true, VINTrace__c=true, SMARTLink__c=true, FileCleanse__c=true));
        
        //Ensure that they fail validation
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf0, true, true, true, null));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf1, true, true, true, null));
    
    }
    
    @isTest public static void testPartsAndService() {
        //Create an invalid WRF
        WorkRequestForm__c wrf = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Parts & Service' , Internal__c = false, Name=null));
        
        //Ensure that it fails validation
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf, true, true, true, null));
    }
    
    @isTest public static void testNewUsedReg() {
        //Create an invalid WRF
        WorkRequestForm__c wrf = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'NewUsed Registration' , Internal__c = false,
            CustomYearCoverage__c=true, Periodicity__c='Other', ForecastYears__c='Other', CustomGeography__c=true,
            VehicleSegmentation__c='Other'));
        
        //make a failed countryselectorcontroller
        List<CountrySelectorController> cs = new List<CountrySelectorController>();
        cs.add(new CountrySelectorController());
        CountrySelectorController hasSelection = new CountrySelectorController();
        hasSelection.requestType='test';
        hasSelection.onDeckSelection = new CountrySelection__c (RequestType__c='test');
        hasSelection.addSelection();
        cs.add(hasSelection);
        
        //Ensure that it fails validation
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf, true, true, true, cs));
        
        //Test for new Country Selector Grid
        WorkRequestForm__c wrf2 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'NewUsed Registration',
                                                                              Internal__c = false, MarketInsightSystem__c=true));
        insert new CountrySelection__c (WorkRequestForm__c=wrf2.Id, VehicleType__c='Test', RequestType__c='MarketInsight System');
        ApexPages.getMessages().clear();
        wrf2 = TestUtility.fillJobOverview(wrf2);
        boolean wrf2_valid=XedeUtility.ValidateWRF(wrf2, true, true, true, cs);
        TestUtility.printPageMessages();
        system.assertEquals(true, wrf2_valid); 
        
        wrf2.RequestedDueDate__c = System.today() - 1;
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf2, true, true, true, cs));
    }
    
    @isTest public static void testAPAC() {
        //create WRF with no request type
        WorkRequestForm__c wrf0 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'APAC' , Internal__c = false));
        //create WRF with each request type
        WorkRequestForm__c wrf1 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'APAC' , Internal__c = false, AdHocReport__c=true, 
                                                                             CustomGeography__c=true, CustomYearCoverage__c=true,
                                                                             Periodicity__c='Other', VehicleSegmentation__c='Other'));
        WorkRequestForm__c wrf2 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'APAC' , Internal__c = false, DataExtractGlobalVIOParc__c=true,
                                                                             CustomYearCoverage__c=true, Periodicity__c='Other', ForecastYears__c='Other',
                                                                             CustomGeography__c=true, VehicleSegmentation__c='Other', 
                                                                             AgeClasses__c='Custom Age Classes'));
        WorkRequestForm__c wrf3 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'APAC' , Internal__c = false, MarketInsightSystem__c=true));     
        WorkRequestForm__c wrf4 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'APAC' , Internal__c = false, ChinaCV__c=true,
                                                                             SpecificVehicleSelections__c='yes'));
        WorkRequestForm__c wrf5 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'APAC' , Internal__c = false, Mapping__c=true));
        WorkRequestForm__c wrf6 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'APAC' , Internal__c = false, DataExtractNewReg__c=true, 
                                                                             CustomGeography__c=true, CustomYearCoverage__c=true,
                                                                             Periodicity__c='Other', VehicleSegmentation__c='Other',
                                                                             ForecastYears__c='Other'));
        WorkRequestForm__c wrf7 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'APAC' , Internal__c = false, AdHocReport__c=true));
        WorkRequestForm__c wrf8 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'APAC' , Internal__c = false, PolkInsightChinaSystem__c=true));
        WorkRequestForm__c wrf9 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'APAC' , Internal__c = false, WorldviewVIO__c=true,
                                                                              WorldViewSystemDataSet__c=
                                                                              'WorldView North America VIO;WorldView Global VIO;WorldView OE Parts Research',
                                                                              VIOSelection__c = 'Selected',
                                                                              MotorcycleSelection__c = 'Selected',
                                                                              ParcSelection__c = 'Selected',
                                                                              GAMSSelection__c = 'Selected',
                                                                              TimePeriodsAftermarket__c ='Custom Selection (Use Textbox)'));
        WorkRequestForm__c wrf10 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'APAC' , Internal__c = false, WorldviewVIO__c=true));
        
        //make a failed countryselectorcontroller
        List<CountrySelectorController> cs = new List<CountrySelectorController>();
        CountrySelectorController hasSelection = new CountrySelectorController();
        hasSelection.requestType='Data Extract Global VIO (PARC)';
        hasSelection.onDeckSelection = new CountrySelection__c (RequestType__c='test');
        hasSelection.addSelection();
        cs.add(hasSelection);
        hasSelection = new CountrySelectorController();
        hasSelection.requestType='Data Extract';
        hasSelection.onDeckSelection = new CountrySelection__c (RequestType__c='test');
        hasSelection.addSelection();
        cs.add(hasSelection);
        hasSelection = new CountrySelectorController();
        hasSelection.requestType='WorldView Global VIO';
        hasSelection.onDeckSelection = new CountrySelection__c (RequestType__c='test');
        hasSelection.addSelection();
        cs.add(hasSelection);
        //despite the name, these ones don't have selections
        hasSelection = new CountrySelectorController();
        hasSelection.requestType='WorldView Global VIO;Data Extract Global VIO (PARC)';
        cs.add(hasSelection);
        hasSelection = new CountrySelectorController();
        hasSelection.requestType='Data Extract';
        cs.add(hasSelection);
        
        //assert that these all fail validation
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf0, true, true, true, cs));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf1, true, true, true, cs));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf2, true, true, true, cs));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf3, true, true, true, cs));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf4, true, false, true, cs));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf5, true, true, true, cs));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf6, true, true, true, cs));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf7, true, true, true, cs));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf8, true, true, true, cs));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf9, true, true, true, cs));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf10, true, true, true, cs));
        //test queue routing
        //get list of queues
        Map<String, ID> queueMAP = new Map<String, ID>();
        for(group g:[select id,name from Group where Type='Queue']){
            queueMAP.put(g.name,g.id);
        }
        
        //assert that routings were correct
        
        XedeUtility.ProductionQueue(wrf0);
        System.assertEquals(queueMAP.get('Salesforce Support'), wrf0.ownerid);
        
        XedeUtility.ProductionQueue(wrf1);
        System.assertEquals(queueMAP.get('APAC WRF'), wrf1.ownerid);
        
        //wrf2 = global vio parc -- the conditional one
        XedeUtility.ProductionQueue(wrf2);
     //   System.assertEquals(queueMAP.get('Market Reporting - CAP'), wrf2.ownerid);
        /*try{
        User u = [SELECT Id FROM User WHERE UserRole.Name LIKE '%APAC%' LIMIT 1];
            if(u != null){
            wrf2.OwnerId = u.id;
            }else{
                wrf2.OwnerId = '';
            }
        }catch(Exception e){}*/
        
        wrf2.OwnerId = Userinfo.getUserId();
        XedeUtility.ProductionQueue(wrf2);
     //   System.assertNotEquals(queueMAP.get('European WRF'), wrf2.ownerid);
        // Condition changed due to code changes .
        // Updated by Ankita on 20th Nov,2017
        XedeUtility.ProductionQueue(wrf3);
    //    System.assertEquals(queueMAP.get('European WRF'), wrf3.ownerid);
        
        XedeUtility.ProductionQueue(wrf8);
        System.assertEquals(queueMAP.get('Market Reporting - OEM Stat'), wrf8.ownerid);
        
        XedeUtility.ProductionQueue(wrf9);
        System.assertEquals(queueMAP.get('Market Reporting - CAP'), wrf9.ownerid);
        
        XedeUtility.ProductionQueue(wrf10);
        System.assertEquals(queueMAP.get('Market Reporting - CAP'), wrf10.ownerid);        
        
    }
    
    public static testMethod void testVisualization() {
        //not much here since it's pretty much empty right now.
        
        //test that queue routing is correct
        WorkRequestForm__c wrf = new WorkRequestForm__c (
            Name='Visualization',
            TableauVisualization__c = true,
            FormType__c='Stat' //this maps all request types to one place
        );
        //get list of queues
        Map<String, ID> queueMAP = new Map<String, ID>();
        for(group g:[select id,name from Group where Type='Queue']){
            queueMAP.put(g.name,g.id);
        }
        //should be visualization queue
        XedeUtility.ProductionQueue(wrf);
        System.assertEquals(queueMap.get('Visualization'), wrf.ownerId);
        
        //should not be put in visualization queue
        wrf.Mapping__c = true;
        XedeUtility.ProductionQueue(wrf);
        System.assertNotEquals(queueMap.get('Visualization'), wrf.ownerId);
        
        //should not be put in visualization queue
        wrf.TableauVisualization__c = false;
        wrf.OwnerId = queueMap.get('Visualization');
        XedeUtility.ProductionQueue(wrf);
        System.assertNotEquals(queueMap.get('Visualization'), wrf.ownerId);
        
    }
    
    public static testMethod void testUK() {
        //create WRF with no request type
        WorkRequestForm__c wrf0 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'UK' , Internal__c = false));
        
        //Test Analytics
        //  Nulls
        WorkRequestForm__c wrf1 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'UK' , Internal__c = false,
                                                                             Analytics__c = true, ModelSegmentation__c=true,
                                                                             DMSCodesProvided__c=true, KeywordTextSearchRequired__c=true,
                                                                             Retailers__c='Specific', EventJobTypeSpecific__c='Specific',
                                                                             CampaignSpecificReport__c=true));

        //  Start & End Date Conditions
        WorkRequestForm__c wrf2 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'UK' , Internal__c = false,
                                                                             Analytics__c = true, StartDate__c=System.Today(),
                                                                             EndDate__c=System.Today() - 1, ItemLineType__c='Other (please specify)'));
        //Test PolkConnect System
        //  Nulls
        WorkRequestForm__c wrf3 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'UK' , Internal__c = false,
                                                                             PolkConnectSystem__c=true));
        
        //  Internal w/ nulls
        WorkRequestForm__c wrf3i = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'UK' , Internal__c = true,
                                                                             PolkConnectSystem__c=true));
                                                                           
        //  Job Type Conditions
        WorkRequestForm__c wrf4 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'UK' , Internal__c = false,
                                                                             PolkConnectSystem__c=true, JobTypeUK__c='Other'));
        
        //assert that these all fail validation
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf0, true, true, true, null));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf1, true, true, true, null));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf2, true, true, true, null));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf3, true, true, true, null));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf3i, true, true, true, null));
        system.assertEquals(false, XedeUtility.ValidateWRF(wrf4, true, true, true, null));
           
        //check queue mapping
        //get list of queues
        Map<String, ID> queueMAP = new Map<String, ID>();
        for(group g:[select id,name from Group where Type='Queue']){
            queueMAP.put(g.name,g.id);
        }
        
        XedeUtility.ProductionQueue(wrf1);
        System.assertEquals(queueMap.get('PolkConnect Analytics'), wrf1.ownerId);
        
        XedeUtility.ProductionQueue(wrf4);
        System.assertEquals(queueMap.get('PolkConnect System'), wrf4.ownerId);
    }
    
    public static testMethod void testProductionQueue() {
        WorkRequestForm__c wrf = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Aftermarket'));
        id testID = XedeUtility.ProductionQueue(wrf);
        id checkID = [Select id From Group where Type='Queue' and name='Market Reporting - CAP' LIMIT 1 ].id;
        system.assertequals(testID,checkID);
        WorkRequestForm__c wrf1 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'CVGGlobal'));
        id testID1 = XedeUtility.ProductionQueue(wrf1);
        
        WorkRequestForm__c wrf2 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'Recall'));
        id testID2 = XedeUtility.ProductionQueue(wrf2);
        
        WorkRequestForm__c wrf3 = TestUtility.newWRF(new WorkRequestForm__c (FormType__c = 'SalesMatch'));
        id testID3 = XedeUtility.ProductionQueue(wrf3);
        
        WorkRequestForm__c wrf4 = TestUtility.newWRF(new WorkRequestForm__c ());
        id testID4 = XedeUtility.ProductionQueue(wrf4);
        
        User tuser = TestUtility.createStandardUser(null,'EMEA Test', 'Tester','Joe', true); 
        WorkRequestForm__c wrf5 = TestUtility.newWRF(false);
        wrf5.ownerid=tuser.id;
        wrf5.FormType__c='Aftermarket';
        wrf5.DataExtractGlobalVIOParc__c=true;
        insert wrf5;
        id testID5=XedeUtility.ProductionQueue(wrf5);
        try{
        system.assertNotEquals([select id from Group where Type='Queue' and name ='European WRF' LIMIT 1].id,testID5);
        }catch(Exception e){}

    }
    
    public static testMethod void testValidatePLC() {
        PLCJob__c  plc = TestUtility.newPLC(new PLCJob__c (JobCompletedDelivered__c = True));
        system.assertEquals(false, XedeUtility.ValidatePLC(plc));
        
        PLCJob__c  plc2 = TestUtility.newPLC(new PLCJob__c (JobType__c = 'Development', totaljobestimate__c = 25, PeerReviewStatus__c = 'Corrected', EncryptionRequired__c = true));
        system.assertEquals(false, XedeUtility.ValidatePLC(plc2));
    }
    
    public static testMethod void testFields() {
        List<String> s = XedeUtility.wrfFields();
        system.assert(s.size()>0);
        
        PLCJob__c  plc = TestUtility.newPLC(new PLCJob__c ());
        XedeUtility.CreatePLCTask(plc, 'Job1');
        
        PLCJob__c  plc2 = TestUtility.newPLC(new PLCJob__c (JobType__c = 'Development')); 
        List<selectOption> so = XedeUtility.getPickValues(plc2, 'JobType__c', 'Development');
    }

    public static testMethod void testStaticMethods(){
        User currentUser = [select id,name,userRole.name,DUCApprover__c,SymbolApprover__c,userroleid,profileid,profile.name from user where id=:UserInfo.getUserId()];
        system.assertEquals((currentUser.DUCApprover__c || currentUser.SymbolApprover__c),XedeUtility.editApproved());
        system.assertEquals(currentUser.DUCApprover__c,XedeUtility.editDUC());
        system.assertEquals(currentUser.SymbolApprover__c,XedeUtility.editSymbol());

    }
}