//-----------------------------
// @author: Harshit Singhal
// @date: 22 Jun 2018
// @description: SFDC1-8533 AfterInsert dispatcher event handler class that calls the functions in ContractMethods
//-----------------------------
public class ContractAfterInsertHandler extends TriggerHandlerBase {
    
    //-----------------------------
    // @author: Harshit Singhal
    // @date: 22 Jun 2018
    // @description: SFDC1-8533. Handler class called by the trigger framework to carry out the specific actions on
    //    			Contract object after insert.
    // @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got inserted.        
    // @return: None
    //-----------------------------
    public override void mainEntry(TriggerParameters tp) {        
        ContractMethods.updateOpptyContractStartEndDates(tp);        
    }
}