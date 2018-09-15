//-----------------------------
// @author :  Tran-Vu Tran
// @date : 16 July 2018
// @param: TriggerParameters
// @description: BeforeInsert dispatcher event handler class that calls the functions in DocuSignStatusMethod.
// @return: NA
//-----------------------------

public class DocuSignStatusBeforeInsertHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
       
        dsfsDocuSignStatusMethods.createContractAttachment(tp);
        
    }
}