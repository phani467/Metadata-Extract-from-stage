//-----------------------------
// @author: Ankita Singh
// @date: 18 June 2018
// @param: TriggerParameters
// @description:  AfterInsert dispatcher event handler class that calls the functions in ContractAttachmentMethods.
// @return: NA
//-----------------------------
public class ContractAttachmentAfterInsertHandler extends TriggerHandlerBase {
    
  public override void mainEntry(TriggerParameters tp) {
    ContractAttachmentMethods.updateFieldOnContract(tp);

  }
}