/**
* @author: Ankita Singh
* @date: 18 June 2018
* @description: SFDC1-8559. After insert and After delete dispatcher event handler class that calls the functions in ContractAttachmentMethods.
* @companyname: VERTIBA
*/

public class ContractAttachmentMethods {
    
    //-----------------------------
    // @author: Ankita Singh
    // @date: 18 June 2018
    // @description: SFDC1-8559- Once the salesperson attaches the PO in custom attachments - and chooses the type 
    // 				"Purchase Order" then a trigger will update  yes/no on field called "PO Attached" on the Contract and OM case
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got updated.
    // @companyname: VERTIBA
    //-----------------------------
    public static void updateFieldOnContract(TriggerParameters tp) {     
        if(tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {            
            try {
                Set<Id> contractIds = new Set<Id>();
                Boolean isChanged = FALSE;
                List<Contract> contractList = new List<Contract>();
                for(ContractAttachment__c c :(List<ContractAttachment__c>) tp.newList) {
                    if(c.AttachmentType__c == 'Purchase Order') {
                        // collecting associated contract id
                        contractIds.add(c.Contract__c); 
                    }
                }
                if(contractIds != null && contractIds.size() > 0) {
                    // fetching contract PO Attached Info for newly added attachment
                    Map<Id,Contract> contractMap = new Map<Id,Contract>([Select Id,POAttached__c from Contract where Id In:contractIds AND recordtype.Name='Order Form' AND POAttached__c !='Yes']);
                    if(contractMap != null && contractMap.size() > 0) {
                        for(Id c : contractMap.keySet()) {
                            // setting PO Attached to Yes since they have new attachment added
                            contractMap.get(c).POAttached__c = 'Yes';
                            isChanged = TRUE;       
                        }
                        if(isChanged == TRUE) {
                            update contractMap.values();    
                        }
                    }
                }   
            } catch (Exception e) {
                UtilityClass.createApexLogRecord(e,'ContractAttachmentMethods','updateFieldOnContract'); 
            }     
        }
        if(tp.tEvent == TriggerParameters.TriggerEvent.afterDelete) {   
            try {
                Set<Id> contractIds = new Set<Id>();
                Map<Id,ContractAttachment__c> mapOldContract =  (Map<Id,ContractAttachment__c>)tp.oldMap;
                List<Contract> contractList = new List<Contract>();
                for(ContractAttachment__c c : mapOldContract.values()) {
                    if(c.AttachmentType__c == 'Purchase Order') {
                        // collecting associated contract id
                        contractIds.add(c.Contract__c); 
                    }
                }
                if(contractIds != null && contractIds.size() > 0) {
                    // fetching contract PO Attached Info for deleted attachment
                    List<Contract> contractAttachmentList = [Select Id,POAttached__c,(Select Id from ContractAttachments__r where AttachmentType__c = 'Purchase Order' ) from Contract where Id In:contractIds AND recordtype.Name='Order Form'];
                    if(contractAttachmentList != null && contractAttachmentList.size() > 0) {
                        for(Contract c : contractAttachmentList) {
                            if(c.ContractAttachments__r == null || c.ContractAttachments__r.size() == 0) {
                                // updating the field PO Attachment to no since they dont have any assciated attachment
                                c.POAttached__c = 'No';
                                contractList.add(c);
                            }
                        }
                        if(contractList != null && contractList.size()>0) {
                            update contractList;
                        }
                    }
                }   
            } catch (Exception e) {
                UtilityClass.createApexLogRecord(e,'ContractAttachmentMethods','updateFieldOnContract'); 
            }     
        } 
        
    }
}