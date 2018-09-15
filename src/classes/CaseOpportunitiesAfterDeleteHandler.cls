/**
* @author: Vishnu vardhan Chowdary Andra
* @date: 23 August 2017
* @description: SFDC1-593. After delete dispatcher event handler class that calls the functions in CaseOpportunitiesMethods.
* @companyname: VERTIBA
*/
public class CaseOpportunitiesAfterDeleteHandler extends TriggerHandlerBase {
    /** 
	* @author: Vishnu vardhan Chowdary Andra
	* @date: 23 August 2017
	* @description: SFDC1-593. Handler class called by the trigger framework to carry out the specific actions on
	*		CaseOpporunities object after delete
	* @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
	* @companyname: VERTIBA
	* @return: void
	*/
	public override void mainEntry(TriggerParameters tp) {
	    CaseOpportunitiesMethods.updateRollupSummariesInCase(tp);
	}
}