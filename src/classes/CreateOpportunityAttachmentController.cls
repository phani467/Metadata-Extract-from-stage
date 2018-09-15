/**
* @author: Uttam Arya
* @date: 18th Sep 2017 
* @description: SFDC1-5493 Controller class for Opportunity Attachment Aura Component
* @company: IHS Markit
*/
public class CreateOpportunityAttachmentController {
	@AuraEnabled
    public static String getRecordTypeId(Id parentId){
        
        Opportunity c = [Select Id, RecordtypeId, Recordtype.Name from Opportunity where Id = :parentId];
        Schema.RecordTypeInfo opportunityAttachmentRT = Schema.SObjectType.OpportunityAttachment__c.getRecordTypeInfosByName().get(c.Recordtype.Name);
        
        if(opportunityAttachmentRT != null){
            return opportunityAttachmentRT.getRecordTypeId(); 
        }
        return null;
    }
}