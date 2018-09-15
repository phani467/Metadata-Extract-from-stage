//-----------------------------
// @author: Uttam Arya
// @date: 29th Aug 2017
// @param: TriggerParameters
// @description: SFDC1-2243 AfterInsert dispatcher event handler class that calls the functions in AttachmentMethods.
// @return: NA
//-----------------------------
public class AttachmentAfterInsertHandler extends TriggerHandlerBase {
    
  public override void mainEntry(TriggerParameters tp) {
    AttachmentMethods.populateAttachmentAddedInOpportunityWhenAttachmentIsInserted(tp);
    // AttachmentMethods.populateAttachmentInContractAttachment(tp);
  }

}