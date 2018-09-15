//***************************************
// @author Harshit Singhal
// @date 15th Jun 2018
// @description SFDC1-8541 BeforeUpdate dispatcher event handler class that calls the functions in EventMethods.
//***************************************
public class EventBeforeUpdateHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {        
        EventMethods.setActivityTypeFromType(tp);        
    }
}