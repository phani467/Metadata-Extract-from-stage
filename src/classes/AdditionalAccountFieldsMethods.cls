//-----------------------------
// @author: Uttam Arya
// @date: 22 Aug 2017
// @param: NA
// @description: SFDC1-2103 Class to hold Additional Account Fields trigger methods 
// @return: NA
//-----------------------------
public class AdditionalAccountFieldsMethods {

//-----------------------------
// @author: Uttam Arya
// @date: 22 Aug 2017
// @param: TriggerParameters tp
// @description: SFDC1-2103 Whenever an account is created, whether through an integration/data migration or manually created by a Data Governance user an "Additional Account Fields" 
//                          record belonging to the account is automatically created and a link to the record is populated in the "Additional Account Fields" field. 
//                          This function populate the Additional Fields lookup in Account.
//
// @return: None
//------------------------------
    public static void populateAdditionalFiledsLookupInAccount(TriggerParameters tp) {
    
        //List of Accounts that needs to be updated    
        List <Account> AccountsToUpdate = new List <Account>(); 
        
        for(AdditionalAccountFields__c aaf: (List <AdditionalAccountFields__c>) tp.newList) {
            if(aaf.AccountReference__c != null) {
                AccountsToUpdate.add(new Account(Id = aaf.AccountReference__c, AdditionalAccountFields__c = aaf.Id));
            }
        }
        
        //update if list has any records
        if(AccountsToUpdate != null && AccountsToUpdate.size() > 0) {
            update AccountsToUpdate;
        }
    }
}