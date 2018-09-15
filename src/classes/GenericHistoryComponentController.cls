//-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This Class is related to Legacy POLK application.
// @return: NA
//----------------------------- 

public class GenericHistoryComponentController {
    // External variables
    public SObject myObject {get; set;}
    public Integer recordLimit {get; set;}
    public static String objectLabel {get;}
    public boolean scroll {get; set;}
    
    // Internal Variables
    public objectHistoryLine[] objectHistory; 
    
    //External static variables
    public static final Map<String, Schema.SObjectType> mySObjectTypeMap = Schema.getGlobalDescribe();
    public static Map<String, Schema.SObjectField> myObjectFieldMap;
    public static List<Schema.PicklistEntry> historyFieldPicklistValues;
  //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method Retrieves, analyzes, and formats the history of the object specified by myObject
// @returns: A list of objectHistoryLine objects representing the field history of myObject
//-----------------------------   
    
    public List<objectHistoryLine> getObjectHistory(){
        
        Id myObjectId = String.valueOf(myObject.get('Id'));
        if(myObjectId == null)
            return null; //cannot continue if object is not in the database
        //retrieve object type's metadata
        Schema.DescribeSObjectResult objectDescription = myObject.getSObjectType().getDescribe();
        //get map of field data
        myObjectFieldMap = objectDescription.fields.getMap();
        //get label for myObject
        objectLabel = String.valueOf(objectDescription.getLabel());
        
        //Get the name of the history table
        String objectHistoryTableName = objectDescription.getName();
        //if we have a custom object we need to drop the 'c' off the end before adding 'History' to get the history tables name
        if (objectDescription.isCustom()){
            objectHistoryTableName = objectHistoryTableName.substring(0, objectHistoryTableName.length()-1);
        }
        //results in StandardObjectHistory or Custom_Object__History
        objectHistoryTableName = objectHistoryTableName + 'History';
        //get metadata of history table, get its fields,get Field description (field metadata for the Field the history is talking about)
        Schema.DescribeFieldResult objectHistoryFieldField = mySObjectTypeMap.get(objectHistoryTableName).getDescribe().fields.getMap().get('Field').getDescribe();
        //get which of the fields are PickList types
        historyFieldPicklistValues = objectHistoryFieldField.getPickListValues();

        if (recordLimit== null){
            recordLimit = 100;
        }

        list<sObject> historyList = Database.query('SELECT CreatedDate,'+
                                                   'CreatedById,'+
                                                   'Field,'+
                                                   'NewValue,'+
                                                   'OldValue ' +
                                                   'FROM ' + objectHistoryTableName + ' ' +
                                                   'WHERE ParentId =\'' + myObjectId + '\' ' +
                                                   'ORDER BY CreatedDate DESC '+
                                                   'LIMIT ' + String.valueOf(recordLimit));
        return processHistoryLines(historyList); 
    }
   //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  This method is related to Legacy POLK application.
// @returns: A list of objectHistoryLine objects representing the field history of myObject
//-----------------------------    
    public List<objectHistoryLine> processHistoryLines(List<sObject> historyList) {
        String prevDate = ''; //so that multiple lines for the same change aren't listing date/user data repeatedly
        list<objectHistoryLine> objectHistory = new list<objectHistoryLine>();
        
        for(Integer i = 0; i < historyList.size(); i++){
            sObject historyLine = historyList.get(i);
            if ((historyLine.get('newValue') == null && historyLine.get('oldValue') == null) 
                || (historyLine.get('newValue') != null && !(string.valueOf(historyLine.get('newValue')).startsWith('005') || string.valueOf(historyLine.get('newValue')).startsWith('00G')))
                || (historyLine.get('oldValue') != null && !(string.valueOf(historyLine.get('oldValue')).startsWith('005') || string.valueOf(historyLine.get('oldValue')).startsWith('00G')))){
                    objectHistoryLine tempHistory = new objectHistoryLine();
                    // Set the Date and who performed the action as long as the action
                    // isn't part of an ongoing series from the same change
                    if (String.valueOf(historyLine.get('CreatedDate')) != prevDate){
                        DateTime createdDate = (DateTime)historyLine.get('CreatedDate');
                        tempHistory.theDate = createdDate != null? createdDate.format('MM/dd/yyyy') : 'Null';
                        //tempHistory.theDate = String.valueOf(historyLine.get('CreatedDate'));
                        tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
                        tempHistory.who = String.valueOf(historyLine.get('CreatedById'));
                    }
                    //If the action is part of a series in the same change, leave these fields blank
                    else{
                        tempHistory.theDate = '';
                        tempHistory.who = '';
                        tempHistory.userId = String.valueOf(historyLine.get('CreatedById'));
                    }
                    prevDate = String.valueOf(historyLine.get('CreatedDate'));
                    
                    // Get the field label
                    String fieldLabel = GenericHistoryComponentController.returnFieldLabel(String.valueOf(historyLine.get('Field')));
                    
                    // Set the Action value
                    if (String.valueOf(historyLine.get('Field')) == 'created') { // on Creation
                        tempHistory.action = 'Created.';
                    }
                    else if (historyLine.get('oldValue') != null && historyLine.get('newValue') == null){ // when deleting a value from a field
                        // Format the Date and if there's an error, catch it and re
                        try {
                            tempHistory.action = 'Deleted ' + Date.valueOf(historyLine.get('oldValue')).format() + ' in <b>' + fieldLabel + '</b>.';
                        } catch (Exception e){
                            tempHistory.action = 'Deleted ' + String.valueOf(historyLine.get('oldValue')) + ' in <b>' + fieldLabel + '</b>.';
                        }
                    }
                    else{ // all other scenarios
                        String fromText = '';
                        if (historyLine.get('oldValue') != null) {
                            try {
                                fromText = ' from ' + Date.valueOf(historyLine.get('oldValue')).format();
                            } catch (Exception e) {
                                fromText = ' from ' + String.valueOf(historyLine.get('oldValue'));
                            }
                        } else {
                            fromText = ' from Null';
                        }
                        
                        String toText = '';
                        try {
                            toText = Date.valueOf(historyLine.get('newValue')).format();
                        } catch (Exception e) {
                            toText = String.valueOf(historyLine.get('newValue'));
                        }

                        if (historyLine.get('newValue') != null || historyLine.get('oldValue') != null){
                            tempHistory.action = 'Changed <b>' + fieldLabel + '</b>' + fromText + ' to <b>' + toText + '</b>.';
                        }
                        else {
                            tempHistory.action = 'Changed <b>' + fieldLabel + '</b>.';
                        }
                    }
                    
                    // Add to the list
                    objectHistory.add(tempHistory);
                }         
        }
        
        //collect all users present on field history changes
        List<Id> userIdList = new List<Id>();
        for (objectHistoryLine myHistory : objectHistory){
            userIdList.add(myHistory.userId);
        }
        //retrieve their Name from the database
        Map<Id, User> userIdMap = new Map<ID, User>([SELECT Name FROM User WHERE Id IN : userIdList]);
        //populate objectHistoryLine.who fields for the object's history
        for (objectHistoryLine myHistory : objectHistory){
            if (userIdMap.containsKey(myHistory.userId) & (myHistory.who != '') ){
                myHistory.who = userIdMap.get(myHistory.who).Name;
            }
        }
        
        return objectHistory;
    } 
   //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: The API Name of the desired field
// @description:  This method Function to return Field Label of an object field given a Field API name.
// @returns: The Label of the desired field
//-----------------------------      

    public Static String returnFieldLabel(String fieldName){
        
        //If it's in the map already, simply retrieve label
        if (GenericHistoryComponentController.myObjectFieldMap.containsKey(fieldName)){
            return GenericHistoryComponentController.myObjectFieldMap.get(fieldName).getDescribe().getLabel();
        }
        else { //otherwise, it's a picklist, so search through the previously queried picklist values
            for(Schema.PicklistEntry pickList : historyFieldPicklistValues){
                if (pickList.getValue() == fieldName){
                    if (pickList.getLabel() != null){
                        return pickList.getLabel();
                    }
                    else {
                        return pickList.getValue();
                    }
                }
            }
        }
        return '';
    }
     //-----------------------------
// @author: Legacy POLK Application
// @company: VERTIBA/POLK
// @date: 17 Oct 2017
// @param: NA
// @description:  Inner Class to store the detail of the object history lines
// @returns: NA
//-----------------------------    
   
    public class objectHistoryLine {
        
        public String theDate {get; set;}
        public String who {get; set;}
        public Id userId {get; set;} 
        public String action {get; set;}
    }
}