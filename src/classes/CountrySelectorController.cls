//----------------------------- 
// @Author : Legacy POLK 
// @date: 11 Oct 2017 
// @description: Migrated from Legacy POLK 
// @PROGRAMMER: Anjani Shukla 
//-----------------------------
public class CountrySelectorController {
    
    // this list is in the specific order in which the select lists appear on the component, Data_Type__s is upstream of Time_Period__c. 
    public static final List<String> FIELD_LIST = new List<String> { 'DataType__c', 'VehicleType__c', 'Region__c', 'Country__c', 'Geography__c'};//, 'Time_Period__c' };

    public List<CountrySelection> countrySelections { get; set; }
    public Boolean hasSelections { get { return size() > 0; } }
    public Boolean isRegistered { get; private set; }
    public CountrySelection__c onDeckSelection { get; set; }
    //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    public WRACE pageExtension {
        get;
        set{
            system.debug('pageExtension*****'+value);
            pageExtension = value;
            if (isRegistered)
                return;
                
              pageExtension.addSelector(this);
            isRegistered = true;
        }
    } 
    //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    public Id parentId {
        get;
        set {
            parentId = value;
            populateCountrySelections();
        }
    }
    public String requestType { get; set; }
    
    //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    public Boolean selectionIsValid {
        get {
            return  correctedValueFrom(onDeckSelection.DataType__c) != null
                    && correctedValueFrom(onDeckSelection.VehicleType__c) != null
                    && correctedValueFrom(onDeckSelection.Country__c) != null
                    && correctedValueFrom(onDeckSelection.Geography__c) != null;
        }
    }
    
    //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    public Integer size() {
        return getRetainedSelections().size();
    }
    
    //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    public CountrySelectorController() {
        isRegistered = false;
        countrySelections = new List<CountrySelection>();
        onDeckSelection = new CountrySelection__c();
    }
    
    //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------    
        public void addSelection() {
        onDeckSelection.RequestType__c = requestType;
        countrySelections.add(new CountrySelection(onDeckSelection));
        onDeckSelection = new CountrySelection__c();
    }
    
    //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    private Boolean addValidComparisonsFor(String fieldName, String fieldValue, List<String> comparisonList) {

        fieldValue = correctedValueFrom(fieldValue);
        
        if (String.isBlank(fieldValue))
            return false;
        
        List<String> fieldValueList = fieldValue.split(',');
        
        for (String eachValue : fieldValueList)
            comparisonList.add(XedeQueryBuilder.MultiSelectInclusionComparisonFor(fieldName, eachValue.trim()));
        
        return true;
    }
    
    //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
    public void clearDownStreamValues() {
        String startingField = ApexPages.currentPage().getParameters().get('startingField');

        system.debug('CLEARING DOWNSTREAM VALUES, STARTING WITH ' + startingField);
        Boolean clearRemainingFields = false;
        
        for (String eachField : FIELD_LIST) {
            if (clearRemainingFields == false && eachField != startingField)
                continue;
            
            clearRemainingFields = true;
            
            onDeckSelection.put(eachField, null);
        }       
    }
    
    //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

    public List<CountrySelection__c> clonedCountrySelections() {
        List<CountrySelection__c> sobjectDataList = new List<CountrySelection__c>();
        
        for (CountrySelection each : countrySelections)
            sobjectDataList.add(each.clonedSobjectData());
        
        return sobjectDataList;
    }
   
       //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

    private String correctedValueFrom(String aStringValue) {
        String returnValue = String.isBlank(aStringValue)? null : aStringValue.replace('[','').replace(']','');
        
        if (String.isBlank(returnValue))
            return null;
        
        return returnValue;
    }
    
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

    private String countryOptionsQueryStringFor(String aFieldName) {
        List<String> andComparisonList = new List<String> { XedeQueryBuilder.MultiSelectInclusionComparisonFor('RequestType__c', requestType) };
        List<String> regionComparisonList = new List<String>();
        List<String> countryComparisonList = new List<String>();
                
        for (String eachField : FIELD_LIST) {
            system.debug('\n\n' + eachField + '\n\n');
            
            String checkValue = correctedValueFrom((String)onDeckSelection.get(eachField));

            if (String.isBlank(checkValue))
                continue;

            if (eachField == aFieldName)
                break;
                
            system.debug('\n\nbuilding comparison for ' + eachField + '\nvalue: ' + checkValue + '\n\n');

            if (eachField == 'Region__c' && addValidComparisonsFor(eachField, checkValue, regionComparisonList))
                continue;
            
            if (eachField == 'Country__c' && addValidComparisonsFor(eachField, checkValue, countryComparisonList))
                continue;
            
            else if (addValidComparisonsFor(eachField, checkValue, andComparisonList))
                continue;
        }
        
        if(regionComparisonList.size() > 0)
            andComparisonList.add('('+String.join(regionComparisonList, ' or ')+')');
            
        if(countryComparisonList.size() > 0)
            andComparisonList.add('('+String.join(countryComparisonList, ' or ')+')');
            
        String andComparisonString = String.join(andComparisonList, ' and ');
        
        String queryString = XedeQueryBuilder.QueryStringFor(String.join(FIELD_LIST, ', '), 'CountryOption__c', andComparisonString, null, null, null);

        system.debug('\n\nquery: ' + queryString + '\n\n');
    
        return queryString;
    }
    
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

    private List<SelectOption> criteriaBasedSelectOptionsFor(String aFieldName) {

        system.debug('\n\ngetting selectOptions for ' + aFieldName + '\n\n');

        String queryString = countryOptionsQueryStringFor(aFieldName);

        List<CountryOption__c> rawCountryOptions = Database.query(queryString);
        
        Map<String, Integer> valueCountMap = new Map<String, Integer>();
        
        Set<string> countrySet = new Set<string>();
        for (CountryOption__c each : rawCountryOptions) {
            countrySet.add(each.Country__c);
            String tempValue = ((String)each.get(aFieldName));
            
            if (String.isBlank(tempValue))
                continue;
            
            for (String eachValue : tempValue.split(';')) {
                eachValue = eachValue.trim();
                Integer tempCount = valueCountMap.containsKey(eachValue)? valueCountMap.get(eachValue) : 0;
                tempCount++;
                valueCountMap.put(eachValue, tempCount);
            }
        }
        
        List<String> optionValuesForField = new List<String>();
        
        if (aFieldName == 'Geography__c') { // || aFieldName == 'Time_Period__c') {
            system.debug('\n\nIN GEO PROCESSING');
            for (String eachKey : valueCountMap.keySet()) {
                system.debug('\n\nKey: '+eachKey+' Value Count: '+valueCountMap.get(eachKey)+' raw size: '+rawCountryOptions.size()+ ' country Size: ' +countrySet.size());
                if (valueCountMap.get(eachKey) == rawCountryOptions.size())
                if (valueCountMap.get(eachKey) == countrySet.size())
                    optionValuesForField.add(eachKey);
            }
        }
        else
            optionValuesForField = new List<String>(valueCountMap.keySet());
        
        // option values come from a set which cannot include duplicates, then get sorted alphabetically
        optionValuesForField.sort();
        
        List<SelectOption> options = new List<SelectOption>();

        for (String eachValue : optionValuesForField)
            options.add(new SelectOption(eachValue, eachValue));
        
        system.debug('\n\noptions for field, ' + aFieldName + ' = ' + options + '\n\n');
        return options;
    }
    
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

    public List<SelectOption> getDataTypeOptions() {
        return criteriaBasedSelectOptionsFor('DataType__c');
    }
    
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

    public List<SelectOption> getVehicleTypeOptions() {
        if (readyToShowOptionsFor('VehicleType__c'))
            return criteriaBasedSelectOptionsFor('VehicleType__c');
        
        return new List<SelectOption>();
    }
    
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

    public List<SelectOption> getRegionOptions() {
       // ****REMOVE system.debug('GETTING REGION OPTIONS FOR ' + onDeckSelection.VehicleType__c);
        if (readyToShowOptionsFor('Region__c'))
            return criteriaBasedSelectOptionsFor('Region__c');
        
        return new List<SelectOption>();
    }
    
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

    public List<SelectOption> getCountryOptions() {
        // country list and region list can be shown together, without requiring a region selection
        if (readyToShowOptionsFor('Region__c'))
            return criteriaBasedSelectOptionsFor('Country__c');
        
        return new List<SelectOption>();
    }
    
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

    public List<SelectOption> getGeographyOptions() {
        if (readyToShowOptionsFor('Geography__c'))
            return criteriaBasedSelectOptionsFor('Geography__c');
        
        return new List<SelectOption>();
    }
   

/*  public List<SelectOption> getTimePeriodOptions() {
        if (readyToShowOptionsFor('Time_Period__c'))
            return criteriaBasedSelectOptionsFor('Time_Period__c');
        
        return new List<SelectOption>();
    }
*/
        //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

   
    public List<CountrySelection> getRetainedSelections() {
        List<CountrySelection> retainedSelections = new List<CountrySelection>();
        for (CountrySelection each : countrySelections) {
            if (each.isRemoved)
                continue;
            
            retainedSelections.add(each);
        }
        return retainedSelections;
    }
    
      //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: this method is used in POLK WRF and is Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

    private void populateCountrySelections() {
        if (countrySelections.size() > 0 || parentId == null)
            return;

        // dynamically grabbing all CountrySelection__c fields 
        Schema.Describesobjectresult sobjectResult = Schema.describeSObjects(new List<String>{ 'CountrySelection__c' })[0];
        system.debug('line 258 sobjectResult*****'+sobjectResult);
        Map<String, Schema.SObjectField> fieldMap = sobjectResult.fields.getMap();
        system.debug('line 260 fieldMap*****'+fieldMap.values());
        system.debug('line 261 fieldMap*****'+fieldMap.keySet());
        List<String> fieldList = new List<String>(fieldMap.keySet());
        String dynamicFieldList = String.join(fieldList, ', ');
        system.debug('parentId****'+parentId);
        system.debug('requestType****'+requestType);
        List<String> comparisonList = new List<String>{
            XedeQueryBuilder.TextEqualityComparisonFor('WorkRequestForm__c', parentId),
            XedeQueryBuilder.MultiSelectInclusionComparisonFor('RequestType__c', requestType)
        };
        system.debug('comparisonList*****'+comparisonList);
        String queryString = XedeQueryBuilder.QueryStringFor(dynamicFieldList, 'CountrySelection__c', String.join(comparisonList, ' and '), null, null, null);
        List<CountrySelection__c> existingSelections = Database.query(queryString);
        
        for (CountrySelection__c each : existingSelections)
            countrySelections.add(new CountrySelection(each));
    }
    
    //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: This method is used in POLK WRF.Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
   
    
    private Boolean readyToShowOptionsFor(String aFieldName) {
        system.debug('CHECKING WHETHER TO SHOW: ' + aFieldName);

        for (String eachField : FIELD_LIST) {
            system.debug('CHECKING FIELD: ' + eachField);
            
            if (eachField == aFieldName)
                return true;
            
            if (eachField == 'Region__c')
                continue;
            
           system.debug(onDeckSelection);
            
            String checkValue = correctedValueFrom((String)onDeckSelection.get(eachField));
    
            system.debug('CHECKVALUE = ' + checkValue);
            
            if (String.isBlank(checkValue))
                return false;
    
        }
        
        return true;
    }
  
    //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: This method is used in POLK WRF.Migrated from Legacy POLK 
    // @param : sf id of WorkRequestForm__c , list of CountrySelection__c to be inseted , list of CountrySelection__c to be deleted
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------
   
    public void shareRowsForSavingTo(Id wrfId, List<CountrySelection__c> insertList, List<CountrySelection__c> deleteList) {
        for (CountrySelection each : countrySelections) {
            if (each.isRemoved == true && each.removeSelection == false)
                continue;
            
            if (each.removeSelection == true) {
                deleteList.add(each.sobjectData);
            }
            else if (each.sobjectData.Id == null)
            {
                if (each.sobjectData.WorkRequestForm__c == null)
                    each.sobjectData.WorkRequestForm__c = wrfId; 
                
                system.debug('\n\nADDING TO SAVE LIST: ' + each.sobjectData + '\n\n');
                insertList.add(each.sobjectData);
            }
        }
    }
    
    //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: This class is used in POLK WRF.Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

    
    public class CountrySelection {
        public CountrySelection__c sobjectData { get; set; }
        public String dataType { get { return sobjectData.DataType__c == null? '': valueWithoutBrackets(sobjectData.DataType__c); } }
        public String vehicleType { get { return sobjectData.VehicleType__c == null? '': valueWithoutBrackets(sobjectData.VehicleType__c); } }
        public String region { get { return sobjectData.Region__c == null? '': valueWithoutBrackets(sobjectData.Region__c); } }
        public String country { get { return sobjectData.Country__c == null? '': valueWithoutBrackets(sobjectData.Country__c); } }
        public String geography { get { return sobjectData.Geography__c == null? '': valueWithoutBrackets(sobjectData.Geography__c); } }
//      public String timePeriod { get { return sobjectData.Time_Period__c == null? '': valueWithoutBrackets(sobjectData.Time_Period__c); } }

        public Boolean isRemoved { get; set; }
        public Boolean removeSelection { get { return isRemoved && sobjectData.Id != null; } }
        
            //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: This method is used in POLK WRF.Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

        public CountrySelection(CountrySelection__c anSobject) {
            isRemoved = false;
            this.sobjectData = anSobject;
            this.sobjectData.DataType__c = correctedForSaving(sobjectData.DataType__c);
            this.sobjectData.VehicleType__c = correctedForSaving(sobjectData.VehicleType__c);
            this.sobjectData.Region__c = correctedForSaving(sobjectData.Region__c);
            this.sobjectData.Country__c = correctedForSaving(sobjectData.Country__c);
            this.sobjectData.Geography__c = correctedForSaving(sobjectData.Geography__c);
        }
        
            //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: This method is used in POLK WRF.Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

        public CountrySelection__c clonedSobjectData() {
            return sobjectData.clone(false, true, false, false);
        }
        
            //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

        public void removeRow() {
            isRemoved = true;
        }
        
            //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: This method is used in POLK WRF.Migrated from Legacy POLK 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

        public String valueWithoutBrackets(String aValue) {
            return String.isBlank(aValue)? '' : aValue.replace('[','').replace(']','');
        }

    //----------------------------- 
    // @Author : Legacy POLK 
    // @date: 11 Oct 2017 
    // @description: This method is used in POLK WRF. 
    // @PROGRAMMER: Anjani Shukla 
    //-----------------------------

        public String correctedForSaving(String aValue) {
            return String.isBlank(aValue)? '' : valueWithoutBrackets(aValue).replace(',',';');
        }
    }
  

}