//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This class is used in POLK WRF.
    // @return: NA
    //----------------------------- 
public class CountrySelectorGridController {
     
    //Start Properties
    public List<SelectOption> dataTypes {get; private set;}
    private Set<String> geographies;
    private Set<String> vehicleTypes;
    private Set<RegionSelect> allRegions;
    public List<CountryOption__c> allCountryOptions {get; private set;}
    public List<CountrySelection__c> countrySelections {get; private set;}
    public String nullDataTypeOption {get; private set;}
    public boolean isView {get; private set;}
    public String URLID {get; set;}
    public List<CountryRow> countryRows {get; private set;}
    public Map<String, String> regionCountryMap {get; private set;}
    public String saveString {get; set;}
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public String requestType { 
        get; 
        set{
            requestType=value;
            refreshAllCountryOptions();
            refreshDataTypes();
        } 
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public String dataType {
        get; 
        set {
            if(value != dataType) {
                ////System.debug('Changing dataType from '+dataType+' to '+value);
                dataType = value;
                refreshCountryRows();
            }
        }
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public List<String> getGeographies() {
        List<String> geoList = new List<String>(geographies);
        geoList.sort();
        ////System.debug('Returning the following geographies: ' + geoList);
        return geoList;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public List<String> getVehicleTypes() {
        List<String> vehTypeList = new List<String>(vehicleTypes);
        vehTypeList.sort();
        ////System.debug('Returning the following Vehicle Types: ' + vehTypeList);
        return vehTypeList;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public List<RegionSelect> getAllRegions() {
        //only return something if a data type is selected
        //necessary since this set is never cleared
        if(dataType <> nullDataTypeOption) {
            List<RegionSelect> regions = new List<RegionSelect>(allRegions);
            regions.sort();
            return regions;
        } else {
            //otherwise return an empty list
            return new List<RegionSelect>();
        }
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public Integer getVehicleTypeCount() {
        return vehicleTypes <> null? vehicleTypes.size() : 1;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public Integer getGeographiesCount() {
        return geographies <> null? geographies.size() : 1;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public boolean getOddRegionCount() {
        return Math.mod(allRegions.size(), 2) <> 0;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public Integer getRegionCount() {
        return allRegions.size();
    }

    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public CountrySelectorGridController() {
        
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        URLID = ApexPages.currentPage().getParameters().get('id');
        isView=(retURL==null && URLid<>null);
        dataTypes = new List<SelectOption>();
        allCountryOptions = new List<CountryOption__c>();
        geographies = new Set<String>();
        vehicleTypes = new Set<String>();
        countryRows = new List<CountryRow>();
        allRegions = new Set<RegionSelect>();
        nullDataTypeOption = '--None--';
        regionCountryMap = new Map<String, String>();
        
        if(!isView) {
            refreshCountrySelections();
            refreshRegions();
        }
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    
    private void refreshDataTypes() {
        if(requestType <> null) {
            dataTypes.clear();
            Set<String> dataTypeStrings = new Set<String>();
            dataTypes.add(new SelectOption(nullDataTypeOption, nullDataTypeOption));
            List<CountryOption__c> options = [SELECT DataType__c FROM CountryOption__c
                                               WHERE RequestType__c includes (:requestType)
                                               AND DataType__c <> null];
            //collect only unique values
            for(CountryOption__c option : options) {
                if(!String.isEmpty(option.DataType__c)) {
                    for(String dt : option.DataType__c.split(';'))
                        dataTypeStrings.add(dt.trim());
                }
            }         
            List<String> sortedDataTypes = new List<String>(dataTypeStrings);
            sortedDataTypes.sort();
            //put them into selectoption objects
            //VF doesn't like Set for this, so we must split the dedupe and this apart
            for(String typeString : sortedDataTypes) {
                dataTypes.add(new SelectOption(typeString, typeString));
            }
        }                         
    }
    
//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    
    public void refreshAllCountryOptions() {
        allCountryOptions.clear();
        if(requestType == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'No Request Type has been set. Cannot proceed.'));
        }
        
        if(dataType <> null && dataType <> nullDataTypeOption && !isView) {
            ////System.debug('Data Type: ' + dataType);
            allCountryOptions = [SELECT DataType__c, Country__c, Geography__c, VehicleType__c, Region__c
                                 FROM CountryOption__c
                                 WHERE RequestType__c includes (:requestType)];
        } 
    }
    
//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    
    private void refreshRegions() {
        if(!isView) {
            //grab all region mappings in Salesforce
            List<CountryQuickSelect__c> regions = [SELECT QuickSelectKey__c, 
                                                            Countries__c 
                                                     FROM CountryQuickSelect__c 
                                                     WHERE Type__c='World Region'];
            //put them into checkboxes and our internal mapping
            for(CountryQuickSelect__c region : regions) {
                allRegions.add(new RegionSelect(region.QuickSelectKey__c));
                regionCountryMap.put(region.QuickSelectKey__c, region.Countries__c);
            }
        }
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    private void refreshCountrySelections() {
        countrySelections = [SELECT Id, RequestType__c, DataType__c, 
                                        Country__c, Geography__c, VehicleType__c,
                                        Comments__c
                                 FROM CountrySelection__c
                                 WHERE WorkRequestForm__c=:URLID];
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    private void refreshCountryRows() {
        ////System.debug('Refreshing Country Rows from ' + allCountryOptions.size() + ' options.');
        //don't bother with anything unless there is a wrf id
        if(URLID == null)
            return;
            
        //if there are no country options yet, but we have a request type, then go get them
        if(allCountryOptions.size() == 0 && requestType <> null)
            refreshAllCountryOptions();
        
        
        //track all geographies and vehicle types, this will be necessary for 
        //data modeling and page rendering               
        geographies.clear();
        vehicleTypes.clear();
        for(CountryOption__c countryOption : allCountryOptions) {
            if(!String.isEmpty(countryOption.DataType__c) && picklistContainsExact(countryOption.DataType__c, dataType)) {
                
                if(!String.isEmpty(countryOption.Geography__c)){
                    for(String geography : countryOption.Geography__c.split(';')) {
                        geographies.add(geography);
                    }
                }
                
                if(!String.isEmpty(countryOption.VehicleType__c)) {
                    for(String vehicleType : countryOption.VehicleType__c.split(';')) {
                        vehicleTypes.add(vehicleType);
                    }
                }
            }
        }

        //map to keep this to one line per country
        //<Country Name, Row>
        Map<String, CountryRow> countryRowMap = new Map<String, CountryRow>();
        
        //process each country option

        for(CountryOption__c countryOption : allCountryOptions) {
            //for each country with the chosen data type
            if(!String.isEmpty(countryOption.DataType__c) && picklistContainsExact(countryOption.DataType__c, dataType)) {
                for(String country : countryOption.Country__c.split(';')) {
                    country = country.trim();
                    //make sure it's included in the map
                    if(!countryRowMap.containsKey(country)) {
                        countryRowMap.put(country, new CountryRow(country, allRegions));
                    }
                    
                    //associate all regions on the country option with each country
                    String rowRegion = countryRowMap.get(country).regions;
                    for(String region : regionCountryMap.keySet()) {
                        if(!String.isEmpty(regionCountryMap.get(region)) && regionCountryMap.get(region).contains(country)) {
                            rowRegion = addPicklistValue(rowRegion, region);
                            ////System.debug('New RowRegion for ' + country + ': ' + rowRegion);
                        }
                    }
                    
                    countryRowMap.get(country).regions = rowRegion;
                    
                    //associate all geography-vehicle type couplings with each row
                    //but only flag it as enabled if the option record contains both the geography and the vehicle type
                    for(String geography : geographies) {
                        for(String vehicleType : vehicleTypes) {
                            
                            //if this geo/vehicle type combo already exists, merely update it rather than add it
                            if(countryRowMap.get(country).vehicleTypes.contains(new VehicleType(geography,vehicleType))) {
                                for(VehicleType v : countryRowMap.get(country).vehicleTypes) {
                                    if (v.equals(geography+vehicleType)) {
                                        if(!v.enabled) {
                                            v.enabled=(!String.isEmpty(countryOption.Geography__c) &&
                                                       picklistContainsExact(countryOption.Geography__c, geography) &&
                                                       !String.isEmpty(countryOption.VehicleType__c) &&
                                                       picklistContainsExact(countryOption.VehicleType__c, vehicleType));
                                        }
                                    }
                                }
                            } else { //otherwise, add a new one
                                countryRowMap.get(country).vehicleTypes.add(
                                    new VehicleType(geography, 
                                                    vehicleType, 
                                                    //flagging enabled as true only if this combo exists on the record
                                                    (!String.isEmpty(countryOption.Geography__c) &&
                                                     countryOption.Geography__c.contains(geography) &&
                                                     !String.isEmpty(countryOption.VehicleType__c) && 
                                                     countryOption.VehicleType__c.contains(vehicleType)), 
                                                    false)
                                );
                                ////System.debug('Adding ' + country + ' to row map.');
                            }
                        }
                    }
                }
            }
        }
        
        //restore saved selection status
        
        for(CountrySelection__c selection : countrySelections) {
            //only process selections with the right data type and request type
            if(String.isEmpty(selection.DataType__c) || String.isEmpty(selection.RequestType__c) || 
               !picklistContainsExact(selection.DataType__c, dataType) || 
               !picklistContainsExact(selection.RequestType__c, requestType))
                continue;
                
            //If the selection record has countries, process each one individually
            if(!String.isEmpty(selection.Country__c)) {
                for(String country : selection.Country__c.split(';')) {
                    //if the country is not in our current option list, then ignore it
                    if(!countryRowMap.containsKey(country))
                        continue;
                    
                    //Since comments should be kept in sync,
                    //just display the first one it finds for the country
                    if(!String.isEmpty(selection.Comments__c) && 
                       String.isEmpty(countryRowMap.get(country).comments) &&
                       selection.RequestType__c == requestType &&
                       selection.DataType__c == dataType &&
                       selection.Country__c == country) {
                        countryRowMap.get(country).comments = selection.Comments__c;
                    }
                    
                    //if the selection contains geo/vt combos
                    if(!String.isEmpty(selection.Geography__c) && !String.isEmpty(selection.VehicleType__c)) {
                        //for each geo/vt permutation it represents
                        for(String geo: selection.Geography__c.split(';')) {
                            for(String vt: selection.VehicleType__c.split(';')) {
                                VehicleType tempVT = new VehicleType(geo, vt);
                                //see if the country contains it (it should!)
                                if(countryRowMap.get(country).vehicleTypes.contains(tempVT)) {
                                    //find and then select it
                                    for(VehicleType each : countryRowMap.get(country).vehicleTypes) {
                                        if(each.equals(tempVT))
                                            each.selected = true;
                                    }
                                }
                            }
                        }
                    }
                }
            }   
        }
        
        //put all rows, sorted by country, into the publicly exposed list
        List<String> sortedKeys = new List<String>(countryRowMap.keySet());
        sortedKeys.sort();
        countryRows.clear();
        for(String country : sortedKeys) {
            countryRows.add(countryRowMap.get(country));
            ////System.debug('Adding ' + countryRowMap.get(country).country);
        }
        ////System.debug('Done refreshing country rows.');
        ////System.debug('There are now ' + countryRows.size() + ' rows.');
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    
    public void saveCountrySelections() {
        ////System.debug('Saving country selections.');
        ////System.debug(saveString);
        
        //update country rows based on save string
        //Hopefully, by copying save str into an argument, the value cannot be lost
        //if users force too many inputs through
        updateCountryRowSelections(saveString);
        
        //save like before
        //System.debug('Preparing to process ' + countryRows.size() + ' rows.');
        boolean alreadySaved = false;
        //using a set helps dedupe, but it must be converted to list for upsert
        Set<CountrySelection__c> toUpsert = new Set<CountrySelection__c>();
        Set<CountrySelection__c> toDelete = new Set<CountrySelection__c>();
        List<CountryRow> cleanRows = new List<CountryRow>();
        //loop through country rows to see all selections
        for(CountryRow c : countryRows){
            //if row contains no selections, skip
            if(!c.getIsDirty()) {
                ////System.debug(c.country + ' is NOT dirty.');
                continue;
            }
            //System.debug(c.country + ' IS DIRTY!!!!!!!!!!!');
            
            
            //expand the row on its geography values
            for(String geography : c.getGeographies()) {
                alreadySaved = false;
                //iterate through country selections to see if this country is saved
                for(CountrySelection__c selection : countrySelections) {
                    if( //do countries match?
                        selection.Country__c <> null && picklistContainsExact(selection.Country__c, c.country) &&
                        //do request types match?
                        selection.RequestType__c <> null && picklistContainsExact(selection.RequestType__c, requestType) && 
                        //do data types match?
                        selection.DataType__c <> null && picklistContainsExact(selection.DataType__c, dataType) &&
                        //it needs to have a geography for the next steps
                        selection.Geography__c <> null && picklistContainsExact(selection.Geography__c, geography)
                    ) {
                        //IF exists
                        ////System.debug('Found existing country selection: ' + selection);
                        //is it the only country?
                        //selection.Country__c.split(';').size()==1
                        if(!String.isEmpty(selection.Country__c) && !selection.Country__c.contains(';')) {
                            //is it the only geography?
                            //selection.Geography__c.split(';').size()==1
                            if(!String.isEmpty(selection.Geography__c) && !selection.Geography__c.contains(';')) {
                                //update vehicle types
                                String newVehicleTypes = '';
                                for(VehicleType v : c.vehicleTypes) {
                                    if(v.geography == selection.Geography__c && v.selected) {
                                        if(!String.isEmpty(newVehicleTypes))
                                            newVehicleTypes += ';';
                                        
                                        newVehicleTypes += v.vehicleType;
                                    }
                                }
                                
                                //If there are no more vehicle types selected for this selection
                                //(which only has 1 country and 1 geography)
                                //and it also has no comments,
                                //then delete it, since it is now effectively empty
                                if(String.isEmpty(newVehicleTypes) && String.isEmpty(c.comments)) {
                                    ////System.debug('Found selection with no vehicle types and comments.');
                                    ////System.debug('Deleting: ' + selection);
                                    selection.VehicleType__c = newVehicleTypes;
                                    toDelete.add(selection);    
                                    continue;
                                }
                                
                                //no need to update if vehicle types and comments never changed
                                if(newVehicleTypes == selection.VehicleType__c && c.comments == selection.Comments__c) {
                                    ////System.debug('No need to update ' + c.country + ' | ' + geography);
                                    ////System.debug(newVehicleTypes + ' == ' + selection.VehicleType__c);
                                    alreadySaved = true;
                                    continue;
                                }
                                
                                //if selection has been modified and added to upsert list
                                //remove it so the freshest version is in there
                                //this works since we modify the actual selection in memory each time
                                if(toUpsert.contains(selection))
                                    toUpsert.remove(selection);
                                
                                //modify the existing selection to match row
                                selection.VehicleType__c = newVehicleTypes;
                                selection.Comments__c = c.comments;
                                //flag alreadySaved to TRUE
                                alreadySaved = true;
                                //add to upsert list    
                                toUpsert.add(selection);
                                ////System.debug('Updated vehicle types only.');
                                ////System.debug('New selection: ' + selection);
                            } else {
                                //remove before modification to prevent dupes
                                if(toUpsert.contains(selection))
                                    toUpsert.remove(selection);
                                //if not the only geography, strip it out
                                selection.Geography__c = stripPickListValue(selection.Geography__c, geography);
                                //add modified country selection to upsert list
                                toUpsert.add(selection);
                                
                                ////System.debug('Stripped geography out.');
                            }
                        } else {
                            //remove before modification to prevent dupes
                            if(toUpsert.contains(selection))
                                toUpsert.remove(selection);
                            //if not, strip it out
                            selection.Country__c = stripPicklistValue(selection.Country__c, c.country);
                            //add modified country selection to upsert list
                            toUpsert.add(selection);
                            
                            ////System.debug('Stripped country out.');
                        }
                    } else {
                        ////System.debug('Did not find match in: ' + selection.country__c);
                    }
                }
                
                //if NOT alreadySaved, a new selection needs to be created
                if(!alreadySaved) {
                    ////System.debug('Saving new country selection.');
                    //create new country selection
                    CountrySelection__c newSelection = new CountrySelection__c();
                    //give it country, data type, request type, geography, all vehicle types
                    newSelection.Country__c = c.country;
                    newSelection.DataType__c = dataType;
                    newSelection.RequestType__c = requestType;
                    newSelection.Geography__c = geography;
                    newSelection.Comments__c = c.comments;
                    String vehicleTypeAgg = '';
                    for(VehicleType v : c.vehicleTypes) {
                        if(v.geography == geography && v.selected) {
                            if(!String.isEmpty(vehicleTypeAgg))
                                vehicleTypeAgg += ';';
                            
                            vehicleTypeAgg += v.vehicleType;
                        }
                    }
                    //if we somehow managed to get a new one with no real data to it, then just skip this
                    if(String.isEmpty(vehicleTypeAgg) && String.isEmpty(newSelection.Comments__c)) {
                        ////System.debug('Do not need to save ' + c.country + ' | ' + geography);
                        continue;
                    }
                    newSelection.VehicleType__c = vehicleTypeAgg;
                    //map region(s) to it
                    //we allow multiple because this is just a filter for reporting
                    //think of this as just adding tags to it
                    String region;
                    for(String key : regionCountryMap.keySet()) {
                        if(Key <> null) {
                            if(picklistContainsExact(regionCountryMap.get(key), c.country)){
                                if(!String.isEmpty(region)) {
                                    region += ';' + key;
                                } else {
                                    region = key;
                                }
                            }
                        }
                    }
                    newSelection.Region__c = region;
                    //set wrf id to URLID
                    newSelection.WorkRequestForm__c = URLID;
                    //add to upsert list
                    toUpsert.add(newSelection);
                    
                    //by refreshing at end, we can skip this
                    //we need to get the inserted ID anyways
                    //countrySelections.add(newSelection);
                    
                    ////System.debug('Saving: ' + newSelection);
                }
            }
            //add processed row to list being marked clean
            cleanRows.add(c);
        }
        
        //if we have new/modified selections to save
        if(toUpsert.size() > 0) {
            try {
                ////System.debug('--------- LIST ---------');
                //for(CountrySelection__c s : toUpsert)
                //  //System.debug(s);
                
                //upsert them to the database
                upsert(new List<CountrySelection__c>(toUpsert));
                ////System.debug('Selection upsert complete.');
            } catch(DMLException e) {
                ApexPages.addMessages(e);
            }
        }
        
        //if any selections need to be removed, then delete them
        if(toDelete.size() > 0) {
            delete(new List<CountrySelection__c>(toDelete));
        }
        
        //mark rows as clean now that they have been saved
        for(CountryRow c : cleanRows) {
            c.clearDirtyFlag();
        }
        
        //need to refresh these to get ids
        //otherwise they cannot be deleted in the same page visit
        if(toUpsert.size() > 0 || toDelete.size() > 0) {
            refreshCountrySelections();
        }
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: savestr
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    
    private void updateCountryRowSelections(String savestr) {
        //feed country rows into map by country
        Map<String, CountryRow> countryRowMap = new Map<String, CountryRow>();
        
        for(CountryRow row : countryRows) {
            countryRowMap.put(row.country, row);
        }
        
        //go through the selections in the savestr and update their respective rows
        for(String selection : savestr.split(';')) {
            String[] parts = selection.split('_');
            if(parts.size() == 3) { 
                String country = parts[0];
                String geography = parts[1];
                String vehicleType = parts[2];
                
                if(!countryRowMap.containsKey(country)) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                        'Critical Error! Cannot find selected country: ' + country));
                    continue;
                }
                
                //if geo and veh type = 0, then this is a comment-only save
                if(geography == '0' && vehicleType == '0') {
                    //mark country row dirty
                    countryRowMap.get(country).dirty=true;
                    //System.debug('Marking ' + country + ' as dirty from comment.');
                    continue;
                }
                
                for(VehicleType vt : countryRowMap.get(country).vehicleTypes) {
                    if(vt.geography == geography && vt.vehicleType == vehicleType) {
                        vt.selected = !vt.selected;
                        vt.dirty = true;
                        //System.debug('Updating: ' + countryRowMap.get(country).country);
                        //System.debug('Updating: ' + vt.geography);
                        //System.debug('Updating: ' + vt.vehicleType);
                        //System.debug('Updating: ' + vt.selected);
                        //System.debug('===========================');
                    }
                }
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                    'Selection ID improperly formatted: ' + selection ));
            }
        }
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    
    private String stripPicklistValue(String picklist, String value) {
        //remove just the value
        String newValue = picklist.remove(value);
        //if this causes two semi-colons to but together, fix it
        newValue = newValue.replaceAll(';;', ';');
        //if the value was at the start, it now starts with a semi-colon --fix this
        if(newValue.startsWith(';'))
            newValue = newValue.substring(1);
        //if the value was at the end, it now ends in a semi-colon --fix this
        if(newValue.endsWith(';'))
            newValue = newValue.substring(0, newValue.length()-1);
        //return new, corrected value
        return newValue;
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: picklist name , picklist value 
    // @description: This method is used in WRF POLK.
    // @return: NA
    //----------------------------- 
    
    private String addPicklistValue(String picklist, String value) {
        if(String.isEmpty(picklist) || !picklistContainsExact(picklist,value)) {
            if(!String.isEmpty(picklist)) {
                picklist += ';';
            }
            
            picklist += value;
        }
        
        return picklist;
    }
    
    
    //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: This method is used in POLK WRF and Migrated from Legacy POLK.
        //               Determines whether or not a picklist contains the exact search value.
        //               This prevents mixups from values with very similar names.
        // @Parameters: picklist: the semi-colon separated multi-select picklist stored value
        // @ value   : the value to search for within the picklist
        // @Returns: True if the exact value is in the picklist, false otherwise
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
   
    
    private boolean picklistContainsExact(String picklist, String value) {
        if(String.isEmpty(picklist))
            return false;
        
        
        return (picklist.contains(value + ';') || picklist.endsWith(value));
        
        /* This was too slow/resource intensive
        boolean containsExact = false;
        for(String selection : picklist.split(';')) {
            if (selection == value) {
                containsExact = true;
                break;
            }
        }
        return containsExact;
        */
    
    }
    

    //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: A class to represent a single row in the final table of country options/selections
        //               This method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
    

    public class CountryRow implements Comparable {
        public String country {get; private set;}
        //private Set<String> geographies;
        private Set<VehicleType> vehicleTypes;
        //regions belonging to this row
        private String regions;
        //These are copied from the controller, they are out of scope otherwise
        private Set<RegionSelect> allRegions;
        //private Id selectionId;
        private boolean dirty;
        public String comments {get;set;}
        
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: This method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
    
        public CountryRow() {
            country = '';
            //geographies = new Set<String>();
            vehicleTypes = new Set<VehicleType>();
            allRegions = new Set<RegionSelect>();
            regions = '';
            dirty = false;
        }
        
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: This method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
    
        public CountryRow(String country) {
            this();
            this.country = country;
        }
        
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: This method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
    
        public CountryRow (String country, Set<RegionSelect> allRegions) {
            this(country);
            this.allRegions = allRegions;
        }
        
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: This method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
    
        public Set<String> getGeographies() {
            Set<String> geographies = new Set<String>();
            for(VehicleType vt : vehicleTypes) {
                if(vt.enabled)
                    geographies.add(vt.Geography);
            }
            
            return geographies;
        }
        
        /*
        //this has to be returned as a list for visualforce use
        public List<String> getGeographies() {
            List<String> geoList = new List<String>(geographies);
            geoList.sort();
            return geoList;
        }
        
        //we can't use the getter to in turn add items to the sets, since their getters return new lists
        public void addGeography(String geography) {
            geographies.add(geography);
        }
        */
        
        
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: This method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
    
        public void addVehicleType(VehicleType vt) {
            vehicleTypes.add(vt);
        }
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: This method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
    
        public List<String> getRegions() {
            List<String> regionList = new List<String>();
            if(!String.isEmpty(regions))
                regionList.addAll(regions.split(';'));
            regionList.sort();
            return regionList;
        }
        
        
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: Returns whether or not any region for this row is selected.
        //               This method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
    
        public boolean getRegionIsSelected() {
            ////System.debug('Getting selected regions for: ' + country);
            ////System.debug('allRegions: ' + allRegions);
            ////System.debug('regions: ' + regions);
            for(RegionSelect rs : allRegions) {
                if(rs.selected && regions.contains(rs.region)) {
                        return true;
                }
            }
            
            return false;
        }
        
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: this has to be returned as a list for visualforce use
        // .this method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
    
        public Map<String, List<VehicleType>> getVehicleTypeMap() {
            Map<String, List<VehicleType>> vehicleTypeMap = new Map<String, List<VehicleType>>();
            for(VehicleType vt : vehicleTypes) {
                if(! vehicleTypeMap.containsKey(vt.geography))
                    vehicleTypeMap.put(vt.geography, new List<VehicleType>());
                
                vehicleTypeMap.get(vt.geography).add(vt);
            }
            
            for(String geo : vehicleTypeMap.keySet()) {
                vehicleTypeMap.get(geo).sort();
            }
            
            return vehicleTypeMap;
        }
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: this has to be returned as a list for visualforce use
        // .this method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
    
          public List<VehicleType> getVehicleTypes() {
            List<VehicleType> sortedVehTypes = new List<VehicleType>(vehicleTypes);
            sortedVehTypes.sort();
            return sortedVehTypes;
        }
        
        
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
        
        public Set<VehicleType> getDistinctVehicleTypes() {
            return vehicleTypes;
        }
        
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
        
        //to determine if we need to save or update this country's record
        public boolean getIsDirty() {
            if(dirty)
                return true;
                
            for(VehicleType v : vehicleTypes) {
                if(v.dirty)
                    return true;
            }
            
            return false;
        }
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    
        //to clear the dirty flags after being saved so that it is not processed again
        //unless modified again, that is
        public void clearDirtyFlag() {
            for(VehicleType v : vehicleTypes) {
                v.dirty = false;
            }
            dirty = false;
        }
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
        
        //for rendering out the non-editable view
        public boolean getHasSelection() {
            for(VehicleType v : vehicleTypes) {
                if(v.selected)
                    return true;
            }
            
            return false;
        }
        
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
        
        //compareTo must be implemented to sort
        public Integer compareTo(Object compareTo) {
            if(compareTo instanceof CountryRow) {
                CountryRow other = (CountryRow)compareTo;
                if(country != null)
                    return country.compareTo(other.country);
            }
            
            return 1;
        }
    }
    
    /*
        Description: Represents a selectable region option. These are the objects the front-end renders.
    */
    //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    
    public class RegionSelect implements Comparable {
        public String region {get; set;}
        public boolean selected {get; set;}
        /* Never used, but works.
         * Uncomment if ever needed
         * Comments just help code coverage
        public RegionSelect() {
            region = '';
            selected = true;
        }
        */
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    
        public RegionSelect(String region) {
            this.region = region;
            selected = true;
        }
        /* Never used, but works.
         * Uncomment if ever needed
         * Comments just help code coverage
        public RegionSelect(String region, boolean selected) {
            this.region = region;
            this.selected = selected;
        }
        
        public boolean equals(Object o) {
            if(o instanceof RegionSelect) {
                RegionSelect other = (RegionSelect) o;
                return this.region == other.region;
            } else if (o instanceof String) {
                return this.region == (String) o;
            } else {
                return false;
            }
        }
        */
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    
        //Implementing the Comparable interface for use in sets
        public Integer hashCode() {
            return region.hashCode();
        }
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    
        public Integer compareTo(Object o) {
            if(o instanceof RegionSelect) {
                RegionSelect other = (RegionSelect) o;
                if(other <> null && other.region <> null)
                    return other.region.compareTo(this.region);
            } 
            /* Never used, but works.
             * Uncomment if needed
             * Commented for code coverage
            else if (o instanceof String) {
                if(this.region <> null)
                    return this.region.compareTo((String)o);
            } 
            */

            return 1;
        }
    }
    
    
    /*
        Description: Represents an option for a single cell of the final grid.
                     i.e. these are the individual columns of a row
    */

    public class VehicleType implements Comparable {
        public String geography {get; private set;}
        public String vehicleType {get; private set;}
        public boolean enabled {get; private set;}
        private boolean dirty; //to flag if something changed
        public boolean selected { get; set; }
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    
        public VehicleType() {
            geography = '';
            vehicleType = '';
            enabled = false;
            selected = false;
            dirty = false;
        }
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    
        public VehicleType(String geography, string vehicleType) {
            this();
            this.geography = geography;
            this.vehicleType = vehicleType;
            dirty = false;
        }
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    
        public VehicleType(String geography, String vehicleType, boolean enabled) {
            this.geography = geography;
            this.vehicleType = vehicleType;
            this.enabled = enabled;
            selected = false;
            dirty = false;
        }
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    
        public VehicleType(String geography, String vehicleType, boolean enabled, boolean selected) {
            this(geography, vehicleType, enabled);
            this.selected = selected;   
            dirty = false;  
        }
        
        //equals and hashCode must be implemented for use in Sets
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
        
        public boolean equals(Object o) {
            if(o == null)
                return false;
                
            if(o instanceof VehicleType) {
                VehicleType other = (VehicleType) o;
                return (other.geography.equals(this.geography) && other.vehicleType.equals(this.vehicleType));
            } else if (o instanceof String) {
                String compositeKey = (String) o;
                return compositeKey.equals(this.geography+this.vehicleType);
            }
            
            return false;
        }
        
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
        
        public Integer hashCode() {
            return geography.hashCode() + vehicleType.hashCode();
        }
        
        //compareTo must be implemented to sort
        //----------------------------- 
        // @Author : Legacy POLK 
        // @date: 11 Oct 2017 
        // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
        // @PROGRAMMER: Anjani Shukla 
        //-----------------------------
        
        public Integer compareTo(Object compareTo) {
            if(compareTo instanceof VehicleType) {
                VehicleType other = (VehicleType)compareTo;
                return (this.geography+this.vehicleType).compareTo(other.geography+other.vehicleType);
            }
            
            return 1;
        }
    }
}