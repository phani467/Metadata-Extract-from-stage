//-----------------------------
// @author :  Ankita Singh
// @date : 11 April 2018
// @param: TriggerParameters
// @description: AfterUpdate dispatcher event handler class that calls the functions in DocuSignRecipientStatusMethod.
// @return: NA
//-----------------------------

public class DocuSignRecipentStatusAfterUpdateHandler extends TriggerHandlerBase {
    //-----------------------------
    // @author: Ankita Singh
    // @date: 11 April 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7213 : When a customer signs a Contract in docusign,the Contract Status should automatically be updated 
    //                            to "Signed by Customer".
    // @return: None
    //------------------------------ 
    public override void mainEntry(TriggerParameters tp) {
        dsfsDocuSignRecipientStatusMethods.changeContractStatus(tp);
    }
}