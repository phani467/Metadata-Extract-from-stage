//-----------------------------
// @author: Tran-Vu Tran
// @date: 24 April 2018
// @param: NA
// @description: Class to hold User Account trigger methods 
// @return: NA
//-----------------------------

public class UserMethods {

    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 24 April 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-808 Whenever an User record is created, 
    //              this function populates the User's Region field from Address' Country picklist.
    // @return: None
    //------------------------------
    public static void updateUserRegionWhenAddressCountryChanges(TriggerParameters tp) {
        
        try {
            // Map of old values and new values
            List<User> listNewUsers = (List<User>) tp.NewList;
            Map<Id, User> mapOldUsers = (Map<Id, User>) tp.oldMap;

            if (tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert || 
                tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
                
                for (User newUser : listNewUsers) {

                    User oldUser = null;
                    
                    if (tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
                        oldUser = mapOldUsers.get(newUser.Id);
                    }

                    if (oldUser == null // this is a new inserted record
                        || (oldUser != null && // for updating an existing user
                            (oldUser.CountryCode != newUser.CountryCode // Country picklist value changed
                             || (oldUser.CountryCode != null && oldUser.UserRegion__c == null))) // or Country was populated but User Region was not
                       ) {
                        
                        // update Region field
                        Country__c country = UtilityClass.getCountryByIsoCode(newUser.CountryCode);
                           
                        if (country != null) {
                            newUser.UserRegion__c = country.Region__c;
                        }
                    }
                }
            }
            
        } catch(Exception ex) {
            //this will happen if any exception apart from DML exception has occurred
            UtilityClass.createApexLogRecord(ex, 'UserMethods', 'updateUserRegionWhenAddressCountryChanges');
        }
    }
    
}