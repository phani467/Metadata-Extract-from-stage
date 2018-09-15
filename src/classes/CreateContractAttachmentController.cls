/**
* @author Uttam Arya
* @date: 18th Sep 2017 
* @description : SFDC1-2392 Controller class for Contract Attachment Aura Component
* @company : IHS Markit
*/
public class CreateContractAttachmentController {
	@AuraEnabled
    public static String getRecordTypeId(Id parentId){
        
        Contract c = [Select Id, RecordtypeId, Recordtype.Name from Contract where Id = :parentId];
        Schema.RecordTypeInfo contractAttachmentRT = Schema.SObjectType.ContractAttachment__c.getRecordTypeInfosByName().get(c.Recordtype.Name);
        
        if(contractAttachmentRT != null){
            return contractAttachmentRT.getRecordTypeId(); 
        }
        return null;
    }
}