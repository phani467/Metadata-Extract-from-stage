//-----------------------------
// @author: Mohit Modi
// @date: 18 June 2018
// @param: NA
// @description: Class to hold trigger methods related to Channel Program Contact 
//----------------------------------
public class ChannelProgramContactMethods {

    //-----------------------------
    // @author: Mohit Modi
    // @date: 18 June 2018
    // @param: NA
    // @description: For the Channel Partner Community, Converted Process builder 'Channel Program Contact - General Automation' to a trigger
    //----------------------------------
    public static void ChannelProgramContactGeneralAutomation(TriggerParameters tp) {
        
        Map<Id,ChannelProgramContact__c> mapOldChannelProgramContact = (Map<Id,ChannelProgramContact__c>)tp.oldMap;
        ChannelProgramContact__c oldChannelProgramContact = new ChannelProgramContact__c ();
        set<id> setUserId = new set<id>();
        map<id, User> mapIdUser = new map <id,User>();
        map<id,ChannelProgramContact__c> mapChannelProgramContacttobeUpdated = new map<id,ChannelProgramContact__c>();
        
        // For the Update Operation and if Salesforce User has been changed on Channel Program Contact
        if (tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
            for(ChannelProgramContact__c newChannelProgramContact: (list<ChannelProgramContact__c>)tp.newlist) {
                if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
                    oldChannelProgramContact = mapOldChannelProgramContact.get(newChannelProgramContact.Id);
                }
                if(newChannelProgramContact.SalesforceUser__c != NULL && oldChannelProgramContact.SalesforceUser__c != newChannelProgramContact.SalesforceUser__c ) {
                    setUserId.add(newChannelProgramContact.SalesforceUser__c);
                    mapChannelProgramContacttobeUpdated.put(newChannelProgramContact.id,newChannelProgramContact);
                }
            }
        }
        // For the Insert Operation and if Salesforce User has been inserted on Channel Program Contact
        if (tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert) {
            for(ChannelProgramContact__c newChannelProgramContact: (list<ChannelProgramContact__c>)tp.newlist) {
                if(newChannelProgramContact.SalesforceUser__c != NULL ) {
                    setUserId.add(newChannelProgramContact.SalesforceUser__c);
                    mapChannelProgramContacttobeUpdated.put(newChannelProgramContact.id,newChannelProgramContact);
                }
            }
        }
        
        if(!setUserId.isEmpty()) {
            for(User uobj :[ select id, FullPhotoUrl,MediumPhotoUrl, SmallPhotoUrl from user where id IN : setUserId ]) {
                mapIdUser.put(uobj.id,uobj);
            }
        }
        
        if(!mapIdUser.isEmpty()) {
            for(ChannelProgramContact__c ChannelProgramContactobj :mapChannelProgramContacttobeUpdated.values()) {
                if(mapIdUser.containskey(ChannelProgramContactobj.SalesforceUser__c)) {
                    ChannelProgramContactobj.SystemMediumPhotoURL__c = mapIdUser.get(ChannelProgramContactobj.SalesforceUser__c).MediumPhotoUrl;
                    ChannelProgramContactobj.SystemFullPhotoURL__c = mapIdUser.get(ChannelProgramContactobj.SalesforceUser__c).FullPhotoUrl;
                    ChannelProgramContactobj.SystemSmallPhotoURL__c = mapIdUser.get(ChannelProgramContactobj.SalesforceUser__c).SmallPhotoUrl ;
                }
            }
        }
    }
}