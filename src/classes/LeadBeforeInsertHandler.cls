/**
* @author : Mohit Modi
* @date : 3 Nov 2017
* @description : SFDC1-1081 Before insert handler for Lead trigger, SFDC1-192 - Moved to Before Events
* @companyname : Vertiba
*/

public class LeadBeforeInsertHandler extends TriggerHandlerBase {
    public override void mainEntry(TriggerParameters tp) {
        LeadMethods.updateCountryLookup(tp);
		LeadMethods.updatetoNewLeadSourcefield(tp);
    }
}