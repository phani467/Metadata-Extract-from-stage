//-----------------------------
// @author: Harshit Singhal
// @date: 19 Jun 2018
// @param: NA
// @description: SFDC1-8545 Class to hold RenewalatRiskTrigger methods 
// @return: NA
//-----------------------------
public class RenewalatRiskMethods {
	
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 19 Jun 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-8545 Convert Process Builder flow "UpdateRiskCustomerContactinOpportunityatRisk" on RenewalatRisk__c object created in SFDC1-6707(Updates to Opportunity at Risk Object when a new record is created) to a trigger
    // 				 This methods sets Risk Customer Contact field with Primary Contact of parent opportunity during before insert transactions.
    // 
    // @return: None
    //------------------------------
    public static void setRiskCustomerContactinOppatRisk(TriggerParameters tp) {        
        Set<Id> oppIdSet = new Set<Id>();
        Map<Id,Id> oppIdContactIdMap = new Map<Id,Id>();
        //Collect unique opportunity Ids
        for(RenewalatRisk__c newOaR: (List<RenewalatRisk__c>)tp.newList) {            
            if(newOaR.OpportunityAtRisk__c != null) {
                oppIdSet.add(newOaR.OpportunityAtRisk__c);
            }
        }        
        //Get Primary Contact of opportunities
        if(oppIdSet.size() > 0) {
            for(OpportunityContactRole oppConRole: [Select ContactId,OpportunityId From OpportunityContactRole Where isPrimary = true and OpportunityId In :oppIdSet]) {
                oppIdContactIdMap.put(oppConRole.OpportunityId, oppConRole.ContactId);
            }
        }        
        //Set Risk Customer Contact on Opportunity at Risk records
        for(RenewalatRisk__c newOaRtoUpdate: (List<RenewalatRisk__c>)tp.newList) {
            if(oppIdContactIdMap.containsKey(newOaRtoUpdate.OpportunityAtRisk__c)) {
                newOaRtoUpdate.RiskCustomerContact__c = oppIdContactIdMap.get(newOaRtoUpdate.OpportunityAtRisk__c);                
            }
        }        
    }
}