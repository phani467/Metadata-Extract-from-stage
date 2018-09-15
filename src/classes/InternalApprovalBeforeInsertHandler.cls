//-----------------------------
// @author: Jagadesh Kumar
// @date: 06 Jun 2018
// @param: TriggerParameters
// @description:  Dispatcher event handler class that calls the functions in InternalApprovalMethods.
// @return: NA
//-----------------------------
public class InternalApprovalBeforeInsertHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
        
    	InternalApprovalMethods.populateContractOwner(tp);
        
    }
    
}