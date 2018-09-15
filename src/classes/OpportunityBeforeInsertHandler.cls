//-----------------------------
// @author Prachi Bhasin
// @date 4 July 2017
// @param: TriggerParameters
// @description:  BeforeInsert dispatcher event handler class that calls the functions in OpportunityMethods.
// @return: NA
//-----------------------------
public class OpportunityBeforeInsertHandler extends TriggerHandlerBase{
    
    /** 
    * @author: Vishnu vardhan Chowdary Andra
    * @date: 13 September 2017
    * @description: Calls the opportunity methods before insert
    * @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
    * @companyname: VERTIBA
    * @return: void
    */
    public override void mainEntry(TriggerParameters tp) {
        OpportunityMethods.populateExternalSourceSystemOnOpportunity(tp); 
        OpportunityMethods.updateGAMOnOpportunityCreation(tp);
        OpportunityMethods.copyBilltoShiptoFromOriginatingContractToRenewalOpportunity(tp);
    }
}