//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This classis used in POLK WRF.
    // @return: NA
    //----------------------------- 
public class CountrySelectorGridViewController {

    //-------------------------------------------------------------------------
    //Start Properties
    public String requestType {
        get; 
        set {
            //the page seems to repeatedly set this for no reason
            //we will only set it once and then leave it
            //there is no valid reason it should ever change
            if(requestType <> value) {
                requestType = value;
                refresh();
            }
        }
    }
    public String URLID {get; private set;}
    public boolean isView {get; private set;}
    //all data types for this request type
    public List<String> dataTypes {get; set;}
    //map <data_type, countries>
    public Map<String, List<String>> dataTypeCountries {get; private set;}
    //map <data_type, countryRows>
    public Map<String, List<CountrySelectorGridController.CountryRow>> dataTypeCountryRows {get; private set;}
    //map <data_type, rowCounts>
    public Map<String, Integer> dataTypeRowCounts {get; private set;}
    //map <data_type, geographies>
    public Map<String, List<String>> dataTypeGeographies {get; private set;}
    //map <data_type, vehicleTypes>
    public Map<String, List<String>> dataTypeVehicleTypes {get; private set;}
    //map <data_type, geoCount>
    public Map<String, Integer> dataTypeGeographyCounts {get; private set;}
    //map <data_type, vehicleTypeCount>
    public Map<String, Integer> dataTypeVehicleTypeCounts {get; private set;}
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public boolean getHasSelections() {
        for(String key : dataTypeCountryRows.keySet()) {
            if(dataTypeCountryRows.get(key).size() <> 0) {
                return true;
            }
        }
        
        return false;
    }
    
    //End Properties
    //-------------------------------------------------------------------------
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public CountrySelectorGridViewController() {
        System.debug('Constructing a CountrySelectorGridViewController');
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        URLID = ApexPages.currentPage().getParameters().get('id');
        isView=(retURL==null && URLid<>null);
        dataTypes = new List<String>();
        dataTypeCountries = new Map<String, List<String>>();
        dataTypeCountryRows = new Map<String, List<CountrySelectorGridController.CountryRow>>();
        dataTypeRowCounts = new Map<String, Integer>();
        dataTypeGeographies = new Map<String, List<String>>();
        dataTypeVehicleTypes = new Map<String, List<String>>();
        dataTypeGeographyCounts = new Map<String, Integer>();
        dataTypeVehicleTypeCounts = new Map<String, Integer>();
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
 
    public void refresh() {
        //System.debug('Refreshing data.');
        if(String.isEmpty(URLID))
            return;
        
        //data structures for deduping purposes
        Map<String, Set<String>> distinctDataTypeCountries = new Map<String, Set<String>>();
        Map<String, Map<String, CountrySelectorGridController.CountryRow>> dataTypeCountryRowsMap = 
            new Map<String, Map<String, CountrySelectorGridController.CountryRow>>();
        Map<String, Set<String>> distinctDataTypeGeographies = new Map<String, Set<String>>();
        Map<String, Set<String>> distinctDataTypeVehicleTypes = new Map<String, Set<String>>();
        
        //clear out the various maps just to be safe
        clearData();
        //get all data types for this request type
        getDataTypes();
        
        //System.debug('Data types: ' + dataTypes);
        
        //all meta data needs to be captured per data type
        //this initializes the various lists that we will need to populate
        for(String dt : dataTypes) {
            distinctDataTypeCountries.put(dt, new Set<String>());
            dataTypeCountryRowsMap.put(dt, new Map<String, CountrySelectorGridController.CountryRow>());
            distinctDataTypeGeographies.put(dt, new Set<String>());
            distinctDataTypeVehicleTypes.put(dt, new Set<String>());
            
            dataTypeCountries.put(dt, new List<String>());
            dataTypeCountryRows.put(dt, new List<CountrySelectorGridController.CountryRow>());
            DataTypeGeographies.put(dt, new List<String>());
            DataTypeVehicleTypes.put(dt, new List<String>());
        }
        
        //gather all selections for this WRF
        List<CountrySelection__c> selections = [SELECT Id, RequestType__c, DataType__c, 
                                                    Country__c, Geography__c, VehicleType__c,
                                                    Comments__c
                                                 FROM CountrySelection__c
                                                 WHERE WorkRequestForm__c=:URLID
                                                 AND RequestType__c includes (:requestType)];
        
        //System.debug('Queried ' + selections.size() + ' selections');
        //compile metadata for building rows
        for(CountrySelection__c selection : selections) {
            //System.debug('Processing: ' + selection.Country__c + ' | ' + selection.Geography__c + 
            //  ' | ' + selection.Vehicle_Type__c);
                
            if(!String.isEmpty(selection.DataType__c)) {
                for(String dt : selection.DataType__c.split(';')) {
                    //System.debug('Processing: ' + dt);
                    //if entries in the maps do not exist in the maps for these data types
                    //then create them
                    if(!distinctDataTypeCountries.containsKey(dt))
                        distinctDataTypeCountries.put(dt, new Set<String>());
                        
                    if(!dataTypeCountryRowsMap.containsKey(dt))
                        dataTypeCountryRowsMap.put(dt, new Map<String, CountrySelectorGridController.CountryRow>());
                    
                    if(!distinctDataTypeGeographies.containsKey(dt))
                        distinctDataTypeGeographies.put(dt, new Set<String>());
                    
                    if(!distinctDataTypeVehicleTypes.containsKey(dt))
                        distinctDataTypeVehicleTypes.put(dt, new Set<String>());
                
                    //capture the data
                    //get countries     
                    if(!String.isEmpty(selection.Country__c))
                        for(String country : selection.Country__c.split(';'))
                            distinctDataTypeCountries.get(dt).add(country);
                    
                    //get vehicle types
                    if(!String.isEmpty(selection.VehicleType__c))
                        for(String vt : selection.VehicleType__c.split(';'))
                            distinctDataTypeVehicleTypes.get(dt).add(vt);
                    
                    //get geographies
                    //do not bother with them if no vehicle types are selected
                    //this is for comment-only saves
                    if(!String.isEmpty(selection.Geography__c) && distinctDataTypeVehicleTypes.get(dt).size() > 0)
                        for(String geo : selection.Geography__c.split(';'))
                            distinctDataTypeGeographies.get(dt).add(geo);
                }
            }
        }
        
        //System.debug('Distinct countries: ' + distinctDataTypeCountries.get('Global VIO'));
        //System.debug('Distinct geographies: ' + distinctDataTypeGeographies.get('Global VIO'));
        //System.debug('Vehicle types: ' + distinctDataTypeVehicleTypes.get('Global VIO'));
        
        //build country rows    
        //for each selection                                     
        for(CountrySelection__c selection : selections) {  
            //System.debug('Processing: ' + selection.Data_Type__c + ' | ' + selection.Country__c + 
            //    ' | ' + selection.Geography__c + ' | ' + selection.Vehicle_Type__c);
            //nothing can be processed if country is blank
            if(String.isEmpty(selection.Country__c))
                continue;
            
            //gather all unique vehicle types & geographies, these will be needed later
            Set<String> selectionVehicleTypes = new Set<String>();
            if(!String.isEmpty(selection.VehicleType__c))
                selectionVehicleTypes.addAll(selection.VehicleType__c.split(';'));
            Set<String> selectionGeographies = new Set<String>();
            if(!String.isEmpty(selection.Geography__c))
                selectionGeographies.addAll(selection.Geography__c.split(';'));
            
            //System.debug('Comments: ' + selection.Comments__c);
            
            //for all of its data types
            if(!String.isEmpty(selection.DataType__c)) {
                for(String dt : selection.DataType__c.split(';')) {
                    //System.debug('Processing: ' + dt);
                    //create a country row for each country
                    for(String country : selection.Country__c.split(';')){
                        //System.debug('Building row for ' + country);
                        CountrySelectorGridController.CountryRow row;
                        //if the country isn't in the map, then add it
                        if(!dataTypeCountryRowsMap.get(dt).containsKey(country)) {
                            row = new CountrySelectorGridController.CountryRow(country);
                            dataTypeCountryRowsMap.get(dt).put(country, row);
                            //System.debug('created new row');
                        } else {
                            row = dataTypeCountryRowsMap.get(dt).get(country);
                            //System.debug('Using existing row');
                        }
                        
                        //System.debug('Geographies on row: ' + row.getGeographies());
                        
                        //add comments
                        if(String.isEmpty(row.Comments) && !String.isEmpty(selection.Comments__c))
                            row.comments = selection.Comments__c;
                        
                        //expand vehicle types
                        //for all geographies for this data type (not just the selection)
                        for(String geography : distinctDataTypeGeographies.get(dt)) {
                            //for all vehicle types for this data type
                            for(String vehicleType : distinctDataTypeVehicleTypes.get(dt)) {
                                //System.debug('Adding geo|vt: ' + geography + ' | ' + vehicleType);
                                CountrySelectorGridController.VehicleType vt = new
                                    CountrySelectorGridController.VehicleType(
                                        geography, vehicleType);
                                
                                //if the combo already exists, update it
                                if(row.getDistinctVehicleTypes().contains(vt)) {
                                    for(CountrySelectorGridController.VehicleType each : row.getDistinctVehicleTypes()) {
                                        if(each <> null && each.equals(vt)) {
                                            vt = each;
                                        }
                                    }
                                    
                                    //Set selected to true if it is already true, OR if this selection has it
                                    vt.selected = vt.selected || (selectionVehicleTypes.contains(vt.vehicleType) &&
                                                                  selectionGeographies.contains(vt.geography));
                                    //System.debug('geo/vt combo existed, setting selected to '+ vt.selected);
                                } else { //else, create a new one and then add it
                                    //Set selected to true if this selection has it
                                    vt.selected = selectionVehicleTypes.contains(vt.vehicleType) &&
                                                  selectionGeographies.contains(vt.geography);
                                    //add it to row
                                    row.addVehicleType(vt);
                                    //System.debug('Added new vehicle type, setting selected to ' + vt.selected);
                                }
                            }
                        }
                    }
                }
            }
        }
    
        //populate maps & get the counts
        //all of these keys should exist from earlier in this method
        for(String dt : dataTypes) {
            //System.debug('==========================');
            System.debug(dt);
            dataTypeCountries.get(dt).addAll(distinctDataTypeCountries.get(dt));
            dataTypeCountries.get(dt).sort();
            dataTypeGeographies.get(dt).addAll(distinctDataTypeGeographies.get(dt));
            dataTypeGeographies.get(dt).sort();
            dataTypeVehicleTypes.get(dt).addAll(distinctDataTypeVehicleTypes.get(dt));
            dataTypeVehicleTypes.get(dt).sort();
            dataTypeGeographyCounts.put(dt, dataTypeGeographies.get(dt).size());
            dataTypeVehicleTypeCounts.put(dt, dataTypeVehicleTypes.get(dt).size());
            
            //System.debug('Geographies: ' + dataTypeGeographyCounts.get(dt));
            //System.debug('Vehicle Types: ' + dataTypeVehicleTypeCounts.get(dt));

            for(String country : dataTypeCountryRowsMap.get(dt).keySet()) {
                dataTypeCountryRows.get(dt).add(dataTypeCountryRowsMap.get(dt).get(country));
                //System.debug(country + ': ' + dataTypeCountryRowsMap.get(dt).get(country));
            }
            dataTypeCountryRows.get(dt).sort();
            dataTypeRowCounts.put(dt, dataTypeCountryRows.get(dt).size());
            //System.debug('Rows: ' + dataTypeRowCounts.get(dt));
            //System.debug('==========================');
        }
        
        //System.debug('Done refreshing data.');
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 

    private void clearData() {
        dataTypes.clear();
        dataTypeCountries.clear();
        dataTypeCountryRows.clear();
        dataTypeRowCounts.clear();
        dataTypeGeographies.clear();
        dataTypeVehicleTypes.clear();
        dataTypeGeographyCounts.clear();
        dataTypeVehicleTypeCounts.clear();
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
 
    private void getDataTypes() {
        List<CountryOption__c> options = [SELECT DataType__c 
                                           FROM CountryOption__c
                                           WHERE RequestType__c includes (:requestType)];
        //using set for deduping purposes                        
        Set<String> distinctDataTypes = new Set<String>();
        //grab each unique data type
        for(CountryOption__c option : options) {
            if(!String.isEmpty(option.DataType__c)) {
                for(String dataType : option.DataType__c.split(';')) {
                    distinctDataTypes.add(dataType);
                }
            }
        }           
        //feed it into the list for visualforce purposes                     
        dataTypes.clear();
        dataTypes.addAll(distinctDataTypes);
        //dataTypes.add('Used Regs');
        dataTypes.sort();
    }

}