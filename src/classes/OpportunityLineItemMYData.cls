//-----------------------------
// @author: Paras Dhingra
// @date: 15th May 2018
// @param: NA
// @description: SFDC1-7976 Generate relationship between opportunitylineitem and schedules to generate drawloop document
// @company: IHS Markit
// @return: None
//------------------------------
global class OpportunityLineItemMYData implements Loop.IApexDataSource {
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 15th May 2018
    // @param: void
    // @description: SFDC1-7976 Method to declare objects for Drawloop
    // @company: IHS Markit
    // @return: Set<String> Set of objects setup for Drawloop
    //------------------------------
    public Set<String> getGlobalDescribe() {
        return new Set<String> {'OpportunityLineItemMYSchedules','OppyLineItem'};
    }
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 15th May 2018
    // @param: List <string >objNames list of objects to be defined
    // @description: SFDC1-7976 Method to create definition of Opportunity related objects for Drawloop
    // @company: IHS Markit
    // @return: List <Loop.ExternalData.DataObject > a list of objects defined using loop api
    //------------------------------
    public List <Loop.ExternalData.DataObject >describeObjects(List <string >objNames) {
        List <Loop.ExternalData.DataObject > output = new List <Loop.ExternalData.DataObject >();
         for (string objectName :objNames) {
            List <Loop.ExternalData.FieldInfo > outputFields = new List <Loop.ExternalData.FieldInfo >();
            if (objectName == 'OpportunityLineItemMYSchedules') {
                //add standard opportunity product schedules fields and establish relationship
                Map<string, Schema.SObjectField> fields = Schema.sObjectType.OpportunityLineItemSchedule__c.fields.getMap();
                outputFields.addAll(createOutPutFields(fields));
                Loop.ExternalData.FieldInfo outputInfo = new Loop.ExternalData.FieldInfo('OLIReference', Schema.DisplayType.REFERENCE);
                outputInfo.referenceTo = 'OppyLineItem';
                outputFields.add(outputInfo);
                
            }
            else if(objectName == 'OppyLineItem') {
                Map<string, Schema.SObjectField> fields = Schema.sObjectType.OpportunityLineItem.fields.getMap();
                outputFields.addAll(createOutPutFields(fields));
                outputFields.add(new Loop.ExternalData.FieldInfo('Product2.Name', Schema.DisplayType.STRING));
                outputFields.add(new Loop.ExternalData.FieldInfo('ProductGoverningExhibit', Schema.DisplayType.STRING));
                
            }
            output.add(new Loop.ExternalData.DataObject(objectName, outputFields));
        }
        return output;
    }
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 15th May 2018
    // @param: String Objectname object name for which children object are to be fetched
    // @description: SFDC1-7976 Method to establish parent-child relationship 
    //              between Opportunityp prod and oppy prod schedules
    // @company: IHS Markit
    // @return: Set<String> return a list of children object related to an object defined via Loop API
    //------------------------------
    public Set <string >getChildRelationships(string objectName) {
        Set<string> childObjectNames = new Set<string>();
        if (objectName == 'OppyLineItem') {
            childObjectNames.add('OpportunityLineItemMYSchedules');
        }
            
        return childObjectNames;
    }
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 15th May 2018
    // @param: Loop.ExternalData.QueryRequestInfo requestInfo loop request param
    // @description: SFDC1-7976 Method to establish parent-child relationship 
    //              between Opportunityp prod and oppy prod schedules
    // @company: IHS Markit
    // @return: Loop.ExternalData.QueryResultSet resultset contains all the data required to establish relationship
    //------------------------------
    public Loop.ExternalData.QueryResultSet query(Loop.ExternalData.QueryRequestInfo requestInfo) {
        Loop.ExternalData.QueryResultSet results = new Loop.ExternalData.QueryResultSet();
        Loop.ExternalData.QueryResult opportunityLineItems = new Loop.ExternalData.QueryResult('OppyLineItem', new List<string>());
        Loop.ExternalData.QueryResult OLISchedules = new Loop.ExternalData.QueryResult('OpportunityLineItemMYSchedules', new List<string>());
        if (string.valueOf(requestInfo.RecordId).startswith(Schema.sObjectType.Opportunity.keyprefix)) {
            
            //fetch and process OpportunitylineItem fields
            List<String> opportunityLineItemFields = new List<String>(Schema.sObjectType.OpportunityLineItem.fields.getMap().keySet());
            List<String> OppyScheduleFields = new List<String>(Schema.sObjectType.OpportunityLineItemSchedule__c.fields.getMap().keySet());
            opportunityLineItemFields.add('Product2.Name');
            
            List<String> queryOpportunityLineItemFields = new List<String>();
            queryOpportunityLineItemFields.addAll(opportunityLineItemFields);
            queryOpportunityLineItemFields.add('PriceBookEntry.Product2.GoverningExhibit__c');
            opportunityLineItemFields.add('ProductGoverningExhibit');
            opportunityLineItems = new Loop.ExternalData.QueryResult('OppyLineItem', opportunityLineItemFields);
            for(OpportunityLineItem oli : (List<OpportunityLineItem>)queryCreator(
                queryOpportunityLineItemFields,'OpportunityLineItem','OpportunityId',requestInfo.RecordId,'=',' AND Status__c!= \'Lost\'','SortOrder, MaterialCode__c ASC')
            ) {
                List<string> oliFieldValues = new List<string>();
                    for (string field : queryOpportunityLineItemFields) {
                        oliFieldValues.add(getFieldValue(oli, field));
                    }
                    opportunityLineItems.rows.add(oliFieldValues);
            }
            //fetch and process opportunityLineItemschedules fields
            List<String> listOLISFields = new List<String>(OppyScheduleFields);
            listOLISFields.add('OLIReference');
            OLISchedules = new Loop.ExternalData.QueryResult('OpportunityLineItemMYSchedules', listOLISFields);
            for(OpportunityLineItemSchedule__c olis : (List<OpportunityLineItemSchedule__c>)queryCreator(
                OppyScheduleFields,'OpportunityLineItemSchedule__c','Opportunity__c',requestInfo.RecordId ,'=','','InstallmentYear__c ASC')
                ) {
                    List<string> olisFieldValues = new List<string>();
                    String OppyProductId = '';
                    for(String field : OppyScheduleFields) {
                        String fieldValue = getFieldValue(olis,field);
                        olisFieldValues.add(fieldValue);
                        if(field=='opportunityproductid__c') {
                            OppyProductId = fieldValue;
                        }
                    }
                    olisFieldValues.add(OppyProductId);
                    OLISchedules.rows.add(olisFieldValues);
                }
                
        }
        for (string objectName : requestInfo.GetObjectNames()) {
            if (objectName == 'OppyLineItem')
                results.add(opportunityLineItems);
            else if (objectName == 'OpportunityLineItemMYSchedules')
                results.add(OLISchedules);
        }
        return results;
    }
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 15th May 2018
    // @param: Map<string, Schema.SObjectField> fields
    // @description: SFDC1-7976 convert salesforce fields into Loop API compatible fields
    // @company: IHS Markit
    // @return: List <Loop.ExternalData.FieldInfo > 
    //------------------------------
    private List <Loop.ExternalData.FieldInfo > createOutPutFields (Map<string, Schema.SObjectField> fields) {
        List <Loop.ExternalData.FieldInfo > outputFields = new List <Loop.ExternalData.FieldInfo >();
        for(string key: fields.keySet()) {
            Schema.DescribeFieldResult info = fields.get(key).getDescribe();
            Loop.ExternalData.FieldInfo outputInfo = new Loop.ExternalData.FieldInfo(info.getName(), info.getType());
            outputInfo.referenceTo = info.getReferenceTo().size() > 0 ? string.valueOf(info.getReferenceTo()[0]) : null;
            outputInfo.scale = info.getScale();
            outputInfo.label = info.getLabel();
            outputFields.add(outputInfo);
        }
        return outputFields;
    }
    private string getFieldValue(sObject obj, string field) {
        if (obj == null) return '';
        string[] fieldParts = field.split('\\.');
        if (fieldParts.size() == 3) {
            sObject sobj = obj.getSObject(fieldParts[0]);
            if (sobj == null) return '';
            sobj = sobj.getSObject(fieldParts[1]);
            if (sobj == null) return '';
            return string.valueOf(sobj.get(fieldParts[2]));
        }
        else if (fieldParts.size() == 2) {
            sObject sobj = obj.getSObject(fieldParts[0]);
            if (sobj == null) return '';
            return string.valueOf(sobj.get(fieldParts[1]));
        }
        return string.valueOf(obj.get(field));
    }
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 15th May 2018
    // @param: Map<string, Schema.SObjectField> fields
    // @description: SFDC1-7976 this method generates a generice query and return requested records
    // @company: IHS Markit
    // @return: List<sObject> list of records searched through query
    //------------------------------
    private List<sObject> queryCreator(List<string> fields, string objectName, string idName, string recordId, string inOrEquals, string additionalfilters, string orderBy) {
        string soql = string.format(
            'SELECT {0} FROM {1} WHERE {2} {3} {4} {5} {6}',
            new List<string>{
                string.join(fields, ','),
                objectName,
                idName,
                inOrEquals,
                '\''+recordId+'\'',
                string.isBlank(additionalfilters)?'':additionalfilters,
                string.isBlank(orderBy) ? '' : 'ORDER BY '+orderBy
            }
        );
        return Database.query(soql);
    }
}