//-----------------------------
// @author: Mohit Modi
// @date: 6 June 2018
// @param: NA
// @description: Class to hold trigger methods related to AdClaimChangelog Object 
//----------------------------------
public class AdClaimChangeLogMethods {

    //-----------------------------
    // @author: Mohit Modi
    // @date: 6 June 2018
    // @param: NA
    // @description:SFDC1-460 When the claim status of Ad claim Change Log changes to 'Submitted', it is automatically submitted for Approval
    //----------------------------------
    public static void AdClaimChangeLogStatusChange(TriggerParameters tp) {
    
        Map<Id,AdClaimChangeLog__c> mapNewAdClaimChangeLog = (Map<Id,AdClaimChangeLog__c>)tp.newMap;
        Map<Id,AdClaimChangeLog__c> mapOldAdClaimChangeLog = (Map<Id,AdClaimChangeLog__c>)tp.oldMap;
        AdClaimChangeLog__c oldAdClaimChangeLog = new AdClaimChangeLog__c ();
        set<Id> setAdClaimChangelogStatusSubmitted = new set<Id>();
        Map<Id,String> mapAdClaimChangelogStatusApproveOrReject = new Map<Id,String>();
        
        if (tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
        
            for(AdClaimChangeLog__c newAdClaimChangeLog: mapNewAdClaimChangeLog.values()) {
                if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                    oldAdClaimChangeLog = mapOldAdClaimChangeLog .get(newAdClaimChangeLog.Id);
                }
                
                if(oldAdClaimChangeLog != NULL && oldAdClaimChangeLog.Status__c != newAdClaimChangeLog.Status__c && newAdClaimChangeLog.Status__c == 'Submitted') {
                    setAdClaimChangelogStatusSubmitted.add(newAdClaimChangeLog.id);
                }
                else if(oldAdClaimChangeLog != NULL && oldAdClaimChangeLog.Status__c != newAdClaimChangeLog.Status__c && ( newAdClaimChangeLog.Status__c == 'Approved' || newAdClaimChangeLog.Status__c == 'Rejected')) {
                    mapAdClaimChangelogStatusApproveOrReject.put(newAdClaimChangeLog.id,newAdClaimChangeLog.Status__c);
                }
            }
        }
        
        if (tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {
        
            for(AdClaimChangeLog__c newAdClaimChangeLog: mapNewAdClaimChangeLog.values()) {
                
                if(newAdClaimChangeLog.Status__c == 'Submitted') {
                    setAdClaimChangelogStatusSubmitted.add(newAdClaimChangeLog.id);
                }
                else if(newAdClaimChangeLog.Status__c == 'Approved' || newAdClaimChangeLog.Status__c == 'Rejected') {
                    mapAdClaimChangelogStatusApproveOrReject.put(newAdClaimChangeLog.id,newAdClaimChangeLog.Status__c);
                }
            }
        }
        
        if(!setAdClaimChangelogStatusSubmitted.isEmpty()) {
        
            List<Approval.ProcessSubmitRequest> lstApprovalRequest = new list<Approval.ProcessSubmitRequest>();
            for(id tempAdclaimId : setAdClaimChangelogStatusSubmitted) {
                
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setObjectId(tempAdclaimId);
                req1.setSubmitterId(UserInfo.getUserId()); 
                req1.setProcessDefinitionNameOrId('AdClaimChangeLogApprovalProcess');
                req1.setSkipEntryCriteria(true);
                lstApprovalRequest.add(req1);
            }
            List<Approval.ProcessResult> result = Approval.process(lstApprovalRequest);
        }
        
        if(!mapAdClaimChangelogStatusApproveOrReject.isEmpty()) {
            list<ApproveOrRejectAdClaimChangeLog.ApprovalRequestStatus> listApprovalStatus = new list<ApproveOrRejectAdClaimChangeLog.ApprovalRequestStatus>();
            
            for(Id tempAdClaimChangeLogId : mapAdClaimChangelogStatusApproveOrReject.keyset()) {
                ApproveOrRejectAdClaimChangeLog.ApprovalRequestStatus tempApprovalStatus= new ApproveOrRejectAdClaimChangeLog.ApprovalRequestStatus();
                tempApprovalStatus.AdclaimChangeLogID = tempAdClaimChangeLogId;
                tempApprovalStatus.Status = mapAdClaimChangelogStatusApproveOrReject.get(tempAdClaimChangeLogId);
                listApprovalStatus.add(tempApprovalStatus);
            }
            
            if(!listApprovalStatus.isEmpty()) {
                ApproveOrRejectAdClaimChangeLog.ApproveOrRejectAdClaimChangelogRecord(listApprovalStatus);
            }
        }
    }
}