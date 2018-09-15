//***************************************
// @author : Mohit Modi
// @date : 18 June 2018
// @description : For the Channel Partner Community, Converted Process builder 'Channel Program Contact - General Automation' to a trigger
//***************************************
public class ChannelProgramContactbeforeInsertHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        ChannelProgramContactMethods.ChannelProgramContactGeneralAutomation(tp);
    }
}