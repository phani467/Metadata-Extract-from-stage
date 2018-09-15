/**
 * @author: Paras Dhingra
 * @date : 17th Sep 2017
 * @description: SFDC1-101 Controller for lightning component to fetch related
 * 				Opportunity product schedules
*/

public class OppyProductSchedulesListController {
	@AuraEnabled
    public static List<OpportunityLineItemSchedule__c> getOppyProdSchedules(String oppyProdId){
        List<OpportunityLineItemSchedule__c> lstOppyProductSchds = [Select id, DiscountPercent__c,DiscountAmount__c,DiscountType__c,ExternalListPrice__c,
                                         InstallmentYears__c, OpportunityProductID__c, OpportunityProductScheduleKey__c,
                                         PriceBookListPrice__c, Product__c,ProductSchedule__c, SalesPrice__c, TotalPrice__c, Quantity__c, CurrencyISOCode from
                                         OpportunityLineItemSchedule__c where OpportunityProductID__c=:oppyProdId order by InstallmentYears__c ASC];
        //process percentages
        for(OpportunityLineItemSchedule__c ops : lstOppyProductSchds) {
            if(ops.DiscountPercent__c!=null) {
             	ops.DiscountPercent__c= ops.DiscountPercent__c/100;   
            }
        }
        return lstOppyProductSchds;
    }
}