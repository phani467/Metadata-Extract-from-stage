//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: Class to hold Additional Case Fields trigger methods 
// @return: NA
//-----------------------------
public class AdditionalCaseFieldsMethods {

//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: TriggerParameters tp
// @description: When the product is selected the function create a Additional Case Fields with the 
//              recordtype of the product ContainsAdditionalFields__c is set in product table. 
//              This function populate the Additional Fields lookup in case. 
// @return: None
//------------------------------
    public static void populateAdditionalFiledsLookupInCase(TriggerParameters tp) {
    
        //List of Cases that needs to be updated    
        List <Case> casesToUpdate = new List <Case>(); 
        
        for(AdditionalCaseFields__c acf: (List <AdditionalCaseFields__c>) tp.newList) {
            if(acf.Case__c != null) {
                casesToUpdate.add(new Case(Id = acf.Case__c, AdditionalFields__c = acf.Id));
            }
        }
        
        //update if list has any records
        if(casesToUpdate != null && casesToUpdate.size() > 0) {
            update casesToUpdate;
        }
    }

    // @author: Vishnu vardhan Chowdary Andra
	// @date: 19 June 2018
	// @description: SFDC1-265: When delivery queue is changed in delivery record type additonal case, then update the 
    //		owner of case(parent) with the corresponding delivery queue. For each delivery queue pick list there is a 
    // 		corresponding queue (same name) created, to which case is assigned.
    // 		Earlier this was done as part of process builder, moving to code.
	// @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
	// @companyname: VERTIBA
	// @return: void
    public static void populateDeliveryQueuesInCase(TriggerParameters tp) {
        Map<Id,AdditionalCaseFields__c> mapNewACFCase = (Map<Id,AdditionalCaseFields__c>) tp.newMap;
        Map<Id,AdditionalCaseFields__c> mapOldACFCase = (Map<Id,AdditionalCaseFields__c>) tp.oldMap;
        Set<String> queueNames = new Set<String>();
        Id deliveryRecordTypeId = Schema.Sobjecttype.AdditionalCaseFields__c.getRecordTypeInfosByName(). get('Delivery').getRecordTypeId();
        List<AdditionalCaseFields__c> acfList = new List<AdditionalCaseFields__c>();
        System.debug('Entering populateDeliveryQueuesInCase');
        for(AdditionalCaseFields__c newACFCase: mapNewACFCase.values()) {
            AdditionalCaseFields__c oldACFCase = new AdditionalCaseFields__c();
            if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate){
                oldACFCase = mapOldACFCase.get(newACFCase.Id);
            }
            if(newACFCase.RecordTypeId == deliveryRecordTypeId 
               && newACFCase.DeliveryQueue__c != null
               && newACFCase.DeliveryQueue__c != oldACFCase.DeliveryQueue__c) {
                   //Collecting queue to fetch from Database.
                   queueNames.add(newACFCase.DeliveryQueue__c); 
                   acfList.add(newACFCase);
               }
        }
        System.debug('acfList to insert'+acfList);
        System.debug('queueNames to get'+queueNames);
        if(!queueNames.isEmpty()) {
            List<Case> caseList = new List<Case>();
            Map<String,Id> queueIdMap = new map<String,Id>();
            for(Group queue : [Select Name, Id From Group where Type = 'Queue' and name in :queueNames]) {
                queueIdMap.put(queue.Name, queue.id);
            }
            for(AdditionalCaseFields__c additionalCaseField : acfList) {
                case cas = new Case(Id = additionalCaseField.Case__c);
                cas.OwnerId = queueIdMap.get(additionalCaseField.DeliveryQueue__c);
                caseList.add(cas);
            }
            //Update case.
            if(!caseList.isEmpty()) {
                System.debug('cases to insert'+caseList);
                update caseList;
            }
        }
        System.debug('Exiting populateDeliveryQueuesInCase');
    }
}