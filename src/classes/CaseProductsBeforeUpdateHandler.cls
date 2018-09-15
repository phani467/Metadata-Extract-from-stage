/**
* @author: Vishnu vardhan Chowdary Andra
* @date: 26 September 2017
* @description: SFDC1-593. Before Update dispatcher event handler class that calls the functions in CaseProductsMethods.
* @companyname: VERTIBA
*/
public class CaseProductsBeforeUpdateHandler extends TriggerHandlerBase {
    /** 
	* @author: Vishnu vardhan Chowdary Andra
	* @date: 26 September 2017
	* @description: SFDC1-593. Handler class called by the trigger framework to carry out the specific actions on
	*		CaseProducts object before Update
	* @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
	* @companyname: VERTIBA
	* @return: void
	* 
    * @author: Vishnu vardhan Chowdary Andra
    * @date: 23 April 2018
    * @description: SFDC1-7599. Adding validateForMandatoryValues and populateProductRelatedValues. 
	*/
	public override void mainEntry(TriggerParameters tp) {
        CaseProductsMethods.validateForMandatoryValues(tp);
	    CaseProductsMethods.validateIfCaseProductAlreadyExist(tp);
        CaseProductsMethods.populateProductRelatedValues(tp);
	}
}