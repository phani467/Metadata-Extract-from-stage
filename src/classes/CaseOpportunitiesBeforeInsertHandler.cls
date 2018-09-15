/**
* @author: Vishnu vardhan Chowdary Andra
* @date: 25 September 2017
* @description: SFDC1-593. Before Insert dispatcher event handler class that calls the functions in CaseOpportunitiesMethods.
* @companyname: VERTIBA
*/
public class CaseOpportunitiesBeforeInsertHandler extends TriggerHandlerBase {
    /** 
	* @author: Vishnu vardhan Chowdary Andra
	* @date: 25 September 2017
	* @description: SFDC1-593. Handler class called by the trigger framework to carry out the specific actions on
	*		CaseOpportunities object before insert
	* @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
	* @companyname: VERTIBA
	* @return: void
	*/
	public override void mainEntry(TriggerParameters tp) {
	    CaseOpportunitiesMethods.validateIfCaseOpportunityAlreadyExist(tp);
	}
}