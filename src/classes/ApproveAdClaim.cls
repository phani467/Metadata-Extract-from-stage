/**
*@author: Prachi Bhasin
*@date: 31- Jul- 2017
*@description: SFDC1-366 This class is used to approve or reject Ad claim record.
*@companyname : VERTIBA 
**/
global class ApproveAdClaim {

    //-----------------------------
    //@author: Prachi Bhasin
    //@date: 31- Jul- 2017
    //@param: List of ID of the record which needs ot be approved
    //@description: SFDC1-366 This class is used to approve Ad claim record.
    //@return: void
    //@companyname : VERTIBA 
    //-----------------------------
    @InvocableMethod
    global static void approveAdClaimRecord(List<Id> recordId) {

    Set<Id> pIds = (new Map<Id, ProcessInstance>([SELECT Id,Status,TargetObjectId FROM ProcessInstance where Status='Pending' and TargetObjectId IN :recordId])).keySet();
    Set<Id> pInstanceWorkitems = (new Map<Id, ProcessInstanceWorkitem>([SELECT Id,ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId in :pIds])).keySet();
    try {
        for (Id pInstanceWorkitemsId:pInstanceWorkitems) {
            system.debug(pInstanceWorkitemsId);
                Approval.ProcessWorkitemRequest req1 = new Approval.ProcessWorkitemRequest();
                req1.setComments('Approved By '+ UserInfo.getName());            
                req1.setAction('Approve');           
    
                // Use the ID from the newly created item to specify the item to be worked
                req1.setWorkitemId(pInstanceWorkitemsId);
    
                // Approve the record
                Approval.ProcessResult result1 =  Approval.process(req1);
            }
    }
    catch(Exception e) {
            //this will happen if any exception apart from DML exception has occurred
            UtilityClass.createApexLogRecord(e, 'ApproveAdClaim', 'approveAdClaimRecord');       
        }

    }

}