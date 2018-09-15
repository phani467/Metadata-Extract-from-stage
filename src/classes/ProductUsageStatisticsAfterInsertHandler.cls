//-----------------------------
// @author: Jagadesh Kumar
// @date: 30 May 2018
// @param: TriggerParameters
// @description:  AfterInsert dispatcher event handler class that calls the functions in ProductUsageStatisticsMethods.
// @return: NA
// @Added reason : SFDC1-7109 Contact Creation based on Product Usage
//-----------------------------
public class ProductUsageStatisticsAfterInsertHandler extends TriggerHandlerBase {

    public override void mainEntry(TriggerParameters tp) {
    	ProductUsageStatisticsMethods.productUserContactCreation(tp);
    }
    
}