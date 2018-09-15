/**
 * @Author: Paras Dhingra
 * @Date: 25th Oct 2017
 * @Description: SFDC1-629 Generic controller custom lightning controller
 * @company: IHS Markit
 */
public class customLookUpController {
     /**
      * @author: Paras Dhingra
      * @date: 25th Oct 2017
      * @description: SFDC1-629 method to get records for custom lookup for any object
      * @param: String,String
      * @return: List <sObject>
      * @companyname: IHS Markit
      */
  @AuraEnabled
    public static List <sObject> fetchLookUpValues(String searchKeyWord, String ObjectName, String optionalFilter) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = '%'+ searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        if(optionalFilter == null) {
            optionalFilter = '';
        }
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5
        String sQuery =  'select id, Name from ';
        String filter = ' where Name LIKE:searchKey ' + optionalFilter;
        String orderby = '  order by Name ASC limit 5';
        sQuery = sQuery + ObjectName + filter + orderby;
        System.debug('--sQuery--'+sQuery);
        List <sObject> lstOfRecords = Database.query(sQuery);
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
}