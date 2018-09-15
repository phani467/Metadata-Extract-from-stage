/**
 * @Author: Hemant Shukla
 * @date: 8-Jan-2018
 * @description: A wrapper class for OPS. Used in OpportunityProductEditPage Lightning component.
*/
public class OPSWrapper {
    @AuraEnabled public List<OpportunityLineItemSchedule__c> lstOPS;
    @AuraEnabled public Map<String,List<OpportunityLineItemSchedule__c>> mapOPSAll;
    @AuraEnabled public OpportunityLineItem oppyProduct;
    @AuraEnabled public List<String> lstMapOPSIndex;    
    @AuraEnabled public Decimal productQty;
    @AuraEnabled public String discountType;
    @AuraEnabled public String productTermSelected;
    @AuraEnabled public Boolean isDeleted;
    @AuraEnabled public String status;    

}