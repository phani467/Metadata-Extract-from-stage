//-----------------------------
// @author :  Ankita Singh
// @date : 11 April 2018
// @param: TriggerParameters
// @description: AfterInsert dispatcher event handler class that calls the functions in DocuSignRecipientStatusMethod.
// @return: NA
//-----------------------------

public class DocuSignRecipentStatusAfterInsertHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        dsfsDocuSignRecipientStatusMethods.changeContractStatus(tp);
        dsfsDocuSignRecipientStatusMethods.updateContractAttachmentType(tp);
    }
}