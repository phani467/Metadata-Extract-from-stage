//----------------------------- 
// @Author : Legacy POLK 
// @date: 11 Oct 2017 
// @description: Migrated from Legacy POLK 
// @PROGRAMMER: Anjani Shukla 
//-----------------------------
@isTest
public class TestXedeQueryBuilder {
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    static testMethod void FormattedSetTest() {
        Map<Id, User> aMap = new Map<Id, User>([select Id from User limit 3]);
                
        String setInclusionComparison = XedeQueryBuilder.SetInclusionComparisonFor('Field__c', aMap.keySet());
        
        for (User each : aMap.values())
            setInclusionComparison = setInclusionComparison.replace(each.Id, 'aUserId');
        
        system.assertEquals(setInclusionComparison, '(Field__c in (\'aUserId\', \'aUserId\', \'aUserId\'))');
        
        Set<String> valueSet = new Set<String>{ 'value1', 'value2', 'value3'};
        setInclusionComparison = XedeQueryBuilder.SetInclusionComparisonFor('Field__c', valueSet);
        
        for (String each : valueSet)
            setInclusionComparison = setInclusionComparison.replace(each, 'aValue');
            
        system.assertEquals(setInclusionComparison, '(Field__c in (\'aValue\', \'aValue\', \'aValue\'))');
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    static testMethod void SobjectQueryTest() {
        
        List<Account> accountList = (List<Account>)XedeQueryBuilder.SobjectListFor('Account', UserInfo.getUserId(), 'Id');
        system.assert(accountList.isEmpty());
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    static testMethod void AccountNameQueryTest() {
        
        String queryString = XedeQueryBuilder.QueryStringFor(SOQLFields(), 'Account', XedeQueryBuilder.TextEqualityComparisonFor('Name', 'Baggins'), null, null, null);
        system.assertEquals('select Id, CreatedDate, LastModifiedDate from Account where (Name = \'Baggins\')', queryString);
        
        List<Account> resultList = Database.query(queryString);
        system.assertEquals(0, resultList.size());
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    static testMethod void ExpressionBuilderTest() {
        system.assertEquals('(Field__c = null)', XedeQueryBuilder.TextEqualityComparisonFor('Field__c', null));
        system.assertEquals('(Field__c = \'a target value\')', XedeQueryBuilder.TextEqualityComparisonFor('Field__c', 'a target value'));
        system.assertEquals('(Field__c != \'a target value\')', XedeQueryBuilder.TextInequalityComparisonFor('Field__c', 'a target value'));
        system.assertEquals('(Field__c like \'%a target value%\')', XedeQueryBuilder.TextSimilarityComparisonFor('Field__c', 'a target value'));
        system.assertEquals('(Field__c includes (\'a target value\'))', XedeQueryBuilder.MultiSelectInclusionComparisonFor('Field__c', 'a target value'));
        system.assertEquals('(Field__c >= 1 and Field__c <= 10)', XedeQueryBuilder.IntegerBetweenInclusiveFor('Field__c', 1, 10));
        system.assertEquals('(Field__c >= 1 and Field__c < 10)', XedeQueryBuilder.IntegerBetweenInclusiveLowerFor('Field__c', 1, 10));
        system.assertEquals('(Field__c > 1 and Field__c <= 10)', XedeQueryBuilder.IntegerBetweenInclusiveUpperFor('Field__c', 1, 10));
        system.assertEquals('(Field__c > 1)', XedeQueryBuilder.IntegerGreaterThanFor('Field__c', 1));
        system.assertEquals('(Field__c >= 1)', XedeQueryBuilder.DecimalGreaterThanInclusiveFor('Field__c', 1));
        system.assertEquals('(Field__c >= 1 and Field__c <= 10)', XedeQueryBuilder.DecimalBetweenInclusiveFor('Field__c', 1, 10));
        system.assertEquals('(Field__c > 1.25 and Field__c < 10.25)', XedeQueryBuilder.DecimalBetweenFor('Field__c', 1.25, 10.25));
        system.assertEquals('(Field__c = true)', XedeQueryBuilder.BooleanEqualityComparisonFor('Field__c', true));
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    static testMethod void TestQueryBuilder() {
        
        List<String> andExpressionList = new List<String> {
            XedeQueryBuilder.TextEqualityComparisonFor('Name', 'test account name'),
            XedeQueryBuilder.IntegerGreaterThanInclusiveFor('NumberOfEmployees', 10)
        };
        
        List<String> orExpressionList = new List<String> {
            XedeQueryBuilder.TextEqualityComparisonFor('Phone', '1234568790'),
            XedeQueryBuilder.TextEqualityComparisonFor('Phone', '9876543210')
        };
        
        String andExpressions = String.join(andExpressionList, ' and ');
        String orExpressions = String.join(orExpressionList, ' or ');

        String targetSobject = 'Account';
        
        String queryString = XedeQueryBuilder.QueryStringFor(SOQLFields(), targetSobject, andExpressions, orExpressions, 'CreatedDate desc', 10);
        XedeQueryBuilder.FieldSetExcludingSystemFor(targetSobject);
        system.assert(queryString.contains('select Id, CreatedDate, LastModifiedDate from Account'));
        system.assert(queryString.contains('where (Name = \'test account name\') and (NumberOfEmployees >= 10)'));
        system.assert(queryString.contains('and ((Phone = \'1234568790\') or (Phone = \'9876543210\'))'));
        system.assert(queryString.contains('order by CreatedDate desc'));
        system.assert(queryString.contains('limit 10'));
        
        database.query(queryString);
    }   
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    public static String SOQLFields() {
        return String.join(
            new List<String>{
                'Id',
                'CreatedDate',
                'LastModifiedDate'
            },
            ', '
        );
    }
}