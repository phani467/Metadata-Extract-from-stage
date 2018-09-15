/**
*@author: Hemant Shukla
*@date: 20-Oct-2017
*@description: SFDC1-5421, This class is used to update Originating contarct of Renewal Opportunity when stage changed to 6w - Renewal one
*@companyname : VERTIBA 
**/
global class UpdateActiveContractOnRenewalOpp6W {
    
    //-----------------------------
    //@author: Hemant Shukla
    //@date: 20-Oct-2017
    //@param: List of ID of the Opportunity, which will trigger this class. Will be passed from process builder 
    //@description: SFDC1-5421, This class is used to update Originating contarct of Renewal Opportunity when stage changed to 6w - Renewal one
    //@return: void
    //@companyname : VERTIBA 
    //-----------------------------
    @InvocableMethod(label='Update Originating Contract' 
                    description='update Originating contarct of Renewal Opportunity when stage changed to 6w - Renewal one') 
    global static void updateOriginatingContract(List<Id> oppIds) {
        
        //Set the process builder flag to true once its fired. Used for Test class
        GlobalConstants.hasUpdateActiveContractOnRenewalOpp6WProcessFired = true; 
        
        Id orderFormRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Order Form').getRecordTypeId();
        
        List<Contract> originatingContracts = new List<Contract>();
        
        For(Opportunity opp : [Select Id, ContractBeingRenewed__c, (Select Id from Contracts__r where RecordTypeId = :orderFormRecordTypeId limit 1) 
                             From Opportunity 
                             where Id In:oppIds]){
                                 
            if(!opp.Contracts__r.isEmpty()){
                originatingContracts.add(new Contract(Id = opp.ContractBeingRenewed__c,ReplacementContract__c = opp.Contracts__r[0].Id));               
            }     
        }
        
        try{
            update originatingContracts;
        }
        catch(Exception e){
            system.debug('----------------exception message' + e.getMessage());
        }
        
    }    

}