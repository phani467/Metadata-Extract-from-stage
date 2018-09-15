global class ObjectDetailsController {
    public List<SelectOption> objectNames { get; set; }
    public String selectedObjName { get; set; }
    public List<String> picklistFieldNames { get; set; }
    public Map<String, List<String>> objPicklistMap { get; set; }
    
    public ObjectDetailsController(){
        objectNames = new List<SelectOption>();
        fetchObjectNames();
        
    }
    
    public void fetchObjectNames(){
        Map<String, String> objectNameLabel = new Map<String, String>();
        for ( Schema.SObjectType o : Schema.getGlobalDescribe().values() ) {
            Schema.DescribeSObjectResult objResult = o.getDescribe();
            if(objResult.isCreateable()){
               String objLabel = objResult.isCustom() ? objResult.getLabel() + ' (*c*)' : objResult.getLabel();
               objectNameLabel.put(objLabel, objResult.getName());
               // objectNames.add(new SelectOption(objResult.getName(), objLabel));
            }
        }
        List<String> listToSort = new List<String>();
        for(String s : objectNameLabel.keySet()){
            listToSort.add(s);
        }
        listToSort.sort();
        for(String s: listToSort){
            objectNames.add(new SelectOption(objectNameLabel.get(s), s));
        }
        //objectNames.sort();
        objectNames.add(0,new SelectOption('None', '--None--'));
    }
    
    public void getPicklistValues(){
        if(selectedObjName == 'None'){
          picklistFieldNames = new List<String>();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the object'));
            return;
        }
        objPicklistMap = new Map<String, List<String>>();
        picklistFieldNames = new List<String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType ObjectSchema = schemaMap.get(selectedObjName);
        Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
        for(String fieldName: fieldMap.keySet()) {  
            List<String> fieldsList = new List<String>();
            if(fieldMap.get(fieldName).getDescribe().getType() == Schema.DisplayType.PICKLIST)
            {
                list<Schema.PicklistEntry> values = fieldMap.get(fieldName).getDescribe().getPickListValues();
                for (Schema.PicklistEntry a : values){ 
                    fieldsList.add(a.getValue());
                }
                String fieldLabelName = fieldMap.get(fieldName).getDescribe().isCustom() ? fieldMap.get(fieldName).getDescribe().getLabel()+' (*c*)' : fieldMap.get(fieldName).getDescribe().getLabel();
                picklistFieldNames.add(fieldLabelName);
                objPicklistMap.put(fieldLabelName, fieldsList);
            }
        }
        //picklistFieldNames = objPicklistMap.keySet();
    }
    
    global class Objects implements Comparable {

    public String name;
    public String apiName;
    
    // Constructor
    public Objects(String name, String apiName) {
        this.name = name;
        this.apiName = apiName;
    }
    
    // Implement the compareTo() method
    global Integer compareTo(Object compareTo) {
        Objects compareToEmp = (Objects)compareTo;
        if (name == compareToEmp.name) return 0;
        if (name > compareToEmp.name) return 1;
        return -1;        
    }
}
}