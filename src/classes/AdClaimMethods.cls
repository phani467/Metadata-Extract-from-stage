//-----------------------------
// @author: Mohit Modi
// @date: 6 June 2018
// @param: NA
// @description: Class to hold trigger methods related to AdClaim Object 
//----------------------------------
public class AdClaimMethods {

    //-----------------------------
    // @author: Mohit Modi
    // @date: 6 June 2018
    // @param: NA
    // @description:SFDC1-366 When the claim status of Ad claim changes to 'Submitted', it is automatically submitted for Approval
    //----------------------------------
    public static void AdClaimStatusChange(TriggerParameters tp) {
        
        Map<Id,AdClaim__c> mapNewAdClaim = (Map<Id,AdClaim__c>)tp.newMap;
        Map<Id,AdClaim__c> mapOldAdClaim = (Map<Id,AdClaim__c>)tp.oldMap;
        AdClaim__c oldAdClaim = new AdClaim__c ();
        set<Id> setAdClaimStatusSubmitted = new set<Id>();
        set<Id> setAdClaimStatusApproved = new set<Id>();
        set<Id> setAdClaimStatusReject = new set<Id>();
        
        if (tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
        
            for(AdClaim__c newAdClaim: mapNewAdClaim.values()) {
                if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
                    oldAdClaim = mapOldAdClaim .get(newAdClaim.Id);
                }
                if(oldAdClaim != NULL && oldAdClaim.ClaimsStatus__c != newAdClaim.ClaimsStatus__c && newAdClaim.ClaimsStatus__c == 'Submitted') {
                    setAdClaimStatusSubmitted.add(newAdClaim.id);
                }
                else if(oldAdClaim != NULL && oldAdClaim.ClaimsStatus__c != newAdClaim.ClaimsStatus__c && newAdClaim.ClaimsStatus__c == 'Approved') {
                    setAdClaimStatusApproved.add(newAdClaim.id);
                }
                else if(oldAdClaim != NULL && oldAdClaim.ClaimsStatus__c != newAdClaim.ClaimsStatus__c && newAdClaim.ClaimsStatus__c == 'Rejected') {
                    setAdClaimStatusReject.add(newAdClaim.id);
                }
            }
        }
        
        if (tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {
        
            for(AdClaim__c newAdClaim: mapNewAdClaim.values()) {
                
                if(newAdClaim.ClaimsStatus__c == 'Submitted') {
                    setAdClaimStatusSubmitted.add(newAdClaim.id);
                }
                else if(newAdClaim.ClaimsStatus__c == 'Approved') {
                    setAdClaimStatusApproved.add(newAdClaim.id);
                }
                else if(newAdClaim.ClaimsStatus__c == 'Rejected') {
                    setAdClaimStatusReject.add(newAdClaim.id);
                }
            }
        }
        
        if(!setAdClaimStatusSubmitted.isEmpty()) {
        
            System.debug('setAdClaimStatusSubmitted----'+setAdClaimStatusSubmitted);
            List<Approval.ProcessSubmitRequest> lstApprovalRequest = new list<Approval.ProcessSubmitRequest>();
            for(id tempAdclaimId : setAdClaimStatusSubmitted) {
                
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setObjectId(tempAdclaimId);
                req1.setSubmitterId(UserInfo.getUserId()); 
                req1.setProcessDefinitionNameOrId('AdClaimApprovalProcess');
                req1.setSkipEntryCriteria(true);
                lstApprovalRequest.add(req1);
            }
            
            List<Approval.ProcessResult> result = Approval.process(lstApprovalRequest);
        }
        
        if(!setAdClaimStatusApproved.isEmpty()) {
            ApproveAdClaim.approveAdClaimRecord(new list<id>(setAdClaimStatusApproved));
        }
        
        if(!setAdClaimStatusReject.isEmpty()) {
            RejectAdClaim.rejectAdClaimRecord(new list<id>(setAdClaimStatusReject));
        }
    }
    
    //-----------------------------
    // @author: Mohit Modi
    // @date: 6 June 2018
    // @param: NA
    // @description:SFDC1-2020 : When Data Validated is marked true, Data Validation Completed By should be updated with current user.
    //----------------------------------
    public static void PopulateDataValidationCompletedBy(TriggerParameters tp) {
    
        Map<Id,AdClaim__c> mapOldAdClaim = (Map<Id,AdClaim__c>)tp.oldMap;
        AdClaim__c oldAdClaim = new AdClaim__c ();
        
        if (tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
            for(AdClaim__c newAdClaim: (list<AdClaim__c>)tp.newlist) {
                if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
                    oldAdClaim = mapOldAdClaim .get(newAdClaim.Id);
                }
                if(newAdClaim.DataValidated__c && oldAdClaim.DataValidated__c != newAdClaim.DataValidated__c) {
                    newAdClaim.DataValidationCompletedBy__c = userinfo.getuserid();
                }
            }
        }
        if (tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert) {
            for(AdClaim__c newAdClaim: (list<AdClaim__c>)tp.newlist) {
                if(newAdClaim.DataValidated__c) {
                    newAdClaim.DataValidationCompletedBy__c = userinfo.getuserid();
                }
            }
        }
    }
}