/**
*@author: Mohit Modi
*@date: 02- Aug- 2017
*@description: SFDC1-460 This class is used to approve or reject Ad claim Change log record.
*@companyname : VERTIBA 
**/
global class ApproveOrRejectAdClaimChangeLog {

    //-----------------------------
    //@author: Mohit Modi
    //@date: 02- Aug- 2017
    //@param: List of ID of the record which needs ot be approved or Rejected and Status Field in form of Wrapper Object
    //@description: SFDC1-460 This class is used to approve or Reject Ad claim Change log record.
    //@return: void
    //@companyname : VERTIBA 
    //-----------------------------
    @InvocableMethod
    global static void ApproveOrRejectAdClaimChangelogRecord(List<ApprovalRequestStatus> AdclaimchangeLogWrapper) {

    map<id,string> mapAdclaimChangelogIdStatus = new map<id,string>();
    
    for(ApprovalRequestStatus tempObj : AdclaimchangeLogWrapper)
    {
        String StatusVal = tempObj.Status == 'Approved' ? 'Approve' : tempObj.Status == 'Rejected' ? 'Reject' : '';
        mapAdclaimChangelogIdStatus.put(tempObj.AdclaimChangeLogID,StatusVal);
    }
    
    Map<Id, ProcessInstance> mapProcessInstanceIdProcessInstance = new Map<Id, ProcessInstance>([SELECT Id,Status,TargetObjectId FROM ProcessInstance where Status='Pending' and TargetObjectId IN :mapAdclaimChangelogIdStatus.keyset()]);
    Map<Id, ProcessInstanceWorkitem> mappInstanceWorkitems = new Map<Id, ProcessInstanceWorkitem>([SELECT Id,ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId in :mapProcessInstanceIdProcessInstance.keyset()]);

    for (Id pInstanceWorkitemsId:mappInstanceWorkitems.keyset()) {
        system.debug(pInstanceWorkitemsId);
            Approval.ProcessWorkitemRequest req1 = new Approval.ProcessWorkitemRequest();
            req1.setComments('Updated By '+ UserInfo.getName());            
            
            req1.setAction(mapAdclaimChangelogIdStatus.get(mapProcessInstanceIdProcessInstance.get(mappInstanceWorkitems.get(pInstanceWorkitemsId).ProcessInstanceId).TargetObjectId));

            // Use the ID from the newly created item to specify the item to be worked
            req1.setWorkitemId(pInstanceWorkitemsId);

            // Approve the record
            Approval.ProcessResult result1 =  Approval.process(req1);
        }

    }
    
    
    //-----------------------------
    //@author: Mohit Modi
    //@date: 02- Aug- 2017
    //@param: NA
    //@description: SFDC1-460 This class is used to Create Wrapper for Change log id and Status
    //@return: void
    //@companyname : VERTIBA 
    //-----------------------------
    global class ApprovalRequestStatus{
        @InvocableVariable(required=true)
        global ID AdclaimChangeLogID;
        
        @InvocableVariable(required=true)
        global String Status; 
    }

}