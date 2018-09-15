//-----------------------------
// @author: Jagadesh Kumar
// @date: 06 June 2018
// @param: NA
// @description: Class to hold trigger methods 
// @return: NA
//-----------------------------
public class InternalApprovalMethods {
    //-----------------------------
    // @author: Jagadesh Kumar
    // @date: 06 June 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-8542,SFDC1-6282: Populate the Contract Owner field of the new Internal Approval record with 
    // the Owner of the Contract on which it is created and send notification.
    // @return: NA
    //------------------------------
    public static void populateContractOwner(TriggerParameters tp) {
        Set<Id> contractIds = new Set<Id>();
        if(tp.tEvent==TriggerParameters.TriggerEvent.beforeInsert) {
            for (InternalApproval__c inApproval : (List<InternalApproval__c>)tp.newList) {
                contractIds.add(inApproval.Contract__c);
            }
            if(contractIds.size() > 0) {
                Map<Id,Contract> contractUserIdMap = new Map<Id,Contract>([SELECT Id,OwnerId FROM Contract 
                                                                           WHERE Id IN : contractIds]);
                for (InternalApproval__c inApproval : (List<InternalApproval__c>)tp.newList) {
                    if(contractUserIdMap.get(inApproval.Contract__c) != null) {
                    	inApproval.ContractOwner__c = contractUserIdMap.get(inApproval.Contract__c).OwnerId;    
                    }
                }
            }
        }
    }

}