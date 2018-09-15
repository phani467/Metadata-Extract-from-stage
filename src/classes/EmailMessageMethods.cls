//-------------------------------------
//@author: Sruti Srivastava
//@date: 25 June 2018
//@description: SFDC1-1346,SFDC1-8538- When case is closed and email is received, case is reopened and case assignment rules runs.
//              SFDC1-3758, SFDC1-8151, SFDC1-8538 -When a case is in status Waiting*, it should be updated to "In progress"
//@companyname: VERTIBA
//-------------------------------------

public class EmailMessageMethods {
    
    //-------------------------------------
    // @author: Sruti Srivastava
    // @date: 25 June 2018
    // @param: Trigger parameters
    // @description: SFDC1-1346: Collects closed case objects. Change the status to reopen
    //      set to run assignment rules
    //      SFDC1-3758, SFDC1-8151, SFDC1-8538: Updates cases with "Waiting" status to In progress
    // @LastModifieldBy: Vishnu 
    // @LastModifieldDate: 01 Aug 2018
    // @LastModifieldDescription: SFDC1-9428, If case has previous queue, then it has to be owner, when case 
    // 		is reopened. If previous queue is empty then run case assignment rules. If still user is a case owner
    // 		then assign it to FM Customer Care
    // @return: void
    //-------------------------------------
    public static void updateCaseStatusAndReExecuteCaseAssignmentRules(TriggerParameters tp) {
        Set<Id> setClosedCaseIds = new Set<Id>();
        Set<string> previousQueueNames = new Set<String>();
        Map<Id, EmailMessage> mapNewEmailMessage = (Map<Id, EmailMessage>)tp.newMap;
        Map<Id, Id> mapEmailMessageToCaseId = new Map<Id, Id>();
        Map<Id, Case> mapCaseToUpdate = new Map<Id, Case>();
        Map<Id, Case> mapAllParentCases = new Map<Id, Case>();
        try {
            //Storing related case Ids
            for(EmailMessage objEmailMessage : mapNewEmailMessage.values()) {
                if(objEmailMessage.ParentId != null && 
                    String.valueOf(objEmailMessage.ParentId.getSobjectType()).equalsIgnoreCase('Case')) {
                    mapEmailMessageToCaseId.put(objEmailMessage.Id, objEmailMessage.ParentId);
                }
            }
            
            if(!mapEmailMessageToCaseId.isEmpty()) {
                //Finding cases with status starting with "Waiting" and "Closed"
                mapAllParentCases = new Map<Id, Case>([Select Id, status, isClosed, recordType.Name, PreviousQueue__c From Case 
                                                       where Id IN: mapEmailMessageToCaseId.values() ]);
                
                for(EmailMessage objEmailMessage : mapNewEmailMessage.values()) {
                    
                    if(mapEmailMessageToCaseId.containsKey(objEmailMessage.Id)) {
                        
                        Case objCase  = mapAllParentCases.get(objEmailMessage.ParentId);
                        if(objCase.isClosed && objEmailMessage.Incoming) { 
                            setClosedCaseIds.add(objEmailMessage.ParentId); //Closed Case ids 
                            if(String.isNotBlank(objCase.PreviousQueue__c)) {
                                previousQueueNames.add(objCase.PreviousQueue__c);
                            }
                        }
                        else if(!string.isBlank(objCase.status) &&  objCase.status.containsIgnoreCase('waiting')) {
                            mapCaseToUpdate.put(objEmailMessage.ParentId, new Case(Id = objEmailMessage.ParentId, Status = 'In Progress'));
                        }
                    }
                }
            }
            //Fetching the assignment rules on case
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.useDefaultRule = true;
            
            previousQueueNames.add('FM | Customer Care');
            Map<String, Id> queueNameIdMap = new Map<String, Id>();
            //Updating status to 'Re-opened'
            if(!setClosedCaseIds.isEmpty()) {

                List<Group> listGroup = [Select Id, Name From Group where Type = 'Queue' and 
                                               Name in :previousQueueNames];
                for(Group queue : listGroup) {
                    queueNameIdMap.put(queue.Name, queue.Id);
                }
                for(Id objCaseId : setClosedCaseIds) {
                    Case objCase = mapAllParentCases.get(objCaseId);
                    objCase.Status = 'Re-opened';
                    Id queue = queueNameIdMap.get(objCase.PreviousQueue__c);
                    //If there exists previous queue assign it as owner
                    //Else run Case assignment rules and still we have owner, then assign FM Customer Care
                    if(String.isNotBlank(queue)) {
                        objCase.OwnerId = queue;
                    } else {
                        objCase.setOptions(dmlOpts);
                    }
                    mapCaseToUpdate.put(objCaseId, objCase);
                }
            }
            //Updatng cases
            if(!mapCaseToUpdate.isEmpty()) {
                update mapCaseToUpdate.values();
            }
            
            if(!setClosedCaseIds.isEmpty()) {
                //if the owner is still user, then set the owner as FM | Customer Care and update.
                Map<Id, Case> mapCases = new Map<Id, Case>([select Id, ownerId, Owner.Type from Case where Id In :setClosedCaseIds 
                                        AND Owner.Type like 'User']);
                
                //This implies either case assignment rule didn't work or 
                //A default case owner is assigned. Now assign to the customer care queue
                if(mapCases  != null && !mapCases.isEmpty()) {
                    Id customerCareQueueId = queueNameIdMap.get('FM | Customer Care');
                    if(customerCareQueueId == null) {
                        return;//In case queue name is changed.
                    }
                    else {
                        mapCaseToUpdate = new Map<Id, Case>();
                        
                        for(Case objCase : mapCases.values()) {
                            objCase.ownerId = customerCareQueueId;
                            mapCaseToUpdate.put(objCase.Id, objCase);
                        }
                        //Updating cases
                        if(!mapCaseToUpdate.isEmpty()) {
                            update mapCaseToUpdate.values();
                        }
                    }
                }
            }
        } 
        catch (Exception e) {
            UtilityClass.createApexLogRecord(e,'EmailMessageMethods','updateCaseStatusAndReExecuteCaseAssignmentRules');
        }
    }
}