//-----------------------------
// @author: Anjani Shukla
// @date: 29 Sept 2017
// @param: NA
// @description: Class to hold trigger methods 
// @return: NA
//-----------------------------
public class ChangeLogMethods {


    //-----------------------------
    // @author: Anjani Shukla
    // @date: 29 Sept 2017
    // @param: TriggerParameters tp
    // @description: Update Start Date or Negotiated Date if differs.
    // @return: None
    //------------------------------
    public static void notificationEmail(TriggerParameters tp) {
        list<changelog__c> c = (list<changelog__c>)tp.newList;    
        for(changelog__c cl : c) {
            if (cl.wrstatus__c == 'Approved') {
                c.add(cl);
        
            }
        }    

    //SendEmail.sendMail(c);
    }
}