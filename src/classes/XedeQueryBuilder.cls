//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This class is used in POLK WRF.

    //----------------------------- 
public class XedeQueryBuilder {
//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String,Boolean
    // @description:  This method is used in POLK WRF.
    // @return: String
    //----------------------------- 
    public static String BooleanEqualityComparisonFor(String fieldName, Boolean target) {
        return String.format('({0} = {1})', new List<String> { fieldName, String.valueOf(target == true) });
    }
   //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String,String
    // @description:  This method is used in POLK WRF.
    // @return: String
    //----------------------------- 
    public static String TextEqualityComparisonFor(String fieldName, String target) {
        target = target == null ? target : '\''+ target + '\'';
        return String.format('({0} = {1})', new List<String> { fieldName, target });
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param:String,String 
    // @description:  This method is used in POLK WRF.
    // @return: String
    //----------------------------- 
    public static String TextInequalityComparisonFor(String fieldName, String target) {
        return String.format('({0} != {1})', new List<String> { fieldName, '\''+ target + '\''});
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String, String
    // @description:  This method is used in POLK WRF.
    // @return: String
    //----------------------------- 
    public static String TextSimilarityComparisonFor(String fieldName, String target) {
        return String.format('({0} like {1})', new List<String> { fieldName, '\'%'+ target + '%\''});
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String,Set<Id>
    // @description:  This method is used in POLK WRF.
    // @return: String
    //----------------------------- 
    public static String SetInclusionComparisonFor(String fieldName, Set<Id> valueSet) {
        String formattedForQuery = FormatForQueryString(valueSet);
        return String.format('({0} in {1})', new List<String> { fieldName, formattedForQuery });
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String fieldName, Set<String> valueSet
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //----------------------------- 
    public static String SetInclusionComparisonFor(String fieldName, Set<String> valueSet) {
        String formattedForQuery = FormatForQueryString(valueSet);
        return String.format('({0} in {1})', new List<String> { fieldName, formattedForQuery });
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String fieldName, String target
    // @description:  This method is used in POLK WRF.
    // @return: String
    //----------------------------- 
    public static String MultiSelectInclusionComparisonFor(String fieldName, String target) {
        system.debug('fieldName****'+fieldName);
        system.debug('target****'+target);
        system.debug('*********'+String.format('({0} includes {1})', new List<String> { fieldName, '(\''+ target + '\')'}));
        return String.format('({0} includes {1})', new List<String> { fieldName, '(\''+ target + '\')'});
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String fieldName, Integer minimum
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //----------------------------- 
    public static String IntegerGreaterThanFor(String fieldName, Integer minimum) {
        return NumericGreaterThanFor(fieldName, String.valueOf(minimum));
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String fieldName, Integer minimum
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //----------------------------- 
    public static String IntegerGreaterThanInclusiveFor(String fieldName, Integer minimum) {
        return NumericGreaterThanInclusiveFor(fieldName, String.valueOf(minimum));
    }
   //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static String IntegerBetweenInclusiveFor(String fieldName, Integer lower, Integer upper) {
        return NumericBetweenInclusiveFor(fieldName, String.valueOf(lower), String.valueOf(upper));
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String fieldName, Integer lower, Integer upper
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //----------------------------- 
    public static String IntegerBetweenInclusiveLowerFor(String fieldName, Integer lower, Integer upper) {
        return NumericBetweenInclusiveLowerFor(fieldName, String.valueOf(lower), String.valueOf(upper));
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String fieldName, Integer lower, Integer upper
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //----------------------------- 
    public static String IntegerBetweenInclusiveUpperFor(String fieldName, Integer lower, Integer upper) {
        return NumericBetweenInclusiveUpperFor(fieldName, String.valueOf(lower), String.valueOf(upper));
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static String DecimalGreaterThanInclusiveFor(String fieldName, Decimal minimum) {
        return NumericGreaterThanInclusiveFor(fieldName, String.valueOf(minimum));
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param:String fieldName, Decimal lower, Decimal upper 
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //----------------------------- 
    public static String DecimalBetweenInclusiveFor(String fieldName, Decimal lower, Decimal upper) {
        return NumericBetweenInclusiveFor(fieldName, String.valueOf(lower), String.valueOf(upper));
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String fieldName, Decimal lower, Decimal upper
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //----------------------------- 
    public static String DecimalBetweenFor(String fieldName, Decimal lower, Decimal upper) {
        return NumericBetweenFor(fieldName, String.valueOf(lower), String.valueOf(upper));
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String fieldName, String lowerLimit, String upperLimit
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //----------------------------- 
    
    public static String NumericBetweenInclusiveFor(String fieldName, String lowerLimit, String upperLimit) {
        return String.format('({0} >= {1} and {0} <= {2})', new List<String> { fieldName, lowerLimit, UpperLimit });        
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String fieldName, String lowerLimit, String upperLimit
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //----------------------------- 
    public static String NumericBetweenFor(String fieldName, String lowerLimit, String upperLimit) {
        return String.format('({0} > {1} and {0} < {2})', new List<String> { fieldName, lowerLimit, UpperLimit });      
    }
    
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static String NumericBetweenInclusiveLowerFor(String fieldName, String lowerLimit, String upperLimit) {
        return String.format('({0} >= {1} and {0} < {2})', new List<String> { fieldName, lowerLimit, UpperLimit });     
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String fieldName, String lowerLimit, String upperLimit
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //-----------------------------
    public static String NumericBetweenInclusiveUpperFor(String fieldName, String lowerLimit, String upperLimit) {
        return String.format('({0} > {1} and {0} <= {2})', new List<String> { fieldName, lowerLimit, UpperLimit });     
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String fieldName, String minimum
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //----------------------------- 
    public static String NumericGreaterThanInclusiveFor(String fieldName, String minimum) {
        return String.format('({0} >= {1})', new List<String> { fieldName, minimum });      
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 

    public static String NumericGreaterThanFor(String fieldName, String minimum) {
        return String.format('({0} > {1})', new List<String> { fieldName, minimum });       
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: Set<String> aSet
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //----------------------------- 
    public static String FormatForQueryString(Set<String> aSet) {
        List<String> aList = new List<String>(aSet);
        String joinedList = String.join(aList, '\', \'');
        return String.format('({0})', new List<String> { '\''+joinedList+'\'' } );
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: Set<Id> anIdSet
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //----------------------------- 
    public static String FormatForQueryString(Set<Id> anIdSet) {
        List<Id> anIdList = new List<Id>(anIdSet);
        String joinedList = String.join(anIdList, '\', \'');
        return String.format('({0})', new List<String> { '\''+joinedList+'\'' } );
    }

    // if used... all andExpressions must be true to include results, one orExpression must be true to include results
    public static String InnerQueryStringFor(String queryFields, String targetSobject, String andExpressions, String orExpressions, String orderByField, Integer limitValue) {
        return '('+QueryStringFor(queryFields, targetSobject, andExpressions, orExpressions, orderByField, limitValue)+')';
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String queryFields, String targetSobject, String andExpressions, 
    //         String orExpressions, String orderByField, Integer limitValue
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //----------------------------- 
    public static String QueryStringFor(String queryFields, String targetSobject, String andExpressions, 
                                        String orExpressions, String orderByField, Integer limitValue) {
        String orderByClause = String.isBlank(orderByField) ? '' : 'order by ' + orderByField;
        String limitClause = limitValue == null || limitValue < 1 ? '' : 'limit ' + limitValue;
        
        String filterExclude = String.isBlank(andExpressions) ? '' : andExpressions;
        String scoring = String.isBlank(orExpressions) ? '' : '('+ orExpressions +')';
        String connector = String.isBlank(filterExclude) || String.isBlank(scoring) ? '' : 'and';
        String whereClause = String.isBlank(filterExclude) && String.isBlank(scoring) ? '' : 'where';
        
        String queryString = String.format(
            'select {0} from {1} {2} {3} {4} {5} {6} {7}',
            new List<String> {
                queryFields,
                targetSobject,
                whereClause,
                filterExclude,
                connector,
                scoring,
                orderByClause,
                limitClause
            }
        );
        system.debug('queryString*****'+queryString);
        return queryString.trim();
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: string sobjectName, Id sobjId, String sobjfield
    // @description:  This method is used in POLK WRF.
    // @return: List<sobject>
    //----------------------------- 
    public static List<sobject> SobjectListFor(string sobjectName, Id sobjId, String sobjfield) {
        Set<String> fieldNameSet = FieldSetFor(sobjectName);
        List<String> excludeList = new List<String> {
            'CreatedById', 'IsDeleted', 'LastModifiedById', 'LastModifiedDate', 'RecordTypeId', 'SystemModstamp'
        };
        fieldNameSet.removeAll(excludeList);
        String dynamicFields = String.join(new List<String>(fieldNameSet), ', ');  
        String query = QueryStringFor(dynamicFields, sobjectName, TextEqualityComparisonFor(sobjfield, sobjId), null, null, null);
        return Database.query(query);
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String sobjectName
    // @description:  This method is used in POLK WRF.
    // @return: Set<String>
    //----------------------------- 
    public static Set<String> FieldSetFor(String sobjectName) {
        system.debug('Xedebuilder 343--->');
        Schema.Describesobjectresult sobjectResult = Schema.describeSObjects(new List<String>{ sobjectName })[0];
        system.debug('Xedebuilder 345--->'+sobjectResult);
        Map<String, Schema.SObjectField> fieldMap = sobjectResult.fields.getMap();
        system.debug('Xedebuilder 347--->'+fieldMap);
        return new Set<String>(fieldMap.keySet());
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: String sobjectName
    // @description:  This method is used in POLK WRF.
    // @return: String 
    //----------------------------- 
    public static String FieldSetExcludingSystemFor(String sobjectName) {
        Set<String> fieldNameSet = FieldSetFor(sobjectName);
        List<String> excludeList = new List<String> {
            'CreatedById', 'IsDeleted', 'LastModifiedById', 'LastModifiedDate', 'RecordTypeId', 'SystemModstamp'
        };
        fieldNameSet.removeAll(excludeList);
        return String.join(new List<String>(fieldNameSet), ',');  
    }
    
}