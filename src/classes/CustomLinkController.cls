//-----------------------------
// @author: Vinod Merwade
// @date: 3 Nov 2017
// @description:  SFDC1-5622 Custom Links, to have a list of useful links on lightning home page.
// @return: NA
// @Company: Vertiba
//-----------------------------
public without sharing  class CustomLinkController {
  
//-----------------------------
// @author: Vinod Merwade
// @date: 3 Nov 2017
// @description:  Method to check logged in user is System Admin
// @return: Boolean
// @Company: Vertiba
//-----------------------------
/* //admin check is not required as functionality is desired for all the users
    @AuraEnabled
    public static boolean checkUserIsAdmin() {
        system.debug('Admin Test'+UserInfo.getUserName());
        Id profileId = userInfo.getProfileId();
        system.debug('profileId----'+profileId);
        List<Profile> p = [select id, name from Profile where id=:profileId and name='System Administrator'];
        if(!p.isempty()) {
            system.debug('true');
            return true;
        }
        else {
            system.debug('false');
            return false;
        }
    }
*/
 //-----------------------------
// @author: Vinod Merwade
// @date: 3 Nov 2017
// @description:  SFDC1-5622 Custom Links, to have a list of useful links on lightning home page.
// @return: List of Custom Links
// @Company: Vertiba
//-----------------------------
    @AuraEnabled
    public static list<customLink__c> loadCustomLinks() {
        system.debug('custom Links');
        List<customLink__c> cl = [select CustomLinkName__c,url__c from customLink__c where active__c = true 
                                  order by CustomLinkName__c asc];
        system.debug('custom Links'+cl);
        return cl;
    }
    
}