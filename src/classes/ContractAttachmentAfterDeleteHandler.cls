//-----------------------------
// @author: Ankita Singh
// @date: 18 June 2018
// @param: TriggerParameters
// @description:  AfterDelete dispatcher event handler class that calls the functions in ContractAttachmentMethods.
// @return: NA
//-----------------------------
public class ContractAttachmentAfterDeleteHandler extends TriggerHandlerBase {    
    public override void mainEntry(TriggerParameters tp) {
       ContractAttachmentMethods.updateFieldOnContract(tp);   
    }
}