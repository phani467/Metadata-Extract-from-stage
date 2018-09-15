//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This class is used in POLK WRF.
    // @return: NA
    //----------------------------- 

public with sharing class XedeUtility{
    
    //common data items
    private static final user u = [select id,name,userRole.name,DUCApprover__c,SymbolApprover__c,userroleid,profileid,profile.name from user where id=:UserInfo.getUserId()];
    //last updated 10/27/2016 - BF
    private static final Set<String> allRequestTypes = new Set<String> { 'AdhocCustom__c', 
                'AutoTrackerReport__c', 'AutoNews__c', 'PolkInsightProductionMessage__c', 
                'CARB__c', 'ChinaCV__c', 'ChinaDataRequests__c', 
                'CompletePrefixFile__c', 'Custom__c', 'CVINA__c', 
                'DataExtractGlobalVIOPARC__c', 'ReportDataFile__c', 'DMS__c', 
                'DrivewayCalculator__c', 'FileCleanse__c', 'FleetFind__c', 'ListRequest__c', 
                'Loyalty__c', 'Mapping__c', 'DataExtractNewReg__c', 'MarketInsightSystem__c', 
                'PARCDataFiles__c', 'MINICPF__c', 'modelSegmentation__c', 'NewRegSystem__c', 
                'NewRegNewFor__c', 'PS__c', 'PARCGlobal__c', 'PCCVINA__c', 'PCVINA__c', 
                'PCVIS__c', 'PolkInsightChinaSystem__c', 'Analytics__c', 'PolkConnectSystem__c',
                'Profile__c', 'Recall__c', 'Recover__c', 'AdHocReport__c', 'SalesMatch__c', 
                'SmartLink__c', 'TIPNetNewTrailer__c', 
                'TIPNetNewTruck__c', 'TIPNetSystem__c', 'TIPNetVehiclesInOperation__c', 
                'TLAS__c', 'ScrappageMedianAge__c', 'Vfacts__c', 'VINPrefixFile__c', 
                'VINPrice__c', 'VINTelligence__c', 'VINTrace__c', 'VINVerification__c', 
                'VINA__c', 'Vindicator__c', 'VIS__c', 'VOS__c', 'WorldviewVIO__c',
                'TableauVisualization__c', 'Analytics__c', 'PolkConnectSystem__c'};
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: boolean 
    //-----------------------------             
    public static boolean editApproved(){
        boolean e=false;
        if(u.DUCApprover__c || u.SymbolApprover__c){e=true;}
        return e;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: boolean 
    //-----------------------------   
    public static boolean editDUC(){
        boolean e=false;
        if(u.DUCApprover__c){e=true;}
        return e;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: boolean 
    //-----------------------------  
    public static boolean editSymbol(){
        boolean e=false;
        if(u.SymbolApprover__c){e=true;}
        return e;
    }      
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: workrequestform__c wrf, Boolean CNThasvalues, Boolean DFhasvalues, Boolean MChasvalues, List<CountrySelectorController> wrfCountrySelectors
    // @description:  This method is used in POLK WRF.
    // @return: boolean
    //----------------------------- 
    public static boolean ValidateWRF(workrequestform__c wrf, Boolean CNThasvalues, Boolean DFhasvalues, Boolean MChasvalues, List<CountrySelectorController> wrfCountrySelectors) {
        boolean v = true;
        
        //ALL WRF Required Fields - Not Internal & Not Software Services
        if(wrf.jobtype__c == null) { wrf.addError('Job Overview - Job Type must be selected'); v=false;}
        
        Set<String> applicableFormTypes = new Set<String>{ 'Australia', 'NewUsed Registration', 'TLAS', 'Aftermarket', 'Analytics', 'Continental Tire Aftermarket', 'CVGGlobal', 'Recall', 'Sales Match', 'Stat', 'Canada', 'TIPNet', 'APAC', 'UK' };
            
            if ( applicableFormTypes.contains(wrf.FormType__c) && (wrf.Internal__c == false) ) {
                
                if (wrf.Mapping__c == true && wrf.StdGeoTemplate__c == null && wrf.CustomGeoTemplate__c == null && wrf.LAVAMassMapping__c == null) {
                    wrf.addError ('Data Files- You must fill out 1 field in the Design Spec section.');
                    v = false;
                }   
                if (wrf.Mapping__c == true && (wrf.InternalMapping__c == false && wrf.External__c == false) ) {
                    wrf.addError('Data Files - You must select either Internal or External Mapping.');
                    v = false;
                }
                if (wrf.Name == null) {
                    wrf.addError ('Job Overview - A job name is required to submit this request.');
                    v = false;
                }
                
                //RoyaltyVendor__c
                if (wrf.RoyaltyVendor__c == null) {
                    if(ignoresRoyalties(wrf)) {
                        wrf.RoyaltyVendor__c='No Royalty Data';
                    } else {
                        wrf.addError ('Job Overview - You must select a value from Royalty Vendor.');
                        v = false;
                    }
                }            
                if (wrf.ShipEmail__c == false && wrf.ReturnToSales__c == false && wrf.ShipCarrier__c == false && wrf.ShipFTP__c == false && wrf.ShipFTPPolk__c == false && wrf.ShipOther__c == false ) {
                    if (! ignoresShipping(wrf)) {
                        wrf.addError('Job Overview - You must have 1 shipping selection.');
                        v = false;
                    }
                }
                if (wrf.PrimarySalesContact__c == null && wrf.Internal__c == false) {
                    wrf.addError('Job Overview - A Primary Sales Contact is required to submit this request.');
                    v = false;
                }
                if (wrf.RequestedDueDate__c == null) {
                    wrf.addError('Job Overview - A Requested Due Date is required to submit this request.');
                    v = false;
                }
                
                //Requested Due Date cannot be less than Submitted date
                //check against today's date of submitted date is blank
                if ( (wrf.SubmittedDate__c != null && wrf.RequestedDueDate__c < wrf.SubmittedDate__c) ||
                    (wrf.SubmittedDate__c == null && wrf.RequestedDueDate__c < System.today()) ) {
                    wrf.addError('Job Overview - The Customer Requested Date cannot be earlier than the Submitted Date. Please enter a new date.'); 
                    v = false;
                }
                
                if (wrf.OutputType__c == null && !ignoresOutputSpec(wrf)) { 
                    wrf.addError('Job Overview - Output Type must be chosen to submit this request.');
                    v = false;
                }
                if (wrf.OutputType__c == 'Text - Delimited By' && wrf.DelimitedBy__c == null) {
                    wrf.addError(' Job Overview - You must enter a Delimited By description.');
                    v = false;
                }
                if (wrf.OutputType__c == 'Excel' && wrf.ExcelVersion__c == null && !ignoresExcelVersion(wrf)) {
                    wrf.addError(' Job Overview - You must enter an Excel version.');
                    v = false;
                }
                if (wrf.OutputMedium__c == null && !ignoresOutputSpec(wrf)) {  
                    wrf.addError('Job Overview - Output Medium must be chosen to submit this request.');
                    v = false;
                }
                if (wrf.OutputMedium__c == 'Other' && wrf.OtherOutputMedium__c == null) {
                    wrf.addError('Job Overview - You must enter something in Other Output Medium.');
                    v = false;
                }
                if(wrf.JobType__c == 'Renewal' && wrf.PreviousJob__c == null && wrf.PreviousLegacyJob__c == null ) {
                    wrf.addError('Job Overview - Previous Job or Previous Legacy Job is required to submit this request.');
                    v = false;      
                }
                if((wrf.JobType__c == 'Cyclical') && (wrf.Cycle__c == null || wrf.CycleStart__c == null || wrf.NumberOfCycles__c == null )) {
                    wrf.addError('Job Overview - Cycles, Cycle Start Date and Number of Cycles is required to submit this request.');
                    v = false;      
                }
                
                if( wrf.JobType__c == 'Cyclical' && (wrf.NumberOfCycles__c <= 0 || wrf.NumberOfCycles__c > 130)) {
                    wrf.addError('Job Overview - Number of Cycles must be between 1 and 130.');
                }
                
                if(wrf.ShipEmail__c == true && wrf.Email__c == null){
                    wrf.addError('Job Overview - If Email is selected as a shipping type, you must enter an email address.');
                    v = false;
                }
                
                if(wrf.ShipFTPPolk__c == true && wrf.FTPLogin__c == null ) {
                    wrf.addError('Job Overview - If Polk FTP is selected as a shipping type, you must enter the FTP Login.');
                    v = false;
                }
                
                /*
if(wrf.DUCApproval_Required__c == null && wrf.Internal__c == false) {
wrf.addError ('Job Overview - Please select a DUC Approval Reason');
v = false;
}*/
       
                if(wrf.ShipFTP__c == true && wrf.FTPLogin__c == null) {
                    wrf.addError('Job Overview - If Customer FTP is selected as a shipping type, you must enter the FTP Loging.');
                    v = false;
                }
                if(wrf.ShipOther__c == true && wrf.ShippingInstructions__c == null ) {
                    wrf.addError ('Job Overview - If Other is selected as a shipping type, you must enter something in the shipping instructions text box.');
                    v = false;  
                }
            }       
        
        //Software Services Approval Request Error      
        
        // vistheft decommissioned 9/4/2014 if ((wrf.FormType__c == 'Software Services' && wrf.SymbolApproved__c != true) && (wrf.ISOPhysicalDamageSymbols__c == 'Yes' || wrf.AIB_HighTheft_Indicator__c == 'Yes' || wrf.AIBVRG__c == 'Yes' || wrf.RVData__c == 'Yes' || wrf.ISOPhysicalDamageAndLiabilitySymbols__c == 'Yes' || wrf.PreservedRolledSymbols__c == 'Yes' || wrf.SymbolMerge__c == 'Yes')) {
        if ((wrf.FormType__c == 'Software Services' && wrf.SymbolApproved__c != true) && (wrf.ISOPhysicalDamageSymbols__c == 'Yes' || wrf.ISORAPASymbols__c =='Yes' ||  wrf.AIBVRG__c == 'Yes' || wrf.RVData__c == 'Yes' || wrf.ISOPhysicalDamageAndLiabilitySymbols__c == 'Yes' || wrf.PreservedRolledSymbols__c == 'Yes' || wrf.SymbolMerge__c == 'Yes')) {    
            wrf.addError('When selecting Symbols and/or VRG-Insurance You Need Approval before submitting the request to production. This request has been saved as a draft and has automatically been sent to the approval group. You will be notified once it is complete.');
            
            wrf.SymbolApprovalRequested__c = true;
            wrf.requeststatus__c = 'Draft';
            upsert wrf;
            v=false;    
        }
        
        
        if (wrf.FormType__c == 'Software Services' && wrf.Internal__c == false) {
            
            if (wrf.VINA__c == false && wrf.VIS__c == false && wrf.CVINA__c == false && wrf.PCVINA__c == false && wrf.PCVIS__c == false && wrf.PCCVINA__c == false && wrf.CompletePrefixFile__c == false && wrf.MINICPF__c == false && wrf.VINPrefixFile__c == false && wrf.VINPrice__c == false && wrf.VINTelligence__c == false && wrf.Recover__c == false && wrf.FleetFind__c == false && wrf.VOS__c == false && wrf.VINVerification__c == false && wrf.Custom__c == false && wrf.Custom__c == false && wrf.TableauVisualization__c == false ){
                wrf.addError('Job Overview - You must select at least 1 request type.');
                v = false;
            }
            
            /*   
if(wrf.DUCApproval_Required__c == null){
wrf.addError('Job Overview - Please select a DUC Apprvoal Reason.');
v = false;
}*/
       
            if(wrf.PrimarySalesContact__c == null){
                wrf.addError('Job Overview - You must select a Primary Sales Contact.');
                v = false;
            }
            if (wrf.RequestedDueDate__c == null) {
                wrf.addError('Job Overview - A Requested Due Date is required to submit this request.');
                v = false;
            }
            //RoyaltyVendor__c
            if (wrf.RoyaltyVendor__c == null) {
                wrf.addError('Job Overview - You must select a value from Royalty Vendor.');
                v = false;
            }            
            if (wrf.ShipFTP__c == false && wrf.ReturnToSales__c == false && wrf.ShipOther__c == false) {
                wrf.addError('Job Overview - You must select a shipping type to submit this request.');
                v = false;
            }
            if (wrf.JobType__c == 'Cyclical' && (wrf.Cycle__c == null || wrf.CycleStart__c == null || wrf.NumberOfCycles__c == null ) ) {
                wrf.addError('Job Overview - You must entter Cycles, Cycle Start Date and Number of Cycles to submit this request.');
                v = false;
            }
            if (wrf.JobType__c == 'Renewal' && wrf.PreviousJob__c == null && wrf.PreviousLegacyJob__c == null ) {
                wrf.addError('Job Overview - You must have a Previous Job or Legacy Job reference to submit this request.');
                v = false;
            }
            if (wrf.PCCVINA__c == true && wrf.SystemType__c == null ) {
                wrf.addError('Data Files - You must select 1 System Type to submit this request.');
                v = false;
            }
            if (wrf.PCCVINA__c == true && wrf.VehicleSelection__c == null ) {
                wrf.addError('Data Files - You must select 1 Vehicle Selection to submit this request.');
                v = false;
            }
            if (wrf.VehicleSelection__c == null && (wrf.CompletePrefixFile__c == true || wrf.MINICPF__c == true || wrf.VINTelligence__c == true)) {
                wrf.addError('Data Files - You must select 1 Vehicle Selection to submit this request.');
                v = false;
            }
            if (wrf.VINTelligence__c == true && wrf.VINSystemType__c == null) {
                wrf.addError('Data Files - You must select 1 System Type to submit this request.');
                v = false;
            }
            if (wrf.VINTelligence__c == true && wrf.LicenseEndDate__c == null) {
                wrf.addError('Data Files - You must have a License End Date to submit this request.');
                v = false;
            }
            if (wrf.VINTelligence__c == true && wrf.ContractedVINAmount__c == null && (wrf.VINSystemType__c == 'Deployed Web Services' || wrf.VINSystemType__c == 'Web Services' || wrf.VINSystemType__c == 'Web UI' || wrf.VINSystemType__c == 'Self Service Batch')) {
                wrf.addError('Data Files - You must enter something into Contracted VIN amount to submit this request.');
                v = false;
            }
            if (wrf.FileType__c == null && (wrf.CompletePrefixFile__c == true || wrf.MINICPF__c == true)) {
                wrf.addError('Data Files - You must select 1 File Type to submit this request.');
                v = false;
            }
            if (wrf.VINTelligence__c == true && (wrf.VehicleSelection__c == 'Truck' && wrf.ManufacturerGVW__c == null && wrf.GVW__c == null)) {
                wrf.addError('Data Files - You must select 1 GVW to submit this request.');
                v = false;
            }
            if (wrf.CompletePrefixFile__c == true && wrf.VehicleSelection__c == 'Truck' && wrf.ManufacturerGVW__c == null && wrf.GVW__c == null) {
                wrf.addError('Data Files - You must select 1 GVW to submit this request.');
                v = false;
            }
            if (wrf.PCCVINA__c == true && wrf.VehicleSelection__c == 'Truck' && wrf.ManufacturerGVW__c == null && wrf.GVW__c == null) {
                wrf.addError('Data Files - You must select 1 GVW to submit this request.');
                v = false;
            }
            if (wrf.MINICPF__c == true && wrf.VehicleSelection__c == 'Truck' && wrf.ManufacturerGVW__c == null && wrf.GVW__c == null) {
                wrf.addError('Data Files - You must select 1 GVW to submit this request.');
                v = false;
            }
            if (wrf.VINTelligence__c == true && wrf.DataPackage__c == null) {
                wrf.addError('Data Files - You must select Data Package to submit this request.');
                v = false;
            }
            if (wrf.AAIACodes__c == null && (wrf.PCCVINA__c == true || wrf.CompletePrefixFile__c == true)) {
                wrf.addError('Data Files - You must select 1 AAIA Code to submit this request.');
                v = false;
            }
            if (wrf.ACESCodes__c == null && (wrf.PCCVINA__c == true || wrf.CompletePrefixFile__c == true )) {
                wrf.addError('Data Files - You must select 1 ACES Code to submit this request.');
                v = false;
            }
            if (wrf.PCCVINA__c == true && wrf.YearCoverage1966__c == false && wrf.YearCoverage1981__c == false && wrf.CustomYearCoverage__c == false ) {
                wrf.addError('Data Files - You must make 1 selection in Year Coverage to submit this request.');
                v = false;
            }
            if (wrf.VINTelligence__c == true && (wrf.YearCoverage1981__c == false && wrf.CustomYearCoverage__c == false )) {
                wrf.addError('Data Files - You must make 1 selection in Year Coverage to submit this request.');
                v = false;
            }
            if (wrf.CompletePrefixFile__c == true && (wrf.YearCoverage1981__c == false && wrf.CustomYearCoverage__c == false )) {
                wrf.addError('Data Files - You must make 1 selection in Year Coverage to submit this request.');
                v = false;
            }
            if (wrf.PCCVINA__c == true && wrf.CustomYearCoverage__c == true && (wrf.CustomYearFrom__c == null || wrf.CustomYearTo__c == null )) {
                wrf.addError('Data Files - You must fill out Custom Year To and Custom Year From to submit this request.');
                v = false;
            }
            if (wrf.CompletePrefixFile__c == true && wrf.CustomYearCoverage__c == true && (wrf.CustomYearFrom__c == null || wrf.CustomYearTo__c == null )) {
                wrf.addError('Data Files - You must fill out Custom Year To and Custom Year From to submit this request.');
                v = false;
            }
            if (wrf.MINICPF__c == true && wrf.CustomYearCoverage__c == true && (wrf.CustomYearFrom__c == null || wrf.CustomYearTo__c == null )) {
                wrf.addError('Data Files - You must fill out Custom Year To and Custom Year From to submit this request.');
                v = false;
            }
            if (wrf.VINTelligence__c == true && wrf.CustomYearCoverage__c == true && (wrf.CustomYearFrom__c == null || wrf.CustomYearTo__c == null )) {
                wrf.addError('Data Files - You must fill out Custom Year To and Custom Year From to submit this request.');
                v = false;
            }
            //             if (wrf.VINTelligence__c == true && (wrf.ISOPhysicalDamageAndLiabilitySymbols__c == null || wrf.ISOPhysicalDamageSymbols__c == null || wrf.SymbolMerge__c == null || wrf.AIBVRG__c == null || wrf.RVData__c == null || wrf.AIB_HighTheft_Indicator__c == null )) {
            if (wrf.VINTelligence__c == true && (wrf.ISOPhysicalDamageAndLiabilitySymbols__c == null || wrf.ISOPhysicalDamageSymbols__c == null || wrf.SymbolMerge__c == null || wrf.AIBVRG__c == null || wrf.RVData__c == null )) {
                wrf.addError('Data Files - You must select Yes/No for each Symbol to submit this request.');
                v = false;
            }
            if (wrf.CompletePrefixFile__c == true && (wrf.ISOPhysicalDamageAndLiabilitySymbols__c == null || wrf.ISOPhysicalDamageSymbols__c == null || wrf.SymbolMerge__c == null || wrf.MASymbols__c == null || wrf.PreservedRolledSymbols__c == null || wrf.AIBVRG__c == null )) {
                wrf.addError('Data Files - You must select Yes/No for each Symbol to submit this request.');
                v = false;
            }
            if (wrf.VINTelligence__c == true && (wrf.YearCoverage1981__c == false && wrf.CustomYearCoverage__c == false )) {
                wrf.addError('Data Files - You must make 1 selection in Year Coverage to submit this request.');
                v = false;
            }
            if (wrf.MINICPF__c == true && (wrf.YearCoverage1981__c == false && wrf.CustomYearCoverage__c == false )) {
                wrf.addError('Data Files - You must make 1 selection in Year Coverage to submit this request.');
                v = false;
            }
            if (wrf.CompletePrefixFile__c == true && (wrf.YearCoverage1981__c == false && wrf.CustomYearCoverage__c == false )) {
                wrf.addError('Data Files - You must make 1 selection in Year Coverage to submit this request.');
                v = false;
            }
            // ELS 5/29/12 - temporary fix for new field in SWS.  The original logic can be put back after a dynamic picklist is coded. 
            // (original logic)if (wrf.UpdateSchedulePrefix__c == null && (wrf.PCCVINA__c == true || wrf.CompletePrefixFile__c == true || wrf.MINICPF__c == true || wrf.VINTelligence__c == true )) {
            if ( (wrf.UpdateSchedulePrefix__c == null && wrf.UpdateScheduleSuffix__c == null )&& (wrf.PCCVINA__c == true || wrf.CompletePrefixFile__c == true || wrf.MINICPF__c == true || wrf.VINTelligence__c == true )) {
                wrf.addError('Data Files - You must select an Update Schedule to submit this request.');
                v = false;
            }
        }
        
        //TLAS Requests Required Fields - Not Internal  
        
        if (wrf.FormType__c == 'TLAS' && wrf.Internal__c == false) {
            
            if (wrf.TLAS__c == false && wrf.ListRequest__c == false && wrf.SalesMatch__c == false && wrf.Mapping__c == false && wrf.TableauVisualization__c == false) {
                wrf.addError('Job Overview - You must select 1 Request Type.');
                v = false;
            }
            /* This piece of code is commented out to remove the dependency of CustomerContact__c as per new business use case for POLK
            if(wrf.TLAS__c == true &&  wrf.CustomerContact__c == null) {
                wrf.addError('Job Overview - You must enter Customer Contact to submit this request');
                v = false;
            } */
            if(wrf.TLAS__c == true &&  wrf.JobDescription__c == null) {
                wrf.addError('Data Files - You must enter a Job Description to submit this request');
                v = false;                                                  
            }
        }
        
        //Aftermarket Requests Required Fields - Not Internal   
        if (wrf.FormType__c == 'Aftermarket' && wrf.Internal__c == false) {
            
            if (wrf.ReportDataFile__c == false && wrf.PARCDataFiles__c == false && wrf.WorldviewVIO__c== false && wrf.DataExtractGlobalVIOPARC__c == false && wrf.ScrappageMedianAge__c == false && wrf.Mapping__c == false && wrf.TableauVisualization__c == false) {
                wrf.addError('Job Overview - You must select one Request Type.');
                v = false;
            }          
            if (wrf.LicenseExpirationDate__c == null && ( wrf.WorldviewVIO__c || wrf.PARCDataFiles__c)) {
                wrf.addError('Job Overview - A License Expiration Date is required when Worldview request types are selected to submit this request.');
                v = false;
            }                   
            //ReportDataFile__c, Data Extract North America
            if (wrf.ReportDataFile__c == true) {
                if (wrf.GVW__c == null ) {
                    wrf.addError('Data Files - You must select at least one VIN GVW/Category in the Vehicle Attributes section');
                    v = false;
                }
                if(wrf.Geography__c== null) { 
                    wrf.addError('Data Files - You must select one Geography.');
                    v = false;
                }
                if(wrf.VIOSelection__c == 'Selected' && wrf.SelectedVIO__c == null){
                    wrf.addError('Data Files - You must enter the Selected WorldView North America VIO Selection');
                    v = false;
                }                
                if(wrf.MotorcycleSelection__c == 'Selected' && wrf.SelectedMotorcycles__c == null){
                    wrf.addError('Data Files - You must enter the Selected Motorcycles');
                    v = false;
                }
                if(wrf.TimePeriodsAftermarket__c == null) {
                    wrf.addError('Data Files - You must select a Time Period.');
                    v = false;
                }   
                else if(wrf.TimePeriodsAftermarket__c.contains('Custom Selection (Use Textbox)') && wrf.TimePeriodDescription__c == null) {
                    wrf.addError('Data Files - You must and Specify Year Range for Custom Time Period Selection.');
                    v = false;
                }   
            } // END DATA EXTRACT NORTH AMERICA validation
            
            //WorldviewVIO__c, WorldView System
            if (wrf.WorldviewVIO__c == true)
            {
                // check time periods
                if(wrf.TimePeriodsAftermarket__c == null) {
                    wrf.addError('Data Files - You must select a Time Period.');
                    v = false;
                }   
                else if(wrf.TimePeriodsAftermarket__c.contains('Custom Selection (Use Textbox)') && wrf.TimePeriodDescription__c == null) {
                    wrf.addError('Data Files - You must and Specify Year Range for Custom Time Period Selection.');
                    v = false;
                }   
                // check WorldView System Data Set
                if (wrf.WorldViewSystemDataSet__c == null) {
                    wrf.addError('Data Files - You must select at least one WorldView System Data Set.');
                    v = false;
                }
                
                // check Country Selection count, should be at least 1 selection per CountrySelectorController
                // if there are no CountrySelectorController instances, then this loop will not be entered
                List<String> requestTypes = new List<String>();
                if(wrf.WorldViewSystemDataSet__c <> null && wrf.WorldViewSystemDataSet__c.contains('WorldView OE Parts Research'))
                    requestTypes.add('WorldView OE Parts Research');
                if(wrf.WorldViewSystemDataSet__c <> null && wrf.WorldViewSystemDataSet__c.contains('WorldView Global VIO'))
                    requestTypes.add('WorldView Global VIO');
                    
                for(String selectionRequestType: requestTypes) {
                    System.debug('Checking:  ' + selectionRequestType);
                    List<CountrySelection__c> countrySelections = [SELECT VehicleType__c 
                                                                    FROM CountrySelection__c
                                                                    WHERE WorkRequestForm__c =:wrf.Id
                                                                    AND RequestType__c includes (:selectionRequestType)];
                    System.debug('Getting selections for: ' + wrf.id);
                    
                    boolean hasSelections = false;
                    for(CountrySelection__c c : countrySelections) {
                        System.debug('Selection: ' + c);
                        if(!String.isEmpty(c.VehicleType__c)) {
                            hasSelections = true;
                            //System.debug('Found a selection with vehicle types: ' + c.VehicleType__c);
                            break;
                        }
                    }
                    
                    if(!hasSelections) {
                        v = false;
                        wrf.addError('Data Files - You must have at least one Market selection for the ' + selectionRequestType + ' Request.');
                    }
                }
                
                /*
                for (CountrySelectorController each : wrfCountrySelectors) {
                    if (each.hasSelections)
                        continue;
                    
                    wrf.addError('Data Files - You must have at least one Market selection for the ' + each.requestType + ' Request.');
                    v = false;
                }
                */
       
                // validation for WORLDVIEW NORTH AMERICA VIO data set...
                
                if (wrf.WorldViewSystemDataSet__c != null && wrf.WorldViewSystemDataSet__c.contains('WorldView North America VIO'))
                {
                    if(wrf.Geography__c == null) {
                        wrf.addError('Data Files - You must select one Geography.');
                        v = false;
                    }    
                    if(wrf.VIOSelection__c == 'Selected' && wrf.SelectedVIO__c == null){
                        wrf.addError('Data Files - You must enter the Selected WorldView North America VIO');
                        v = false;
                    }                
                    if(wrf.MotorcycleSelection__c == 'Selected' && wrf.SelectedMotorcycles__c == null){
                        wrf.addError('Data Files - You must enter the Selected Motorcycles');
                        v = false;
                    }
                    if (wrf.GVW__c == null ) {
                        wrf.addError('Data Files - You must select at least one VIN GVW/Category in the Vehicle Attributes section');
                        v = false;
                    }
                }
                // validation for WORLDVIEW GLOBAL VIO data set...
                if (wrf.WorldViewSystemDataSet__c != null && wrf.WorldViewSystemDataSet__c.contains('WorldView Global VIO'))
                {
                    if(wrf.PARCSelection__c == 'Selected' && wrf.SelectedPARC__c == null){
                        wrf.addError('Data Files - You must enter the Selected Global VIO');
                        v = false;
                    }                
                }
                // validation for WORLDVIEW OE PARTS RESEARCH data set...
                if (wrf.WorldViewSystemDataSet__c != null && wrf.WorldViewSystemDataSet__c.contains('WorldView OE Parts Research'))
                {
                    if(wrf.GAMSSelection__c == 'Selected' && wrf.SelectedGAMS__c == null){
                        wrf.addError('Data Files - You must enter the Selected OE Part Research');
                        v = false;
                    }                
                }
            } // END WORLDVIEW SYSTEM VALIDATION                                               
            
            //PARCDataFiles__c, MarketInsight VIO System
            if (wrf.PARCDataFiles__c == true)
            {
                String selectionRequestType='MarketInsight VIO System';
                List<CountrySelection__c> countrySelections = [SELECT VehicleType__c 
                                                                FROM CountrySelection__c
                                                                WHERE WorkRequestForm__c =:wrf.Id
                                                                AND RequestType__c includes (:selectionRequestType)];
                
                boolean hasSelections = false;
                for(CountrySelection__c c : countrySelections) {
                    if(!String.isEmpty(c.VehicleType__c)) {
                        hasSelections = true;
                        //System.debug('Found a selection with vehicle types: ' + c.VehicleType__c);
                        break;
                    }
                }
                
                if(!hasSelections) {
                    v = false;
                    wrf.addError('Data Files - You must have at least one Market selection for the ' + selectionRequestType + ' Request.');
                }
                
                /*
                for (CountrySelectorController each : wrfCountrySelectors) {
                    if (each.hasSelections)
                        continue;
                    
                    wrf.addError('You must have at least one Market selection for the ' + each.requestType + ' Request.');
                    v = false;
                }
                */
       
                if (wrf.GVW__c == null ) {
                    wrf.addError('Data Files - You must select at least one VIN GVW/Category in the Vehicle section');
                    v = false;
                }
                if(wrf.TimePeriodsAftermarket__c == null) {
                    wrf.addError('Data Files - You must select a Time Period.');
                    v = false;
                }   
                else if(wrf.TimePeriodsAftermarket__c.contains('Custom Selection (Use Textbox)') && wrf.TimePeriodDescription__c == null) {
                    wrf.addError('Data Files - You must and Specify Year Range for Custom Time Period Selection.');
                    v = false;
                }   
                
                if (wrf.CustomYearCoverage__c == true && (String.isBlank(wrf.CustomYearFrom__c) || String.isBlank(wrf.CustomYearTo__c))) {
                    wrf.addError('Data Files - You must enter a custom year range (From & To) when selecting Custom Year Coverage.');
                    v = false;
                }
                if (wrf.Periodicity__c == 'Other' && String.isBlank(wrf.CustomPeriodicity__c)) {
                    wrf.addError('Data Files - You must enter Custom Periodicity information when selecting a Periodicity of \'Other\'.');
                    v = false;
                }
                if (wrf.ForecastYears__c == 'Other' && String.isBlank(wrf.CustomForecastYears__c)) {
                    wrf.addError('Data Files - You must enter Custom Forecast Years information when selecting a Forecast Years of \'Other\'.');
                    v = false;
                }
                if (String.isBlank(wrf.OEMGeographyDetails__c) && wrf.CustomGeography__c) {
                    wrf.addError('Data Files - You must enter OEM Geography Details when selecting Custom Geography.');
                    v = false;
                }
                if (String.isBlank(wrf.VehicleSegmentationDetails__c) && (wrf.VehicleSegmentation__c != null && wrf.VehicleSegmentation__c.contains('Other'))) {
                    wrf.addError('Data Files - You must enter Vehicle Segmentation Details when selecting a Vehicle Segmentation of \'Other\'.');
                    v = false;
                }
                if (String.isBlank(wrf.CustomAgeClasses__c) && wrf.AgeClasses__c == 'Custom Age Classes') {
                    wrf.addError('Data Files - You must enter Custom Age Class details when selecting the Age Class value of \'Custom\'.');
                    v = false;
                }
                if (wrf.VehicleAttributesPARC__c == null && wrf.EssenVehicleAttributes__c == null) {
                    wrf.addError('Data Files - You must select a value from either the Southfield Vehicle Attributes Global VIO or the Essen Vehicle Attributes');
                    v = false;
                }
                
            } // END MARKETINSIGHT VIO SYSTEM VALIDATION 
            
            
            // Validation of Data Extract Global VIO (PARC)...
            if (wrf.DataExtractGlobalVIOPARC__c == true)
            {
                String selectionRequestType='Data Extract Global VIO (PARC)';
                List<CountrySelection__c> countrySelections = [SELECT VehicleType__c 
                                                                FROM CountrySelection__c
                                                                WHERE WorkRequestForm__c =:wrf.Id
                                                                AND RequestType__c includes (:selectionRequestType)];
                
                boolean hasSelections = false;
                for(CountrySelection__c c : countrySelections) {
                    if(!String.isEmpty(c.VehicleType__c)) {
                        hasSelections = true;
                        //System.debug('Found a selection with vehicle types: ' + c.VehicleType__c);
                        break;
                    }
                }
                
                if(!hasSelections) {
                    v = false;
                    wrf.addError('Data Files - You must have at least one Market selection for the ' + selectionRequestType + ' Request.');
                }
                
                /*
                for (CountrySelectorController each : wrfCountrySelectors) {
                    if (each.hasSelections)
                        continue;
                    
                    wrf.addError('You must have at least one Market selection for the ' + each.requestType + ' Request.');
                    v = false;
                }
                */
        
                if (wrf.CustomYearCoverage__c == true && (String.isBlank(wrf.CustomYearFrom__c) || String.isBlank(wrf.CustomYearTo__c))) {
                    wrf.addError('Data Files - You must enter a custom year range (From & To) when selecting Custom Year Coverage.');
                    v = false;
                }
                if (wrf.Periodicity__c == 'Other' && String.isBlank(wrf.CustomPeriodicity__c)) {
                    wrf.addError('Data Files - You must enter Custom Periodicity information when selecting a Periodicity of \'Other\'.');
                    v = false;
                }
                if (wrf.ForecastYears__c == 'Other' && String.isBlank(wrf.CustomForecastYears__c)) {
                    wrf.addError('Data Files - You must enter Custom Forecast Years information when selecting a Forecast Years of \'Other\'.');
                    v = false;
                }
                if (String.isBlank(wrf.OEMGeographyDetails__c) && wrf.CustomGeography__c) {
                    wrf.addError('Data Files - You must enter OEM Geography Details when selecting Custom Geography.');
                    v = false;
                }
                if (String.isBlank(wrf.VehicleSegmentationDetails__c) && (wrf.VehicleSegmentation__c != null && wrf.VehicleSegmentation__c.contains('Other'))) {
                    wrf.addError('Data Files - You must enter Vehicle Segmentation Details when selecting a Vehicle Segmentation of \'Other\'.');
                    v = false;
                }
                if (String.isBlank(wrf.CustomAgeClasses__c) && wrf.AgeClasses__c == 'Custom Age Classes') {
                    wrf.addError('Data Files - You must enter Custom Age Class details when selecting the Age Class value of \'Custom\'.');
                    v = false;
                }
                if (wrf.VehicleAttributesPARC__c == null && wrf.EssenVehicleAttributes__c == null) {
                    wrf.addError('Data Files - You must select a value from either the Southfield Vehicle Attributes Global VIO or the Essen Vehicle Attributes');
                    v = false;
                }
            } // END DATA EXTRACT GLOBAL VIO VALIDATION 
            
        } // END AFTERMARKET VALIDATION
        
        //Australia Requests Required Fields - Not Internal   
        if (wrf.FormType__c == 'Australia' && wrf.Internal__c == false) {
            
            if (wrf.AutoNews__c == false && wrf.MarketInsightSystem__c == false && wrf.DataExtractGlobalVIOPARC__c == false && wrf.DrivewayCalculator__c == false && wrf.Mapping__c == false && wrf.DMS__c == false && wrf.PS__c == false && wrf.VFacts__c == false && wrf.Vindicator__c == false && wrf.TableauVisualization__c == false) {
                wrf.addError('Job Overview - You must select one Request Type.');
                v = false;
            }          
            if (wrf.LicenseExpirationDate__c == null && wrf.MarketInsightSystem__c == true) {
                wrf.addError('Job Overview - A License Expiration Date is required to submit this request when Market Insight System is selected.');
                v = false;
            }                   
            
            // Validation of Vindicator requests...
            if (wrf.Vindicator__c == true)
            {
                if (wrf.DRDTTYPE__c == null) {
                    wrf.addError('Data Files - You must have at least one DRDTTYPE selection for the Vindicator Request.');
                    v = false;
                }
            }
            
            // Validation of Data Extract Global VIO (PARC)...
            if (wrf.DataExtractGlobalVIOPARC__c == true)
            {
                for (CountrySelectorController each : wrfCountrySelectors) {
                    if (each.hasSelections)
                      continue;
                    
                    wrf.addError('You must have at least one Market selection for the ' + each.requestType + ' Request.');
                    v = false;
                }
                if (wrf.CustomYearCoverage__c == true && (String.isBlank(wrf.CustomYearFrom__c) || String.isBlank(wrf.CustomYearTo__c))) {
                    wrf.addError('Data Files - You must enter a custom year range (From & To) when selecting Custom Year Coverage.');
                    v = false;
                }
                if (wrf.Periodicity__c == 'Other' && String.isBlank(wrf.CustomPeriodicity__c)) {
                    wrf.addError('Data Files - You must enter Custom Periodicity information when selecting a Periodicity of \'Other\'.');
                    v = false;
                }
                if (wrf.ForecastYears__c == 'Other' && String.isBlank(wrf.CustomForecastYears__c)) {
                    wrf.addError('Data Files - You must enter Custom Forecast Years information when selecting a Forecast Years of \'Other\'.');
                    v = false;
                }
                if (String.isBlank(wrf.OEMGeographyDetails__c) && wrf.CustomGeography__c) {
                    wrf.addError('Data Files - You must enter OEM Geography Details when selecting Custom Geography.');
                    v = false;
                }
                if (String.isBlank(wrf.VehicleSegmentationDetails__c) && (wrf.VehicleSegmentation__c != null && wrf.VehicleSegmentation__c.contains('Other'))) {
                    wrf.addError('Data Files - You must enter Vehicle Segmentation Details when selecting a Vehicle Segmentation of \'Other\'.');
                    v = false;
                }
                if (String.isBlank(wrf.CustomAgeClasses__c) && wrf.AgeClasses__c == 'Custom Age Classes') {
                    wrf.addError('Data Files - You must enter Custom Age Class details when selecting the Age Class value of \'Custom\'.');
                    v = false;
                }
                if (wrf.VehicleAttributesPARC__c == null && wrf.EssenVehicleAttributes__c == null) {
                    wrf.addError('Data Files - You must select a value from either the Southfield Vehicle Attributes Global VIO or the Essen Vehicle Attributes');
                    v = false;
                }
            } // END DATA EXTRACT GLOBAL VIO VALIDATION 
            
            // Validation of Market Insight System...
            if (wrf.MarketInsightSystem__c == true)
            {
                if (wrf.CustomYearCoverage__c == true && (String.isBlank(wrf.CustomYearFrom__c) || String.isBlank(wrf.CustomYearTo__c))) {
                    wrf.addError('Data Files - You must enter a custom year range (From & To) when selecting Custom Year Coverage.');
                    v = false;
                }
                if (wrf.Periodicity__c == 'Other' && String.isBlank(wrf.CustomPeriodicity__c)) {
                    wrf.addError('Data Files - You must enter Custom Periodicity information when selecting a Periodicity of \'Other\'.');
                    v = false;
                }
                if (wrf.ForecastYears__c == 'Other' && String.isBlank(wrf.CustomForecastYears__c)) {
                    wrf.addError('Data Files - You must enter Custom Forecast Years information when selecting a Forecast Years of \'Other\'.');
                    v = false;
                }
                if (String.isBlank(wrf.OEMGeographyDetails__c) && (wrf.CustomGeography__c || (wrf.PARCGeography__c != null && wrf.PARCGeography__c.contains('Other')))) {
                    wrf.addError('Data Files - You must enter OEM Geography Details when selecting Custom Geography or a PARC Geography of \'Other\'.');
                    v = false;
                }
                if (String.isBlank(wrf.VehicleSegmentationDetails__c) && (wrf.VehicleSegmentation__c != null && wrf.VehicleSegmentation__c.contains('Other'))) {
                    wrf.addError('Data Files - You must enter Vehicle Segmentation Details when selecting a Vehicle Segmentation of \'Other\'.');
                    v = false;
                }
                for (CountrySelectorController each : wrfCountrySelectors) {
                    if (each.hasSelections)
                        continue;
                    
                    wrf.addError('Data Files - You must have at least one Market selection for the ' + each.requestType + ' Request.');
                    v = false;
                }
            } // END MARKET INSIGHT SYSTEM VALIDATION 
            
        } // END AUSTRALIA VALIDATION
        
        //TIPNet Requests Required Fields - Not Internal    
        if (wrf.FormType__c == 'TIPNet' && wrf.Internal__c == false) {
            
            if (wrf.TIPNetSystem__c == false && wrf.Mapping__c == false && wrf.TableauVisualization__c == false) {
                wrf.addError('Job Overview You must select 1 Request Type.');
                v = false;
            }       
            if (wrf.TIPNetSystem__c == true && (wrf.StandardUS__c == null && wrf.StandardCanadian__c == null && wrf.CustomGeography__c == false )) {
                wrf.addError('Data Files - At least 1 Geography must be selected.');
                v = false;
            }
        }
        
        //Recall Requests Required Fields - Not Internal    
        if (wrf.FormType__c == 'Recall' && wrf.internal__c == false) {
            
            if (wrf.Recall__c == false && wrf.VINTrace__c == false && wrf.Mapping__c == false && wrf.Carb__c == false && wrf.TableauVisualization__c == false) {
                wrf.addError('Job Overview - You must select 1 Request Type.');
                v = false;
            }       
            if (wrf.Recall__c == true && wrf.JobTypeRecall__c == null) {
                wrf.addError('Data Files - You must pick 1 Job Type.');
                v = false;
            }
            if (wrf.Recall__c == true && wrf.MatchingOptions__c == null) {
                wrf.addError('Data Files - You must select Matching Options.');
                v = false;
            }
            if (wrf.Recall__c == true && wrf.MatchingOptions__c == 'Block Select (List VIN Patterns)' && wrf.VINPatterns__c == null) {
                wrf.addError('Data Files - You must List VIN Patterns if Matching Options is equal to Block Selection (List VIN Patterns).');
                v = false;
            }
            if (wrf.Recall__c == true && wrf.AdditionalInfoReturnedToClient__c == null) {
                wrf.addError('Data Files - You must select yes or no in Additional Info Returned to Client.');
                v = false;
            }
            if (wrf.Recall__c == true && wrf.DuplicateInProcessing__c == null) {
                wrf.addError('Data Files - You must select a Duplicate in Processing reason.');
                v = false;
            }
            if (wrf.Recall__c == true && wrf.BrandedTitleIndicator__c == null) {
                wrf.addError('Data Files - You must select a Branded Title Indicator reason.');
                v = false;
            }
            if (wrf.Recall__c == true && wrf.DetailBrandedTitleCoding__c == null) {
                wrf.addError('Data Files - You must select a Detail Branded Title Coding reason.');
                v = false;
            }
            if (wrf.Recall__c == true && wrf.NCOAProcessing__c == null) {
                wrf.addError('Data Files - You must select a NCOA Processing reason.');
                v = false;
            }
            if (wrf.Recall__c == true && wrf.NCOAProcessing__c == 'Process through NCOA' && (wrf.PAFExpireDate__c == null || wrf.PAF__c == null )) {
                wrf.addError('Data Files - You must list a PAF# and PAF Expire Date if you selected Process through NCOA.');
                v = false;
            }
            if (wrf.VINTrace__c == true && wrf.VehicleSelectionVIN__c == null) {
                wrf.addError('Data Files - You must pick 1 Vehicle Selection.');
                v = false;
            }
            if (wrf.VINTrace__c == true && wrf.OutputResults__c == null) {
                wrf.addError('Data Files - You must pick 1 Output Selection.');
                v = false;
            }
        }
        
        //CVG Global Requests Required Fields - Not Internal    
        if (wrf.FormType__c == 'CVGGlobal' && wrf.Internal__c == false) {                  
            
            if (wrf.TIPNetNewTruck__c == false && wrf.TIPNetNewTrailer__c == false && wrf.TIPNetVehiclesInOperation__c == false && wrf.NEWREGGlobal__c == false && wrf.PARCGlobal__c == false && wrf.ChinaCV__c == false && wrf.mapping__c == false && wrf.TableauVisualization__c == false) {
                wrf.addError('Job Overview - You must select 1 Request Type.');
                v = false;
            }       
            if ((wrf.TIPNetNewTrailer__c == true || wrf.TIPNetNewTruck__c == true || wrf.TIPNetVehiclesInOperation__c == true || wrf.NEWREGGlobal__c == true || wrf.PARCGlobal__c == true || wrf.ChinaCV__c == true) &&
                (wrf.US__c == false && wrf.Global__c == false && wrf.Canada__c == false && wrf.GeographyDetails__c == null)) {
                    wrf.addError('Data Files - At least 1 field in the Geography Section must be filled in.');
                    v = false;
                }
            if ((wrf.TIPNetNewTrailer__c == true || wrf.TIPNetNewTruck__c == true || wrf.TIPNetVehiclesInOperation__c == true || wrf.NEWREGGlobal__c == true || wrf.PARCGlobal__c == true || wrf.ChinaCV__c == true) && wrf.TimePeriodDescription__c == null) {
                wrf.addError('Data Files - Time Period must be filled in');
                v = false;
            }
            if ((wrf.TIPNetNewTrailer__c == true || wrf.TIPNetNewTruck__c == true || wrf.TIPNetVehiclesInOperation__c == true || wrf.NEWREGGlobal__c == true || wrf.PARCGlobal__c == true || wrf.ChinaCV__c == true) &&
                (wrf.SpecificVehicleSelections__c == 'yes' && wrf.Make__c == null && wrf.EngMFG__c == null && wrf.EngModel__c == null && wrf.BodyStyle__c == null && wrf.VocCode__c == null && wrf.CabConfig__c == null && wrf.Length__c == null && wrf.Model__c == null && wrf.VehicleType__c == null )) {
                    wrf.addError('Data Files - At least 1 field in the Vehicle Selection section must be filled in.');
                    v = false;
                }
            if ((wrf.TIPNetNewTrailer__c == true || wrf.TIPNetNewTruck__c == true || wrf.TIPNetVehiclesInOperation__c == true || wrf.NEWREGGlobal__c == true || wrf.PARCGlobal__c == true || wrf.ChinaCV__c == true) && (DFhasvalues == false )) {
                wrf.addError('Data Files - At least 1 Display field must be selected.');
                v = false;
            }
        }
        
        //Anlytics Requests Required Fields - Not Internal              
        
        if (wrf.FormType__c == 'Analytics' && wrf.Internal__c == false) {
            
            if (wrf.Loyalty__c == false && wrf.Profile__c == false && wrf.AdhocCustom__c == false && wrf.modelSegmentation__c == false && wrf.Mapping__c == false && wrf.TableauVisualization__c == false) {
                wrf.addError('Job Overview - You must select 1 Request Type.');
                v = false;
            }                           
            if (wrf.modelSegmentation__c == true && (wrf.ProjectBackground__c == null || wrf.AnalysisDependent__c == null || wrf.DataNeededfromInternalTeam__c == null || wrf.TimePeriodDescription__c == null || wrf.Deliverables__c == null) ) {
                wrf.addError('Data Files - Analysis Dependent, Data Needed from Internal Team, Time Period, Project Background, and Deliverables must be filled in.');
                v = false;
            }
            if (wrf.Loyalty__c == true && (wrf.DLEx__c == null && wrf.MLEx__c == null && wrf.CustomProductInfo__c == null) ) {
                wrf.addError('Data Files - You must fill out DLex, MLex or Custom Product Info.');
                v = false;
            }
            if (wrf.Loyalty__c == true && wrf.TimePeriodAnalytics__c == null ) {
                wrf.addError('Data Files - You must select a Time Period.');
                v = false;
            }
            if (wrf.Loyalty__c == true && wrf.TablesApprovedByClient__c == null ) {
                wrf.addError('Data Files - Yes or No required in Tables Approved by Client.');
                v = false;
            }
            if (wrf.Profile__c == true && wrf.ProjectBackground__c == null ) {
                wrf.addError('Data Files - Project Background must be filled out to submit this request.');
                v = false;
            }
            if (wrf.Profile__c == true && wrf.AnalysisDependent__c == null ) {
                wrf.addError('Data Files - Analystis Dependent must be Yes or No before submitting this request.');
                v = false;
            }
            if (wrf.Profile__c == true && wrf.DataNeededfromInternalTeam__c == null ) {
                wrf.addError('Data Files - Data needed from internal team must be Yes or No before submitting this request.');
                v = false;
            }                
        }
        
        //STAT Requests Required Fields - Not Internal              
        
        if (wrf.FormType__c == 'STAT' && wrf.Internal__c == false) {
            
            
            if (wrf.AdHocReport__c == false && wrf.PolkInsightProductionMessage__c == false && wrf.AutoTrackerReport__c == false && wrf.Mapping__c == false && wrf.NewRegNewFor__c == false && wrf.ChinaDataRequests__c ==  false && wrf.TableauVisualization__c == false) {
                wrf.addError('Job Overview - You must select 1 Request Type.');
                v = false;
            }
            if (wrf.AutoTrackerReport__c == true && wrf.AutoTrackerTimePeriod__c == null) {
                wrf.addError('Data Files - You must select a Time Period.');
                v = false;
            }
            if (wrf.PolkInsightProductionMessage__c == true && wrf.MessageOfTheDay__c == null) {
                wrf.addError('Data Files - You must select a Message of the Day.');
                v = false;
            }
            if (wrf.PolkInsightProductionMessage__c == true && wrf.OEMToSeeMessage__c == null) {
                wrf.addError('Data Files - You must enter an OEM.');
                v = false;
            }
            if (wrf.AdHocReport__c == true && wrf.DataType__c == null) {
                wrf.addError('Data Files - You must select a Data Type.');
                v = false;
            }
            if (wrf.AdHocReport__c == true && wrf.TimePeriod__c == null) {
                wrf.addError('Data Files - You must select a Time Period.');
                v = false;
            }
            if (wrf.AdHocReport__c == true && (wrf.RegistrationTypeStandard__c == null && wrf.VehicleSegmentationStandard__c == null)) {
                wrf.addError('Data Files - You must select a Registration Type or Vehicle Segmentation.');
                v = false;
            }
            if (wrf.AdHocReport__c == true && wrf.StandardUS__c == null && wrf.StandardCanadian__c == null && wrf.StandardPuertoRico__c == null && wrf.CustomGeography__c == false) {
                wrf.addError('Data Files - You must select a Geography.');
                v = false;
            }
            if (wrf.AdHocReport__c == true && wrf.CustomGeography__c == true && wrf.OEMGeographyDetails__c == null) {
                wrf.addError('Data Files - You must enter Custom Geography Details if you selected Custom Geography.');
                v = false;
            }
            if (wrf.AdHocReport__c == true && wrf.DataToBeDisplayed__c == null && wrf.StandardMotorcycle__c == null && wrf.Motorcycle__c == null ) {
                wrf.addError('Data Files - You must select at least 1 item in the Data to be Displayed section.');
                v = false;
            }
            
            /* Decomissioned 3/14/2016 by Bryan Fulton
               Tests indicate that this does not work.
               Investigation confirmed that this is no longer a business rule either.
            if (wrf.AdHocReport__c == true && Input_Files__c.number_of_records__c == null) {
                wrf.addError('Input Files - Add 1 Input file.');
                v = false;
            }
            */
      
        }
        
        
        
        //****************
        
        //Canada Requests Required Fields - Not Internal              
     
        if (wrf.FormType__c == 'Canada' && wrf.Internal__c == false) {
            
            
            if (wrf.AdHocReport__c == false && wrf.PolkInsightProductionMessage__c == false &&  wrf.FileCleanse__c == false && wrf.SmartLink__c ==  false && wrf.VINTrace__c ==  false && wrf.TableauVisualization__c == false) {
                wrf.addError('Job Overview - You must select 1 Request Type.');
                v = false;
            }
            if (wrf.AdHocReport__c == true && wrf.DataTypeCanada__c == null) {
                wrf.addError('Data Files - You must select a Data Type Canada.');
                v = false;
            }
            if (wrf.AdHocReport__c == true && wrf.TimePeriodCanada__c == null) {
                wrf.addError('Data Files - You must select a Time Period Canada.');
                v = false;
            }
            
            if (wrf.AdHocReport__c == true && (wrf.RegistrationTypeStandard__c == null || wrf.VehicleSegmentationStandard__c == null)) {
                wrf.addError('Data Files - You must select a Registration Type and Vehicle Segmentation.');
                v = false;
            }
            if (wrf.AdHocReport__c == true && (wrf.GeographyTypeCanada__c == null )) {
                wrf.addError('Data Files - You must select a Geography.');
                v = false;
            }
            if (wrf.AdHocReport__c == true && wrf.DataToBeDisplayedCanada__c == null ) {
                wrf.addError('Data Files - You must enter Data to be Displayed Canada.');
                v = false;
            }
            if (wrf.PolkInsightProductionMessage__c == true && wrf.OEMToSeeMessage__c == null ) {
                wrf.addError('Data Files - You must enter a Site to be Impacted.');
                v = false;
            }
            if (wrf.VINTrace__c == true && wrf.VehicleSelectionVINCanada__c == null ) {
                wrf.addError('Data Files - You must enter Vehicle Selection VIN.');
                v = false;
            }
            if (wrf.VINTrace__c == true && wrf.OutputResults__c == null ) {
                wrf.addError('Data Files - You must enter Output Results.');
                v = false;
            }                
            if (wrf.SmartLink__c == true && wrf.DataNeededDescription__c == null ) {
                wrf.addError('Data Files - You must enter Detailed Instructions.');
                v = false;
            }  
            if (wrf.FileCleanse__c == true && wrf.DetailedInstructions__c == null ) {
                wrf.addError('Data Files - You must enter Detailed Instructions.');
                v = false;
            }                  
            
            
            
        }
        
        
        
        //****************           
        
        
        
        
        //Sales Match Requests Required Fields - Not Internal               
        
        if (wrf.FormType__c == 'Sales Match' && wrf.Internal__c == false) {
            
            if (wrf.TLAS__c == false && wrf.SalesMatch__c == false && wrf.ListRequest__c == false && wrf.Mapping__c == false && wrf.TableauVisualization__c == false) {
                wrf.addError('Job Overview - You must select 1 Request Type.');
                v = false;
            }
        }
        
        //Parts & Service Requests Required Fields               
        
        if (wrf.FormType__c == 'Parts & Service' || wrf.FormType__c == 'NOC') {
            
            if (wrf.Name == null) {
                wrf.addError('Job Overview - You must enter a Job Name.');
                v = false;
            }
            if (wrf.JobType__c == null) {
                wrf.addError('Job Overview - You must Select a Job Type.');
                v = false;
            }
            if (wrf.RequestedDueDate__c == null) {
                wrf.addError('Job Overview - You must enter a Request Due Date.');
                v = false;
            }
            if (wrf.Priority__c == null) {
                wrf.addError('Job Overview - You must enter a Priority.');
                v = false;
            }
        }
        
        //NewUsed Registration Requests Required Fields               
        
        if (wrf.FormType__c == 'NewUsed Registration') {
            if ( wrf.NewRegSystem__c == false && wrf.MarketInsightSystem__c == false &&
                 wrf.DataExtractNewReg__c == false && wrf.TableauVisualization__c == false) {
                wrf.addError('Job Overview - You must select 1 Request Type.'); 
                v = false;      
            }
            
            if (wrf.CustomYearCoverage__c == true && (String.isBlank(wrf.CustomYearFrom__c) || String.isBlank(wrf.CustomYearTo__c))) {
                wrf.addError('Data Files - You must enter a custom year range (From & To) when selecting Custom Year Coverage.');
                v = false;
            }
            if (wrf.Periodicity__c == 'Other' && String.isBlank(wrf.CustomPeriodicity__c)) {
                wrf.addError('Data Files - You must enter Custom Periodicity information when selecting a Periodicity of \'Other\'.');
                v = false;
            }
            if (wrf.ForecastYears__c == 'Other' && String.isBlank(wrf.CustomForecastYears__c)) {
                wrf.addError('Data Files - You must enter Custom Forecast Years information when selecting a Forecast Years of \'Other\'.');
                v = false;
            }
            if (String.isBlank(wrf.OEMGeographyDetails__c) && (wrf.CustomGeography__c || (wrf.PARCGeography__c != null && wrf.PARCGeography__c.contains('Other')))) {
                wrf.addError('Data Files - You must enter OEM Geography Details when selecting Custom Geography or a PARC Geography of \'Other\'.');
                v = false;
            }
            if (String.isBlank(wrf.VehicleSegmentationDetails__c) && (wrf.VehicleSegmentation__c != null && wrf.VehicleSegmentation__c.contains('Other'))) {
                wrf.addError('Data Files - You must enter Vehicle Segmentation Details when selecting a Vehicle Segmentation of \'Other\'.');
                v = false;
            }
            
            /*
            for (CountrySelectorController each : wrfCountrySelectors) {
                if (each.hasSelections)
                    continue;
                
                wrf.addError('Data Files - You must have at least one Market selection for the ' + each.requestType + ' Request.');
                v = false;
            }
            */
   
            //Does this wrf have country selections for the request type?
            //a request type must be selected to check this
            
            if(wrf.MarketInsightSystem__c || wrf.NewRegSystem__c || wrf.DataExtractNewReg__c) {
                String selectionRequestType;
                if(wrf.MarketInsightSystem__c) 
                    selectionRequestType = 'MarketInsight System';
                else if (wrf.NewRegSystem__c)
                    selectionRequestType = 'New Reg System';
                else
                    selectionRequestType = 'Data Extract';
                
                List<CountrySelection__c> countrySelections = [SELECT VehicleType__c 
                                                                FROM CountrySelection__c
                                                                WHERE WorkRequestForm__c =:wrf.Id
                                                                AND RequestType__c includes (:selectionRequestType)];
                
                boolean hasSelections = false;
                for(CountrySelection__c c : countrySelections) {
                    if(!String.isEmpty(c.VehicleType__c)) {
                        hasSelections = true;
                        System.debug('Found a selection with vehicle types: ' + c.VehicleType__c);
                        break;
                    }
                }
                
                if(!hasSelections) {
                    v = false;
                    wrf.addError('Data Files - You must have at least one Market selection for the ' + selectionRequestType + ' Request.');
                }
            }
        }
        
        //APAC Requests Required Fields - Not Internal
        if(wrf.FormType__c == 'APAC' && wrf.Internal__c == false) {
            //if all request types are blank
            if (wrf.AdHocReport__c == false && wrf.ChinaDataRequests__c == false &&
                wrf.PolkInsightChinaSystem__c == false && wrf.MarketInsightSystem__c == false &&
                wrf.DataExtractNewReg__c == false && wrf.ChinaCV__c == false &&
                wrf.DataExtractGlobalVIOPARC__c == false && wrf.Mapping__c == false
                && wrf.WorldviewVIO__c == false && wrf.TableauVisualization__c == false) {
                    
                    wrf.addError('Job Overview - You must select 1 Request Type.');
                    v = false;
                }
            
            //Validation for Market Insight System
            if (wrf.LicenseExpirationDate__c == null && wrf.MarketInsightSystem__c == true) {
                wrf.addError('Job Overview - A License Expiration Date is required to submit this request when Market Insight System is selected.');
                v = false;
            }      
            //END Validation for Market Insight System
            
            // Validation of Data Extract Global VIO (PARC)...
            if (wrf.DataExtractGlobalVIOPARC__c == true)
            { 
                for (CountrySelectorController each : wrfCountrySelectors) {       
                    //Only validate country selectors that belong to this request type
                    //Added to prevent conflict with Market Insight Data Extract validation - BF 5/19/2016
                  boolean correctRequestType = each.requestType != null && each.requestType.contains('Data Extract Global VIO (PARC)');
                    if ((each.hasSelections && correctRequestType) || !correctRequestType)
                        continue;
                    
                    wrf.addError('You must have at least one Market selection for the ' + each.requestType + ' Request.');
                    v = false;
                }
                
                if (wrf.CustomYearCoverage__c == true && (String.isBlank(wrf.CustomYearFrom__c) || String.isBlank(wrf.CustomYearTo__c))) {
                    wrf.addError('Data Files - You must enter a custom year range (From & To) when selecting Custom Year Coverage.');
                    v = false;
                }
                if (wrf.Periodicity__c == 'Other' && String.isBlank(wrf.CustomPeriodicity__c)) {
                    wrf.addError('Data Files - You must enter Custom Periodicity information when selecting a Periodicity of \'Other\'.');
                    v = false;
                }
                if (wrf.ForecastYears__c == 'Other' && String.isBlank(wrf.CustomForecastYears__c)) {
                    wrf.addError('Data Files - You must enter Custom Forecast Years information when selecting a Forecast Years of \'Other\'.');
                    v = false;
                }
                if (String.isBlank(wrf.OEMGeographyDetails__c) && wrf.CustomGeography__c) {
                    wrf.addError('Data Files - You must enter OEM Geography Details when selecting Custom Geography.');
                    v = false;
                }
                if (String.isBlank(wrf.VehicleSegmentationDetails__c) && (wrf.VehicleSegmentation__c != null && wrf.VehicleSegmentation__c.contains('Other'))) {
                    wrf.addError('Data Files - You must enter Vehicle Segmentation Details when selecting a Vehicle Segmentation of \'Other\'.');
                    v = false;
                }
                if (String.isBlank(wrf.CustomAgeClasses__c) && wrf.AgeClasses__c == 'Custom Age Classes') {
                    wrf.addError('Data Files - You must enter Custom Age Class details when selecting the Age Class value of \'Custom\'.');
                    v = false;
                }
                if (wrf.VehicleAttributesPARC__c == null && wrf.EssenVehicleAttributes__c == null) {
                    wrf.addError('Data Files - You must select a value from either the Southfield Vehicle Attributes Global VIO or the Essen Vehicle Attributes');
                    v = false;
                }
            } // END DATA EXTRACT GLOBAL VIO VALIDATION 
            
            //Validation for Report (Ad Hoc Report)
            if(wrf.AdHocReport__c){
                if (wrf.DataType__c == null) {
                    wrf.addError('Data Files - You must select a Data Type.');
                    v = false;
                }
                if (wrf.TimePeriod__c == null) {
                    wrf.addError('Data Files - You must select a Time Period.');
                    v = false;
                }
                if (wrf.RegistrationTypeStandard__c == null && wrf.VehicleSegmentationStandard__c == null) {
                    wrf.addError('Data Files - You must select a Registration Type or Vehicle Segmentation.');
                    v = false;
                }
                if (wrf.StandardUS__c == null && wrf.StandardCanadian__c == null && wrf.StandardPuertoRico__c == null && wrf.CustomGeography__c == false) {
                    wrf.addError('Data Files - You must select a Geography.');
                    v = false;
                }
                if (wrf.CustomGeography__c == true && wrf.OEMGeographyDetails__c == null) {
                    wrf.addError('Data Files - You must enter Custom Geography Details if you selected Custom Geography.');
                    v = false;
                }
                if (wrf.DataToBeDisplayed__c == null && wrf.StandardMotorcycle__c == null && wrf.Motorcycle__c == null ) {
                    wrf.addError('Data Files - You must select at least 1 item in the Data to be Displayed section.');
                    v = false;
                }
            }
            //END REPORT VALIDATION
            
            //Validation for Global New/Used Registration
            if(wrf.MarketInsightSystem__c || wrf.DataExtractNewReg__c) {
                
                if (wrf.CustomYearCoverage__c == true && (String.isBlank(wrf.CustomYearFrom__c) || String.isBlank(wrf.CustomYearTo__c))) {
                    wrf.addError('Data Files - You must enter a custom year range (From & To) when selecting Custom Year Coverage.');
                    v = false;
                }
                
                if (wrf.Periodicity__c == 'Other' && String.isBlank(wrf.CustomPeriodicity__c)) {
                    wrf.addError('Data Files - You must enter Custom Periodicity information when selecting a Periodicity of \'Other\'.');
                    v = false;
                }
                
                if (wrf.ForecastYears__c == 'Other' && String.isBlank(wrf.CustomForecastYears__c)) {
                    wrf.addError('Data Files - You must enter Custom Forecast Years information when selecting a Forecast Years of \'Other\'.');
                    v = false;
                }
                if (String.isBlank(wrf.OEMGeographyDetails__c) && (wrf.CustomGeography__c || (wrf.PARCGeography__c != null && wrf.PARCGeography__c.contains('Other')))) {
                    wrf.addError('Data Files - You must enter OEM Geography Details when selecting Custom Geography or a PARC Geography of \'Other\'.');
                    v = false;
                }
                if (String.isBlank(wrf.VehicleSegmentationDetails__c) && (wrf.VehicleSegmentation__c != null && wrf.VehicleSegmentation__c.contains('Other'))) {
                    wrf.addError('Data Files - You must enter Vehicle Segmentation Details when selecting a Vehicle Segmentation of \'Other\'.');
                    v = false;
                }

                String requestType = wrf.MarketInsightSystem__c ? 'MarketInsight System' : 'Data Extract';
                for (CountrySelectorController each : wrfCountrySelectors) {
                    //Only validate country selectors that belong to this request type
                    //Added to prevent conflict with Data Extract Global VIO (PARC) validation - BF 5/19/2016
                    boolean correctRequestType = each.requestType != null && each.requestType.contains(requestType)
                                                 && !each.requestType.contains('VIO');
                    if ((each.hasSelections && correctRequestType) || !correctRequestType)
                        continue;
                    
                    wrf.addError('Data Files - You must have at least one Market selection for the ' + each.requestType + ' Request.');
                    v = false;
                }
            }
            //END NEW/USED VALIDATION
            
            //Validation for China CV Data Extract
            if(wrf.ChinaCV__c){
                if (wrf.US__c == false && wrf.Global__c == false && wrf.Canada__c == false && wrf.GeographyDetails__c == null) {
                    wrf.addError('Data Files - At least 1 field in the Geography Section must be filled in.');
                    v = false;
                }
                if (wrf.TimePeriodDescription__c == null) {
                    wrf.addError('Data Files - Time Period must be filled in');
                    v = false;
                }
                if (wrf.SpecificVehicleSelections__c == 'yes' && wrf.Make__c == null && wrf.EngMFG__c == null && 
                    wrf.EngModel__c == null && wrf.BodyStyle__c == null && wrf.VocCode__c == null && wrf.CabConfig__c == null && 
                    wrf.Length__c == null && wrf.Model__c == null && wrf.VehicleType__c == null ) {
                        
                        wrf.addError('Data Files - At least 1 field in the Vehicle Selection section must be filled in.');
                        v = false;
                    }
                if (DFhasvalues == false) {
                    wrf.addError('Data Files - At least 1 Display field must be selected.');
                    v = false;
                }
            }
            //END CHINA CV VALIDATION
            
            //WorldviewVIO__c, WorldView System
            if (wrf.WorldviewVIO__c == true)
            {
                // check time periods
                if(wrf.TimePeriodsAftermarket__c == null) {
                    wrf.addError('Data Files - You must select a Time Period.');
                    v = false;
                }   
                else if(wrf.TimePeriodsAftermarket__c.contains('Custom Selection (Use Textbox)') && wrf.TimePeriodDescription__c == null) {
                    wrf.addError('Data Files - You must and Specify Year Range for Custom Time Period Selection.');
                    v = false;
                }   
                // check WorldView System Data Set
                if (wrf.WorldViewSystemDataSet__c == null) {
                    wrf.addError('Data Files - You must select at least one WorldView System Data Set.');
                    v = false;
                }
            
                if (wrf.LicenseExpirationDate__c == null) {
                    wrf.addError('Job Overview - A License Expiration Date is required when Worldview request types are selected to submit this request.');
                    v = false;
                }
                
                // check Country Selection count, should be at least 1 selection per CountrySelectorController
                // if there are no CountrySelectorController instances, then this loop will not be entered
                for (CountrySelectorController each : wrfCountrySelectors) {
                    boolean correctRequestType = each.requestType != null && (each.requestType.contains('WorldView Global VIO')
                                                                              ||each.requestType.contains('WorldView OE Parts Research'));
                    if ((each.hasSelections && correctRequestType) || !correctRequestType)
                        continue;
                    
                    wrf.addError('Data Files - You must have at least one Market selection for the ' + each.requestType + ' Request.');
                    v = false;
                }
                
                // validation for WORLDVIEW NORTH AMERICA VIO data set...
                if (wrf.WorldViewSystemDataSet__c != null && wrf.WorldViewSystemDataSet__c.contains('WorldView North America VIO'))
                {
                    if(wrf.Geography__c == null) {
                        wrf.addError('Data Files - You must select one Geography.');
                        v = false;
                    }    
                    if(wrf.VIOSelection__c == 'Selected' && wrf.SelectedVIO__c == null){
                        wrf.addError('Data Files - You must enter the Selected WorldView North America VIO');
                        v = false;
                    }                
                    if(wrf.MotorcycleSelection__c == 'Selected' && wrf.SelectedMotorcycles__c == null){
                        wrf.addError('Data Files - You must enter the Selected Motorcycles');
                        v = false;
                    }
                    if (wrf.GVW__c == null ) {
                        wrf.addError('Data Files - You must select at least one VIN GVW/Category in the Vehicle Attributes section');
                        v = false;
                    }
                }
                // validation for WORLDVIEW GLOBAL VIO data set...
                if (wrf.WorldViewSystemDataSet__c != null && wrf.WorldViewSystemDataSet__c.contains('WorldView Global VIO'))
                {
                    if(wrf.PARCSelection__c == 'Selected' && wrf.SelectedPARC__c == null){
                        wrf.addError('Data Files - You must enter the Selected Global VIO');
                        v = false;
                    }                
                }
                // validation for WORLDVIEW OE PARTS RESEARCH data set...
                if (wrf.WorldViewSystemDataSet__c != null && wrf.WorldViewSystemDataSet__c.contains('WorldView OE Parts Research'))
                {
                    if(wrf.GAMSSelection__c == 'Selected' && wrf.SelectedGAMS__c == null){
                        wrf.addError('Data Files - You must enter the Selected OE Part Research');
                        v = false;
                    }                
                }
            } // END WORLDVIEW SYSTEM VALIDATION  
        }
        //END APAC Requests Required Fields - Not Internal
        
        //UK Requests Required Fields - Not Internal
        if(wrf.FormType__c == 'UK') {
            
            if(!wrf.Analytics__c &&!wrf.PolkConnectSystem__c && !wrf.TableauVisualization__c) {
                wrf.addError('Job Overview - You must select a request type.');
                v = false;
            }
            
            //Analytics
            if(wrf.Analytics__c && wrf.Internal__c == false) {
                if(String.isEmpty(wrf.Billable__c)) {
                    wrf.addError('Job Overview - You must supply a value for Billable.');
                    v = false;  
                }
                
                if(String.isEmpty(wrf.ReportName__c)) {
                    wrf.addError('Data Files - You must supply a Report Name.');
                    v = false;
                }
                
                if(String.isEmpty(wrf.ReasonForRequirement__c)) {
                    wrf.addError('Data Files - You must supply a Reason for Requirement.');
                    v = false;
                }
                
                /*
                if(wrf.StartDate__c == null) {
                    wrf.addError('Data Files - You must supply an Invoice Start Date.');
                    v = false;
                }
                
                if(wrf.EndDate__c == null) {
                    wrf.addError('Data Files - You must supply an Invoice End Date.');
                    v = false;
                }
                */
    
                if(wrf.StartDate__c <> null && wrf.EndDate__c <> null && wrf.StartDate__c > wrf.EndDate__c) {
                    wrf.addError('Data Files - The Invoice Start Date cannot come before the Invoice End Date.');
                    v = false;
                }
                
                if(String.isEmpty(wrf.VehicleModels__c) && String.isEmpty(wrf.ModelYears__c) && wrf.modelSegmentation__c) {
                    wrf.addError('Data Files - You must supply Vehicle Models and/or Model Years when specifying Model/Age Specific.');
                    v = false;
                }
                
                if(String.isEmpty(wrf.DMSCodes__c) && wrf.DMSCodesProvided__c) {
                    wrf.addError('Data Files - You must supply DMS Codes when specifying DMS.');
                    v = false;
                }
                
                if(String.isEmpty(wrf.SearchText__c) && wrf.KeywordTextSearchRequired__c) {
                    wrf.addError('Data Files - You must supply Search Text when requiring Keyword/Text Search.');
                    v = false;
                }
                
                if(String.isEmpty(wrf.Retailers__c)) {
                        wrf.addError('Data Files - You must select a value for Retailers.');
                        v = false;
                }
                        
                if(String.isEmpty(wrf.SpecificRetailers__c) && wrf.Retailers__c == 'Specific') {
                    wrf.addError('Data Files - You must supply Specific Retailers when specifying Retailers.');
                    v = false;
                }
                
                if(String.isEmpty(wrf.EventJobTypes__c) && wrf.EventJobTypeSpecific__c == 'Specific') {
                    wrf.addError('Data Files - You must supply Event/Job Types when selecting Specific Event/Job Types.');
                    v = false;
                }
                
                if(String.isEmpty(wrf.Campaigns__c) && wrf.CampaignSpecificReport__c) {
                    wrf.addError('Data Files - You must supply Campaigns when specifying Campaign Specific Report.');
                    v = false;
                }
                
                
                /*
                if(String.isEmpty(wrf.Department_Type__c)) {
                        wrf.addError('Data Files - You must select a value for Department Type.');
                        v = false;
                }
                
                if(String.isEmpty(wrf.Payment_Type__c)) {
                        wrf.addError('Data Files - You must select a value for Payment Type.');
                        v = false;
                }
                
                if(String.isEmpty(wrf.Document_Type__c)) {
                        wrf.addError('Data Files - You must select a value for Document Type.');
                        v = false;
                }
                
                if(String.isEmpty(wrf.ItemLineType__c)) {
                        wrf.addError('Data Files - You must select a value for Item Line Type.');
                        v = false;
                }
                */
                  
                if(!String.isEmpty(wrf.ItemLineType__c) && wrf.ItemLineType__c.contains('Other')
                   && String.isEmpty(wrf.OtherItemLineType__c)) {
                        wrf.addError('Data Files - You must supply Other Item Line Type when selecting Other for Item Line Type.');
                        v = false;
                }
                
            }
            //End Analytics
            
            //PolkConnect System
            if(wrf.PolkConnectSystem__c) {
                
                //replicating job overview validation even for internal requests
                //only applies to this request type on this form
                if(wrf.Internal__c == true) {
                    //just for consistency
                    if(String.isEmpty(wrf.RoyaltyVendor__c)) {
                        wrf.RoyaltyVendor__c='No Royalty Data';
                    }
                    
                    //Job Name
                    if (wrf.Name == null) {
                        wrf.addError ('Job Overview - A job name is required to submit this request.');
                        v = false;
                    }
                    //Primary Sales Contact
                    if (wrf.PrimarySalesContact__c == null) {
                        wrf.addError('Job Overview - A Primary Sales Contact is required to submit this request.');
                        v = false;
                    }
                    //Requested Due Date
                    if (wrf.RequestedDueDate__c == null) {
                        wrf.addError('Job Overview - A Requested Due Date is required to submit this request.');
                        v = false;
                    }
                }
                
                if (wrf.Priority__c == null) {
                    wrf.addError('Job Overview - You must enter a Priority.');
                    v = false;
                }
                
                
                /* Removed by request 10/27/2016 - BF
                if(wrf.PolkConnectSystem__c && String.isEmpty(wrf.LicenseEndDate__c)) {
                    wrf.addError('Job Overview - You must select a License End Date to submit this request.');
                    v = false;
                }
                */
   
                if(String.isEmpty(wrf.Brand__c)) {
                    wrf.addError('Data Files - You must select a Brand.');
                    v = false;
                }
                
                if(String.isEmpty(wrf.JobTypeUK__c)) {
                    wrf.addError('Data Files - You must select a Job Type.');
                    v = false;
                }
                
                if(String.isEmpty(wrf.Application__c)) {
                    wrf.addError('Data Files - You must select an Application.');
                    v = false;
                }           
                
                if(!String.isEmpty(wrf.JobTypeUK__c) && wrf.JobTypeUK__c.contains('Other') &&
                    String.isEmpty(wrf.OtherJobTypeUK__c)) {
                    
                    wrf.addError('Data Files - You must fill out Other Job Type when selecting Other as the Job Type.');
                    v = false;
                }
                
                if(String.isEmpty(wrf.ClientId__c)) {
                    wrf.addError('Data Files - You must supply a Client Id.');
                    v = false;
                }
                
                if(String.isEmpty(wrf.DetailedInstructions__c)) {
                    wrf.addError('Data Files - You must Date Ranges for the selected Job Types.');
                    v = false;
                }
            }
            //End PolkConnect System
        }
        //END UK Requests Required Fields - Not Internal
        
        return v;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: workrequestform__c wrf
    // @description:  This method is used in POLK WRF.
    // @return: id 
	// @Modification : replaced wrfOwnerRole with wrfOwnerRegion.Now queue is being assined on basis of wrfOwnerRegion and not wrfOwnerRole .
	// @Modified by : Ankita Singh 20th Nov,2017
    //----------------------------- 
    
    public static id ProductionQueue(workrequestform__c wrf) {
        User wrfOwner;
        //    String wrfOwnerRole='';
        String wrfOwnerRegion='';
        User[] OwnerList = [select id,userroleid,userrole.name,UserRegion__c from user where id=:wrf.ownerid];
        if(OwnerList.size()>0){
            wrfOwner= OwnerList[0];
            if(wrfOwner.UserRegion__c !=null){
                //   wrfOwnerRole=wrfOwner.userrole.name;
                wrfOwnerRegion= wrfOwner.UserRegion__c;
            }
        }else{
            wrfOwner= [select id,userroleid,userrole.name,UserRegion__c from user where id=:Userinfo.getUserid() LIMIT 1];
            if(wrfOwner.UserRegion__c !=null){
                // wrfOwnerRole=wrfOwner.userrole.name;
                wrfOwnerRegion= wrfOwner.UserRegion__c;
            }
        }
        Map<String, ID> queueMAP = new Map<String, ID>();
        for(group g:[select id,name from Group where Type='Queue']){
            queueMAP.put(g.name,g.id);
        }
        
        //no matter the form type, if it only contains a visualization request
        //then map it to the visualization queue
        if(wrf.TableauVisualization__c == true && visualizationOnly(wrf)) {
            wrf.ownerid = queueMAP.containsKey('Visualization')? queueMap.get('Visualization') : wrf.ownerid;
        }
        
        else if(wrf.FormType__c=='Analytics' && wrf.Loyalty__c == false ){          
            wrf.ownerid =queueMAP.containsKey('Market Reporting - Analytics')?queueMAP.get('Market Reporting - Analytics')  :   wrf.ownerid;        
        }
        
        else if( wrf.FormType__c=='Continental Tire Aftermarket'
                || wrf.FormType__c=='CVGGlobal' || wrf.FormType__c=='NVPPOnline' || wrf.FormType__c=='TIPNet') {
                    wrf.ownerid =queueMAP.containsKey('Market Reporting - CAP' )?queueMAP.get( 'Market Reporting - CAP')  :   wrf.ownerid;    
                }
        
        else if(wrf.FormType__c=='Analytics' && wrf.Loyalty__c == true ){
            wrf.ownerid =queueMAP.containsKey('Market Reporting - Loyalty' )?queueMAP.get('Market Reporting - Loyalty')  :   wrf.ownerid; 
        }
        
        else if(wrf.FormType__c=='Stat'){
            wrf.ownerid =queueMAP.containsKey('Market Reporting - OEM Stat' )?queueMAP.get('Market Reporting - OEM Stat' )  :   wrf.ownerid; 
        }
        
        //ELS Added 10/16/2014 for CAN WRF
        else if(wrf.FormType__c=='Canada'){
            wrf.ownerid =queueMAP.containsKey('Canada' )?queueMAP.get('Canada' )  :   wrf.ownerid; 
        }
        
        else if(wrf.FormType__c=='Software Services'){
            wrf.ownerid =queueMAP.containsKey('VINtelligence - SWS' )?queueMAP.get('VINtelligence - SWS' )  :   wrf.ownerid; 
        }
        
        else if(wrf.FormType__c=='Recall'){
            wrf.ownerid =queueMAP.containsKey('VINtelligence - Recall' )?queueMAP.get('VINtelligence - Recall' )  :   wrf.ownerid; 
        }
        
        else if(wrf.FormType__c=='Parts & Service'){
            wrf.ownerid =queueMAP.containsKey('VINtelligence - Recall'  )?queueMAP.get('VINtelligence - Recall' )  :   wrf.ownerid; 
        }
        
        else if(wrf.FormType__c=='Sales Match' || wrf.FormType__c=='NOC' || wrf.FormType__c=='TLAS'  ){
            //ELS Name Change 7/17/2012
            //wrf.ownerid =[Select id From Group where Type='Queue' and name='Multichannel Marketing' LIMIT 1 ].id;
            wrf.ownerid =queueMAP.containsKey('MCM - Analytics' )?queueMAP.get('MCM - Analytics' )  :   wrf.ownerid; 
        }
        
        else if(wrf.FormType__c=='Aftermarket' ) {
            
            if( (wrf.DataExtractGlobalVIOPARC__c && (wrfOwnerRegion.contains('EMEA') || wrfOwnerRegion.contains('EU') ) ) 
               || wrf.PARCDataFiles__c){
                   wrf.ownerid =queueMAP.containsKey('European WRF' )?queueMAP.get('European WRF' )  :   wrf.ownerid; 
                   
                   
               } else if(wrf.Mapping__c) {
                   wrf.ownerid =queueMAP.containsKey('Jeff Allen' )?queueMAP.get('Jeff Allen' )  :   wrf.ownerid; 
               } else {
                   wrf.ownerid =queueMAP.containsKey('Market Reporting - CAP' )?queueMAP.get('Market Reporting - CAP' )  :   wrf.ownerid; 
               }
        }
        
        else if (wrf.FormType__c == 'NewUsed Registration') {
            wrf.ownerid =queueMAP.containsKey('European WRF' )?queueMAP.get('European WRF' )  :   wrf.ownerid; 
        }
        
        else if (wrf.FormType__c == 'Australia') {
            wrf.ownerid = queueMAP.containsKey('Australia WRF' )? queueMAP.get('Australia WRF') : wrf.ownerid; 
        }
        
        else if (wrf.FormType__c == 'APAC') {
            //Essen fulfillment = European WRF queue
            //Southfield fulfillment = Market Reporting CAP queue
            //Local fulfillment = APAC WRF queue
            //Mapping = Jason Pang
            
            if(wrf.AdHocReport__c || wrf.ChinaDataRequests__c || wrf.ChinaCV__c) {
                wrf.ownerid =queueMAP.containsKey('APAC WRF')?queueMAP.get('APAC WRF') : wrf.ownerid; 
            } else if (wrf.MarketInsightSystem__c || wrf.DataExtractNewReg__c) {
                wrf.ownerid =queueMAP.containsKey('European WRF')?queueMAP.get('European WRF') : wrf.ownerid; 
            } else if (wrf.DataExtractGlobalVIOPARC__c) {
                //Eu / APAC
                if(wrfOwnerRegion.contains('EMEA') || wrfOwnerRegion.contains('EU') || wrfOwnerRegion.contains('APAC')) {
                    
                    wrf.ownerid =queueMAP.containsKey('European WRF')?queueMAP.get('European WRF') : wrf.ownerid; 
                } else { //Us--default
                    wrf.ownerid =queueMAP.containsKey('Market Reporting - CAP' )?queueMAP.get('Market Reporting - CAP' )  :   wrf.ownerid; 
                }
            } else if (wrf.Mapping__c) {
                //Do nothing, Workflow Rule is handling it.
            } else if (wrf.PolkInsightChinaSystem__c) {
                wrf.ownerid =queueMAP.containsKey('Market Reporting - OEM Stat')?queueMAP.get('Market Reporting - OEM Stat') : wrf.ownerid; 
            } else if (wrf.WorldviewVIO__c) {
                wrf.ownerid =queueMAP.containsKey('Market Reporting - CAP')?queueMAP.get('Market Reporting - CAP') : wrf.ownerid; 
            } else {
                wrf.ownerid = queueMAP.containsKey('Salesforce Support')?queueMAP.get('Salesforce Support') : wrf.ownerid; 
            }
        }
        else if (wrf.FormType__c == 'UK') {
            if(wrf.Analytics__c) {
                wrf.ownerid = queueMAP.containsKey('PolkConnect Analytics')?queueMAP.get('PolkConnect Analytics') : wrf.ownerid; 
            } else if (wrf.PolkConnectSystem__c) {
                wrf.ownerid = queueMAP.containsKey('PolkConnect System')?queueMAP.get('PolkConnect System') : wrf.ownerid; 
            }
        }
        else {
            wrf.ownerid = UserInfo.getUserId();
        }
        
        return wrf.OwnerID;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: workrequestform__c wrf
    // @description:  This method is used in POLK WRF.
    // @return: boolean 
    //----------------------------- 
    private static boolean visualizationOnly(workrequestform__c wrf) {
        if(wrf.TableauVisualization__c == true) {
            //check if it has anything besides Tableau Visualization
            return !hasOtherRequests(wrf, new Set<String>{'TableauVisualization__c'});
        }
        return false;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: workrequestform__c wrf
    // @description:  This method is used in POLK WRF.
    // @return: boolean 
    //----------------------------- 
    private static boolean ignoresRoyalties(workrequestform__c wrf) {
        Set<String> requestsToIgnore = new Set<String>{'Analytics__c', 'PolkConnectSystem__c', 
            'TableauVisualization__c'};
        return !hasOtherRequests(wrf, requestsToIgnore);
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: workrequestform__c wrf
    // @description:  This method is used in POLK WRF.
    // @return: boolean 
    //----------------------------- 
    private static boolean ignoresShipping(workrequestform__c wrf) {
        Set<String> requestsToIgnore = new Set<String>{'PolkConnectSystem__c'};
        return !hasOtherRequests(wrf, requestsToIgnore);
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: workrequestform__c wrf
    // @description:  This method is used in POLK WRF.
    // @return: boolean 
    //----------------------------- 
    private static boolean ignoresOutputSpec(workrequestform__c wrf) {
        Set<String> requestsToIgnore = new Set<String>{'PolkConnectSystem__c'};
        return !hasOtherRequests(wrf, requestsToIgnore);
    }
   //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //-----------------------------  
    private static boolean ignoresExcelVersion(workrequestform__c wrf) {
        Set<String> requestsToIgnore = new Set<String>{'Analytics__c'};
        return !hasOtherRequests(wrf, requestsToIgnore);
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: workrequestform__c wrf, Set<String> ignoreList
    // @description:  This method is used in POLK WRF.
    // @return: boolean 
    //----------------------------- 
    private static boolean hasOtherRequests(workrequestform__c wrf, Set<String> ignoreList) {
        Set<String> requestTypes = allRequestTypes.clone();
        if(ignoreList <> null)
            requestTypes.removeall(ignoreList);
        
        for(String requestType : requestTypes) {
            if(wrf.get(requestType) <> null && (boolean)wrf.get(requestType))
                return true;
        }
        
        return false;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: boolean 
    //----------------------------- 
    public static boolean ValidatePLC(PLCJob__c plc) {
        
        boolean v = true;
        
        //This checks for delivered
        if (plc.jobcompleteddelivered__c == True && (plc.TotalDeliverables__c == Null || plc.DateTimeOfDelivery__c == Null || plc.DefectiveDeliverables__c == Null || plc.LateDeliverables__c == Null || plc.OpenTasks__c > 1 || (plc.RoyaltyRecordsIncluded__c==null && (plc.WorkRequestForm__r.RoyaltyVendor__c <>'No Royalty Data' && plc.WorkRequestForm__r.RoyaltyVendor__c <> null ))  ) ) {
            
            plc.jobcompleteddelivered__c.addError('You cannot complete a job unless no more than one task remains open and the following fields have been entered: total deliverables, delivery date, defective deliverables, late deliverables, and # of royalty records.');
            v=false;
            
        }
        //This checks for  Late Deliverables must be entered when the Date & Time of Delivery is greater than the Negotiated Date
        if (plc.DateTimeOfDelivery__c!= null) {
            if  (( plc.DateTimeOfDelivery__c.date() > plc.NegotiatedDate__c ) && (plc.LateDeliverables__c == 0 || plc.LateDeliverables__c == Null)        ) {          
                plc.LateDeliverables__c.addError('Date & Time of Delivery is greater than the Negotiated Date. Please enter value > 0.');
                v=false;
            }
        }
        if (plc.jobname__c == null || plc.jobname__c == '') {
            
            plc.jobname__c.addError('Field Required');
            v = false;
            
        }
        if (plc.NegotiatedDate__c == null ) {
            
            plc.NegotiatedDate__c.addError('Field Required - Use Requested Due Date if Negotiated Date is not Provided');
            v = false;
            
        }
        
        if (plc.team1__c == null || plc.team1__c ==  '') {
            
            plc.team1__c.addError('Field Required');
            v = false;
            
        }
        
        if (plc.JobType__c == 'Development' && plc.totaljobestimate__c >= 25 && (plc.PSCCodeReview__c == '' || plc.PSCCodeReview__c == NULL)) {
            //&& plc.totaljobestimate__c >= 25 
            plc.PSCCodeReview__c.addError('Field Required');
            v = false;
        }
        
        if (plc.PeerReviewStatus__c == 'Corrected' && (plc.reasonforfailure__c == '' || plc.reasonforfailure__c == NULL)) {
            plc.reasonforfailure__c.addError('Field Required');
            v = false;
        }
        
        if (plc.PeerReviewStatus__c == 'Corrected' && plc.reasonforfailure__c == NULL) {
            plc.totalreworkhours__c.addError('Field Required');
            v = false;
        }
        
        if (plc.EncryptionRequired__c == true && (plc.EncryptionKey__c == NULL || plc.EncryptionKey__c == '')) {
            plc.EncryptionKey__c.addError('Field Required');
            v = false;
        }
        
        return v;
        
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: string 
    //----------------------------- 
    public static string wrfFieldstr(){
        string str;
        for(string s:wrfFields()){
            str=str==null?s:str+','+s;
        }
        return str;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: List<String>
    //----------------------------- 
    public static List<String> wrfFields(){
        
        Set<String> excludeFields = new Set<String>();
        excludeFields.add('CreatedById');
        excludeFields.add('CreatedDate');
        excludeFields.add('CurrencyIsoCode');
        excludeFields.add('IsDeleted');
        excludeFields.add('LastActivityDate');
        excludeFields.add('LastModifiedById');
        excludeFields.add('LastModifiedDate');
        excludeFields.add('SystemModstamp');
        excludeFields.add('Display_Field_0__c');
        excludeFields.add('Motorcycle0__c');
        excludeFields.add('Motorcycle1__c');
        excludeFields.add('Motorcycle2__c');
        excludeFields.add('Motorcycle3__c');
        excludeFields.add('Motorcycle4__c');
        excludeFields.add('Motorcycle5__c');
        excludeFields.add('Motorcycle6__c');
        excludeFields.add('Motorcycle7__c');
        excludeFields.add('Motorcycle8__c');
        excludeFields.add('Motorcycle9__c');
        excludeFields.add('Motorcycle10__c');
        List<String> wrfFields=new List<String>();
        system.debug('XedeUtility 1879--->');
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        system.debug('XedeUtility 1881--->'+schemaMap);
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get('workrequestform__c').getDescribe().fields.getMap();
        system.debug('XedeUtility 1883--->'+fieldMap);
        for(Schema.SObjectField sfield : fieldMap.Values()){
            schema.describefieldresult dfield = sfield.getDescribe();
            if(!excludeFields.contains(dfield.name)){
                wrfFields.add(dfield.name);
            }
        }
        system.debug('XedeUtility 1891--->'+wrfFields);
        return wrfFields;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: PLCJob__c plc, string jobTitle
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static void CreatePLCTask(PLCJob__c plc, string jobTitle) {
       
        JobTask__c newTask;
        
        newTask = new JobTask__c();
        newTask.TaskName__c = jobTitle;
        newTask.PLCJob__c = plc.id;
        newTask.Status__c = 'Open';
        newTask.AssignedTo__c = plc.OwnerId;
        
        
        insert newTask;
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: Sobject object_name, String field_name, String first_val
    // @description:  This method is used in POLK WRF.
    // @return: List<selectOption>
    //----------------------------- 
    public static List<selectOption> getPickValues(Sobject object_name, String field_name, String first_val) {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        if (first_val != null) { //if there is a first value being provided
            options.add(new selectOption('',first_val)); //add the first option
        }
        system.debug('xedeutility 1928--->');
        Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
        system.debug('xedeutility 1930--->'+sobject_type);
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        system.debug('xedeutility 1932--->'+sobject_describe);
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
       	system.debug('xedeutility 1934--->'+field_map);
        List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        system.debug('xedeutility 1936--->'+pick_list_values);
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            options.add(new selectOption(a.getLabel(), a.getValue())); //add the value and label to our final list
        }
        system.debug('xedeutility 1940--->'+options);
        return options; //return the List 
    }
    
}