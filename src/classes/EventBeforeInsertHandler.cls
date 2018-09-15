//***************************************
// @author Harshit Singhal
// @date 15th Jun 2018
// @description SFDC1-8541 BeforeInsert dispatcher event handler class that calls the functions in EventMethods.
//***************************************
public class EventBeforeInsertHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {        
        EventMethods.setActivityTypeFromType(tp);        
    }
}