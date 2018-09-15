/**
 * @Author Dan Measures
 * @Date 02nd Nov 2017
 * @Description SFDC1-5510 Controller for RecordEdit component to show additional field record for edit
 * @company Salesforce
 */

public class RecordEditController {
     /**
      * @author Dan Measures
      * @date 02nd Nov 2017
      * @description SFDC1-5510 Controller for RecordEdit component to show additional field record for edit
      * @param Id
      * @return Case
      * @companyname Salesforce
      */
 	@AuraEnabled
    public static Case getCase(Id caseId) {
        return [select Id, AdditionalFields__c from Case where Id =:caseId];
    }
}