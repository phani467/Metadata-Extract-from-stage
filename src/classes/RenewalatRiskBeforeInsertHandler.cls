//***************************************
// @author Harshit Singhal
// @date 19 Jun 2018
// @description SFDC1-8545 BeforeInsert dispatcher event handler class that calls the functions in RenewalatRiskMethods class.
//***************************************
public class RenewalatRiskBeforeInsertHandler extends TriggerHandlerBase {
	
    public override void mainEntry(TriggerParameters tp) {        
        RenewalatRiskMethods.setRiskCustomerContactinOppatRisk(tp);        
    }
}