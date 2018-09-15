/**
 * @Author : Mohit Modi
 * @Date : 14 Nov 2017
 * @Description : SFDC1-5723 Method to check the Record access for the given user, This Class will be used in multiple Lightning Components
 *    to check the record access before proceed further.
 * @company : Vertiba
 */
public class ProductSelectorController {

    /**
     * @author : Mohit Modi
     * @date : 14 Nov 2017
     * @description : SFDC1-5723 Method to check the Record access for the given user
     * @param : User Id, Record Id
     * @return : Boolean
     * @companyname : Vertiba
     * @Last Modified By : Prachi Bhasin
     * @Last Modified Date: 23 April 2018
     * @Last Modified Description: SFDC1-6568 -When oppty stage is 6WP, nobody should be able to add products
	 * @Last Modified By : Jagadesh Kumar
     * @Last Modified Date: 08 May 2018
     * @Last Modified Description: SFDC1-7676 -Inner Year Record
     * @Last Modified By : Jagadesh Kumar
     * @Last Modified Date: 04 June 2018
     * @Last Modified Description: SFDC1-8505 -In order to add new products to an Auto Renewal, you must first click the Change Auto Renew? button.
     */
     @auraEnabled
     public static ProductSelectorValidatorWrapper checkRecordAccessforUser (Id usrId, id recordId, String actionType) {
         Boolean accessresult = UtilityClass.checkRecordAccessforUser(usrId, recordId);
         Opportunity opp = [Select id, StageName,RecordType.Name,AutoRenewal__c,DoesThisAutoRenewalHaveChanges__c from Opportunity where id=:recordId];
         String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
         ProductSelectorValidatorWrapper wrapper = new ProductSelectorValidatorWrapper();
         system.debug('ProfileName'+profileName);
         Boolean finalResult ;
         if(!accessresult && actionType == 'Add Products') {//user does not have edit access to opportunity
             wrapper.isSuccess = false;
             wrapper.validationMessage = 'You don\'t have access to add/edit products on this Opportunity.';
             return wrapper;// return from here as no further checks are required
         }
        wrapper.isSuccess = true;//setting access level to true as user has edit access to opportunity
        if(accessresult) {
            if(opp.StageName == '6WP-Closed Won/Order Processed' && !profileName.contains('System Administrator') && !profileName.contains('IHSMarkit System Admin')) {
                wrapper.isSuccess = false;
                wrapper.validationMessage = 'You don\'t have access to add/edit products on a closed Opportunity.';
                return wrapper;
            } 
        //Inner Year record Check
            if(opp.RecordType.Name == 'Inner Year' && !profileName.contains('System Administrator') && !profileName.contains('IHSMarkit System Admin')) {
                wrapper.isSuccess = false;
                wrapper.validationMessage = 'You don\'t have access to add/edit products on an Inner Year Opportunity.';
                return wrapper;
            }
            if(actionType == 'Add Products' && opp.AutoRenewal__c && !opp.DoesThisAutoRenewalHaveChanges__c) {
                wrapper.isSuccess = false;
                wrapper.validationMessage = 'In order to add new products to an Auto Renewal, you must first click the Change Auto Renew? button.'; 
            }
        }

         return wrapper;
     }
     
     /**
     * @author : Paras Dhingra
     * @date : 20 Nov 2017
     * @description : SFDC1-5824 Method to check whether user is logged in from community or not
     * @param : void
     * @return : Boolean
     * @companyname : IHS Markit
     */
    @auraEnabled
    public static boolean isCommunity() {        
		return UtilityClass.isCommunity();
	}
    
    public class ProductSelectorValidatorWrapper {
        
        @AuraEnabled public Boolean isSuccess;
        @AuraEnabled public String validationMessage;
        
    }
     
}