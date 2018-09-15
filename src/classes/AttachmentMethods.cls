//-----------------------------
// @author: Uttam Arya
// @date: 29 Aug 2017
// @param: NA
// @description: SFDC1-2243 Class to hold Attachment trigger methods 
// @return: NA
//-----------------------------
public class AttachmentMethods {

//-----------------------------
// @author: Uttam Arya
// @date: 22 Aug 2017
// @param: TriggerParameters tp
// @description: SFDC1-2243 Whenever an Attachment is added to an opportunity,  
//                  MISAttachmentAdded field is auto populated with the current timestamp. 
//                  This is used for MIS pipeline reporting.
//
// @return: None
// @Modifiedby: Mohit Modi
// @Modified Description: 06 Nov 2017 : Added the logic to capture the attahment added on Opportunity Attachment as well.
//------------------------------
    public static void populateAttachmentAddedInOpportunityWhenAttachmentIsInserted(TriggerParameters tp) {
    
        //List of Opportunity that needs to be updated    
        List <Opportunity > OpportunityToUpdate = new List <Opportunity>(); 
        set<id> setOpportunityAttId = new set<id>();
        
        String OppAttachmentkeyPrefix = UtilityClass.getObjectKeyPrefix('OpportunityAttachment__c');
        set<id> setOpportunityId = new set<id>();
        
        for(Attachment attachment: (List <Attachment>) tp.newList) {
            if(attachment.ParentId != null && String.valueOf(attachment.ParentId).startsWith('006')) {
               setOpportunityId.add(attachment.ParentId);
            }
            // Checking if attachment is added to Opportunity Attachment Record.
            if(attachment.ParentId != null && OppAttachmentkeyPrefix != NULL && String.valueOf(attachment.ParentId).startsWith(OppAttachmentkeyPrefix)) {
                setOpportunityAttId.add(attachment.ParentId);
                
            }
        }
        
        if(!setOpportunityAttId.isEmpty()) {
            for(OpportunityAttachment__c tempOppAttach : [select id,Opportunity__c from OpportunityAttachment__c where id in : setOpportunityAttId]) {
                setOpportunityId.add(tempOppAttach.Opportunity__c);
            }
        }
        
        for(id oppid : setOpportunityId) {
            OpportunityToUpdate.add(new Opportunity(Id = oppid , MISAttachmentAdded__c = Datetime.now()));
        }
        
        //update if list has any records
        if(OpportunityToUpdate != null && OpportunityToUpdate.size() > 0) {
            update OpportunityToUpdate;
        }
    }
}