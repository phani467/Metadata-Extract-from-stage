//-----------------------------
// @author: Mohit Modi
// @date: 16 April 2018
// @description: This Class will hold all the methods related to Billing Schedule Line Items.
// @return: None
//------------------------------
public class BillingScheduleLineItemMethods {

    //-----------------------------
    // @author: Mohit Modi
    // @date: 16 April 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7472 : This Method is used to create the Billing Schedule Line Item records based on the Contract line Item's Biiling Period Value. Called from After Insert and before Insert trigger.
    // @return: None
    //------------------------------
    public static void CreateCloneBillingScheduleLIFromCLIandPreventBSLICreation(TriggerParameters tp) {

        // List of new values
        list<BillingScheduleLineItem__c> listNewBillingScheduleLI = (List<BillingScheduleLineItem__c>)tp.newlist;
        // Map of Old values
        Map<Id,BillingScheduleLineItem__c> mapOldBillingScheduleLI = (Map<Id,BillingScheduleLineItem__c>)tp.oldMap;
        // Map of CLI Id and BillingScheduleLineItem
        Map<id,BillingScheduleLineItem__c> mapContractLIIdBillingScheduleLI = new Map<id,BillingScheduleLineItem__c>();
        // Map of CLI Id and Count of Billing Period on CLI, based on whcih BillingScheduleLineItem records will be created
        Map<id,Decimal> mapCLIIBillingPeriod = new Map<id,Decimal>();
        // Map of CLI Id and Count of Existing BillingScheduleLineItem records
        Map<id,Decimal> mapCLIIBillingScheduleLICount = new Map<id,Decimal>();
        
        if (tp.tEvent == TriggerParameters.TriggerEvent.afterInsert || tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert) {
            for(BillingScheduleLineItem__c bslObj : listNewBillingScheduleLI) {
                // This will be run only for the BillingScheduleLineItem created from quick action
                if(bslObj.IsCreatedfromQuickAction__c == true && bslObj.ContractLineItem__c != NULL) {
                    mapContractLIIdBillingScheduleLI.put(bslObj.ContractLineItem__c,bslObj);
                }   
            }
        }
        
        if(!mapContractLIIdBillingScheduleLI.isEmpty()) {
            //Query for the Count of BillingPeriods__c on CLI and to check the existing count of BillingScheduleLineItem records
            for(BillingScheduleLineItem__c bslObj : [select id,ContractLineItem__r.BillingPeriods__c, ContractLineItem__c,IsCreatedfromQuickAction__c from BillingScheduleLineItem__c where ContractLineItem__c in : mapContractLIIdBillingScheduleLI.keyset() ]) {
                // This map will hold the values of CLI and its BillingPeriods value
                mapCLIIBillingPeriod.put(bslObj.ContractLineItem__c,bslObj.ContractLineItem__r.BillingPeriods__c);
                
                //This map will hold the count of existing BillingScheduleLineItem records on CLI including the existing which is created from quick action.
                Decimal bslCount = 0;
                if(mapCLIIBillingScheduleLICount.containskey(bslObj.ContractLineItem__c)) {
                    bslCount = mapCLIIBillingScheduleLICount.get(bslObj.ContractLineItem__c);
                }
                mapCLIIBillingScheduleLICount.put(bslObj.ContractLineItem__c,bslCount+1);
            }
        }
        
        if(!mapCLIIBillingPeriod.isEmpty()) {
            
            // After Insert is to create the Addition BillingScheduleLineItem record from Billing Period on CLI using Clone
            if (tp.tEvent == TriggerParameters.TriggerEvent.afterInsert ) {
            
                try {
                List<BillingScheduleLineItem__c> listBillingScheduleLineItemtobeCreated = new List<BillingScheduleLineItem__c> ();
            
                for(Id cliId : mapCLIIBillingPeriod.keyset()) {
                    // Checking if Exiting record count of BillingScheduleLineItem is less then the BillingPeriods on CLI, if Yes, then create the remaining BillingScheduleLineItem records.
                    if(mapCLIIBillingPeriod.get(cliId) > mapCLIIBillingScheduleLICount.get(cliId)) {
                        Decimal remainingBSLI = mapCLIIBillingPeriod.get(cliId) - mapCLIIBillingScheduleLICount.get(cliId) ;
                        
                        for( integer i = 0 ; i < remainingBSLI ; i++) {
                            
                            BillingScheduleLineItem__c objBsliNew = new BillingScheduleLineItem__c();
                            // Object clone Parameters (preserveId, isDeepClone, preserveReadonlyTimestamps, preserveAutonumber)
                            objBsliNew = mapContractLIIdBillingScheduleLI.get(cliId).clone(false,false,false,false);
                            objBsliNew.id = null;
                            objBsliNew.IsCreatedfromQuickAction__c = false;
                            listBillingScheduleLineItemtobeCreated.add(objBsliNew);
                        }   
                    }
                }
                if(!listBillingScheduleLineItemtobeCreated.isEmpty())
                {
                    // Insert the newly Cloned records.
                    insert listBillingScheduleLineItemtobeCreated;
                }
                } catch (exception ex) {
                    ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c='BillingScheduleLineItemMethods',ErrorDescription__c=ex.getmessage(),FunctionName__c='CreateCloneBillingScheduleLIFromCLIandPreventBSLICreation');
                    insert apexLogRecord;     
                }
            }
            
            // Before Insert is to prevent the Addition BillingScheduleLineItem record creation from Billing Period on CLI
            if (tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert) {
                for(Id cliId : mapCLIIBillingPeriod.keyset()) {
                    // Checking if Exiting record count of BillingScheduleLineItem is greater than the BillingPeriods on CLI, if Yes, then show error.
                    if(mapCLIIBillingPeriod.get(cliId) <= mapCLIIBillingScheduleLICount.get(cliId)) {
                        mapContractLIIdBillingScheduleLI.get(cliId).addError(label.BSLIErrorOnQuickActionOnCLI);
                    }
                }
            }
        }
    }
}