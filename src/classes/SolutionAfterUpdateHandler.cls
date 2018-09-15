//-----------------------------
// @author: Harshit Singhal
// @date: 11 Aug 2018
// @param: TriggerParameters
// @description: SFDC1-9773 AfterUpdate dispatcher event handler class that calls the functions in SolutionMethods.
// @return: NA
//-----------------------------
public class SolutionAfterUpdateHandler extends TriggerHandlerBase {
	public override void mainEntry(TriggerParameters tp) {        
        SolutionMethods.populateTopLevelCategory(tp);
    }
}