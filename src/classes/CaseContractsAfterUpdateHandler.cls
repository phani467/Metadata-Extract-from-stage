/**
* @author: Vishnu vardhan Chowdary Andra
* @date: 23 August 2017
* @description: SFDC1-593. After update dispatcher event handler class that calls the functions in CaseContractsMethods.
* @companyname: VERTIBA
*/
public class CaseContractsAfterUpdateHandler extends TriggerHandlerBase {
    /** 
	* @author: Vishnu vardhan Chowdary Andra
	* @date: 23 August 2017
	* @description: SFDC1-593. Handler class called by the trigger framework to carry out the specific actions on
	*		CaseContracts object after update
	* @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
	* @companyname: VERTIBA
	* @return: void
	*/
	public override void mainEntry(TriggerParameters tp) {
	    CaseContractsMethods.updateRollupSummariesInCase(tp);
	}
}