//-----------------------------
// @author: Tran-Vu Tran
// @date: 25 Sep 2017
// @param: NA
// @description: SFDC1-2299 Class to hold Additional Contact Fields trigger methods 
// @return: NA
//-----------------------------
public class AdditionalContactFieldsMethods {

//-----------------------------
// @author: Tran-Vu Tran
// @date: 25 Sep 2017
// @param: TriggerParameters tp
// @description: SFDC1-2299 Whenever a contact is created, whether manually by a user or through an integration/data migration, 
// 				an "Additional Contact Fields" record is automatically created and a link to this record is populated in the contact record.
// 				This function populate the AdditionalContactFields lookup in Contact.
// @return: None
//------------------------------
    public static void populateAdditionalContactFieldsLookupInContact(TriggerParameters tp) {

        //List of Contacts that needs to be updated    
        List <Contact> ContactsToUpdate = new List <Contact>(); 
        List <AdditionalContactFields__c> acfList = tp.newList;
        for(AdditionalContactFields__c acf: acfList) {
            if(acf.ContactReference__c != null) {
                ContactsToUpdate.add(new Contact(Id = acf.ContactReference__c, AdditionalContactFields__c = acf.Id));
            }
        }
        
        //update if list has any records
        if(ContactsToUpdate != null && ContactsToUpdate.size() > 0) {
            update ContactsToUpdate;
        }
    }
}